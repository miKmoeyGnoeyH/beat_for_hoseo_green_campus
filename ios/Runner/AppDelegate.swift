import UIKit
import Flutter
import CoreLocation
import flutter_local_notifications
import BackgroundTasks
import CoreMotion
import UserNotifications

let pedometer = CMPedometer()
let activityManager = CMMotionActivityManager()

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var pedometerChannel: FlutterMethodChannel?
    var locationChannel: FlutterMethodChannel?
    var sendToTime: Int = 0 // 랭킹 집계 시간 (초)
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 플러그인 등록
        GeneratedPluginRegistrant.register(with: self)
        
        // 로컬 알림 등록
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
            GeneratedPluginRegistrant.register(with: registry)
        } 
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        // BGTask 등록
        // BGTask 등록 - 백그라운드에서 작업을 실행하기 위한 iOS 시스템 레벨 태스크
        // 실제 Flutter 통신은 pedometer/location 각 채널을 통해 이루어짐
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.beat.app.walkreport", using: nil) { task in
            self.handleWalkReportTask(task: task as! BGProcessingTask)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.beat.app.ranking", using: nil) { task in
            self.handleRankingTask(task: task as! BGProcessingTask)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.beat.app.midnight", using: nil) { task in
            self.handleMidnightTask(task: task as! BGProcessingTask)
        }
        
        // 🔑 MethodChannel 등록
        if let controller = window?.rootViewController as? FlutterViewController {
            setupMethodChannel(controller: controller)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - MethodChannel 세팅
    func setupMethodChannel(controller: FlutterViewController) {
        // 보행 채널
        pedometerChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/pedometer",
            binaryMessenger: controller.binaryMessenger
        )

        // 위치 채널
        locationChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/location",
            binaryMessenger: controller.binaryMessenger
        )

        // 위치 관련 핸들러만 위치 채널에 등록
//         locationChannel 핸들러
//         "startBackgroundTasks"   4시간 단위 걸음 수 동기화 시작, 랭킹 집계 시작, 자정 초기화 시작
//                                  위치 추적 시작
//        
//         "stopBackgroundTasks"    위치 추적 중지
//                                  4시간 단위 걸음 수 동기화 중지, 랭킹 집계 중지, 자정 초기화 중지
//        
//         "updateHolidayStatus"    isHoliday가 true이면 위치 추적 중지
//                                  isHoliday가 false이면 위치 추적 재시작
        locationChannel?.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            if call.method == "startBackgroundTasks" {
                if let args = call.arguments as? [String: Any],
                   let isHoliday = args["isHoliday"] as? Bool,
                   let sendToTime = args["sendToTime"] as? Int {
                    self.startBackgroundTasks(isHoliday: isHoliday, sendToTime: sendToTime)
                } else if let args = call.arguments as? [String: Any],
                          let isHoliday = args["isHoliday"] as? Bool {
                    // sendToTime이 없는 경우 기본값 0 사용
                    self.startBackgroundTasks(isHoliday: isHoliday, sendToTime: 0)
                } else {
                    // 모든 인자가 없는 경우 기본값 사용
                    self.startBackgroundTasks(isHoliday: true, sendToTime: 0)
                }
                result("Background tasks started")
                
            } else if call.method == "stopBackgroundTasks" {
                self.stopBackgroundTasks()
                result("Background tasks stopped")
                
            } else if call.method == "updateHolidayStatus" {
                if let args = call.arguments as? [String: Any],
                   let isHoliday = args["isHoliday"] as? Bool {
                    // ✅ 공휴일 상태 업데이트 반영 (BGTask는 계속 동작)
                    if isHoliday {
                        self.locationManager?.stopUpdatingLocation()
                        print("🛑 Holiday: location tracking stopped (BGTask는 계속 동작)")
                    } else {
                        self.initLocationTracking()
                        print("✅ Holiday ended: location tracking resumed (BGTask는 계속 동작)")
                    }
                }
                result("Holiday status updated")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        // 보행 관련 핸들러는 보행 채널에 등록
//         "isMotionPermissionGranted"  활동 권한이 부여되었는지 확인
//                                      iOS는 안드로이드와 달리 permission_handler 패키지를 사용해 활동 권한을 정확히 받아올 수 없음.
//                                      메소드 채널을 통해 iOS 네이티브에서 권한 부여 여부를 정확히 확인하고 플러터 UI isolate에 전달
//        
//         "startPedometer"             걸음 수 측정 시작. 걸음 수 이벤트 발생 시마다 메소드 채널 핸들러를 통해 플러터 UI isolate에 전달
//        
//         "stopPedometer"              걸음 수 측정 중지
//        
//         "startActivityUpdates"       보행 상태 추적 시작
//        
//         "stopActivityUpdates"        보행 상태 추적 중지
        pedometerChannel?.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            if call.method == "isMotionPermissionGranted" {
                let hardwareAvailable = CMPedometer.isStepCountingAvailable()
                let permissionGranted = CMMotionActivityManager.authorizationStatus() == .authorized
                let granted = hardwareAvailable && permissionGranted
                result(granted)
            } else if call.method == "startPedometer" {
                startPedometer()
                result("Pedometer Started")
            } else if call.method == "stopPedometer" {
                stopPedometer()
                result("Pedometer Stopped")
            } else if call.method == "startActivityUpdates" {
                startActivityUpdates()
                result("ActivityUpdate Started")
            } else if call.method == "stopActivityUpdates" {
                stopActivityUpdates()
                result("ActivityUpdate Stopped")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: - 로그인 성공 시 호출
    func startBackgroundTasks(isHoliday: Bool, sendToTime: Int) {
        // sendToTime 저장
        self.sendToTime = sendToTime
        print("✅ sendToTime 설정됨: \(sendToTime)")
        
        // BGTaskScheduler 전용 스케줄링 시스템 시작
        scheduleAllBackgroundTasks(sendToTime: sendToTime)
//        startPedometer()
        
        // 공휴일 여부에 따라 위치 추적 처리
        if !isHoliday {
            initLocationTracking()
            print("✅ Background tasks started (isHoliday: false, sendToTime: \(sendToTime))")
        } else {
            print("✅ Background tasks started (isHoliday: true, sendToTime: \(sendToTime)) — location tracking stopped, event timer disabled")
        }
    }
    
    // MARK: - 로그아웃 시 호출
    func stopBackgroundTasks() {
        // 만보기 중지
//        stopPedometer()
        
        // 위치 추적 중지
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        
        // Pedometer 중지
        print("🛑 Pedometer updates stopped")
        
        // BGTask 취소
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        print("🛑 Background tasks stopped")
    }
    
    // MARK: - Pedometer
    func startPedometer() {
        stopPedometer()

        if CMPedometer.isStepCountingAvailable() {
            let from = Calendar.current.startOfDay(for: Date())
            pedometer.startUpdates(from: from) { data, _ in
                guard let steps = data?.numberOfSteps else { return }
                // ✅ 반드시 메인 스레드에서 호출
                DispatchQueue.main.async {
                    self.pedometerChannel?.invokeMethod(
                        "updateStepsFromNative",
                        arguments: ["steps": steps.intValue]
                    )
                }
            }
        }
    }
    
    func stopPedometer() {
        print("iOS : stopPedometer() called")
        pedometer.stopUpdates();
    }
    
    func startActivityUpdates() {
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
                guard let activity = activity else { return }

                let status: String
                if activity.walking || activity.running {
                    status = "walking"
                } else if activity.stationary {
                    status = "stopped"
                } else {
                    status = "unknown"
                }

                // ✅ 혹시 모를 상황 대비하여 메인 보장
                DispatchQueue.main.async {
                    self.pedometerChannel?.invokeMethod(
                        "updatePedestrianStatus",
                        arguments: ["status": status]
                    )
                }
            }
        }
    }

    func stopActivityUpdates() {
        activityManager.stopActivityUpdates()
    }
    
    // MARK: - 위치 추적
    func initLocationTracking() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        DispatchQueue.main.async {
            self.locationChannel?.invokeMethod("backgroundLocationUpdate", arguments: [
                "latitude": lat,
                "longitude": lon
            ])
        }
    }
    
    // MARK: - BGTaskScheduler 전용 스케줄링 시스템
    
    /// BGTaskScheduler만 사용하는 백그라운드 작업 스케줄링
    func scheduleAllBackgroundTasks(sendToTime: Int) {
        scheduleWalkReportBGTask()
        scheduleRankingBGTask(sendToTime: sendToTime)
        scheduleMidnightBGTask()
        print("✅ 모든 BGTask 스케줄 완료 (sendToTime: \(sendToTime))")
    }
    
    /// 걸음 수 동기화 BGTask 스케줄링 (매시간 59분 {sendToTime}초)
    func scheduleWalkReportBGTask(sendToTime: Int) {
        let request = BGProcessingTaskRequest(identifier: "com.beat.app.walkreport")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        // 다음 59분 {sendToTime}초 목표 시각 계산 (랭킹과 동일)
        let cal = Calendar.current
        let now = Date()

        // startOfHour(for:) 확장이 없다면 아래 대체 라인 사용:
        // let startOfHour = cal.dateInterval(of: .hour, for: now)!.start
        var target = cal.startOfHour(for: now)
        target = cal.date(byAdding: .minute, value: 59, to: target)!
        target = cal.date(byAdding: .second, value: sendToTime, to: target)!

        // 지금이 이미 해당 시각을 지난 경우 → 다음 시간으로 밀기
        if cal.component(.minute, from: now) == 59 && cal.component(.second, from: now) >= sendToTime {
            target = cal.date(byAdding: .hour, value: 1, to: target)!
        }

        request.earliestBeginDate = target

        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ 걸음 수 동기화 BGTask 스케줄 완료: \(target) (59분 \(sendToTime)초)")
            print("✅ 현재 시간: \(Date())")
            print("✅ 다음 실행까지 남은 시간: \(target.timeIntervalSinceNow)초")
        } catch {
            print("❌ 걸음 수 동기화 BGTask 스케줄 실패: \(error)")
        }
    }
    
    /// 랭킹 집계 BGTask 스케줄링 (매시간 59분 {sendToTime}초)
    func scheduleRankingBGTask(sendToTime: Int) {
        let request = BGProcessingTaskRequest(identifier: "com.beat.app.ranking")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        // 다음 59분 {sendToTime}초까지의 시간 계산
        let cal = Calendar.current
        let now = Date()
        var target = cal.startOfHour(for: now)
        target = cal.date(byAdding: .minute, value: 59, to: target)!
        target = cal.date(byAdding: .second, value: sendToTime, to: target)!
        if cal.component(.minute, from: now) == 59 && cal.component(.second, from: now) >= sendToTime {
            target = cal.date(byAdding: .hour, value: 1, to: target)!
        }
        request.earliestBeginDate = target
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ 랭킹 집계 BGTask 스케줄 완료: \(target) (59분 \(sendToTime)초)")
            print("✅ 현재 시간: \(Date())")
            print("✅ 다음 실행까지 남은 시간: \(target.timeIntervalSinceNow)초")
        } catch {
            print("❌ 랭킹 집계 BGTask 스케줄 실패: \(error)")
        }
    }
    
    /// 자정 초기화 BGTask 스케줄링 (매일 자정)
    func scheduleMidnightBGTask() {
        let request = BGProcessingTaskRequest(identifier: "com.beat.app.midnight")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        
        // 다음 자정까지의 시간 계산
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let midnight = calendar.startOfDay(for: tomorrow)
        
        request.earliestBeginDate = midnight
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ 자정 초기화 BGTask 스케줄 완료: \(midnight)")
            print("✅ 현재 시간: \(Date())")
            print("✅ 다음 자정까지 남은 시간: \(midnight.timeIntervalSinceNow)초")
        } catch {
            print("❌ 자정 초기화 BGTask 스케줄 실패: \(error)")
        }
    }
    
//    func scheduleMidnightBGTask() {
//        let request = BGProcessingTaskRequest(identifier: "com.beat.app.midnight")
//        request.requiresNetworkConnectivity = false
//        request.requiresExternalPower = false
//        
//        // ✅ 테스트: 5분 뒤 실행
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//            print("✅ 테스트 모드: 5분 뒤 자정 초기화 BGTask 실행 예정")
//        } catch {
//            print("❌ 자정 초기화 BGTask 스케줄 실패: \(error)")
//        }
//    }
    
    // MARK: - BGTask 핸들러들
    
    func handleWalkReportTask(task: BGProcessingTask) {
        print("📡 걸음 수 동기화 BGTask 시작")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // 다음 스케줄 예약 (BGTask로)
        scheduleWalkReportBGTask()
        
        executeWalkReportSync { success in
            task.setTaskCompleted(success: success)
        }
    }
    
    func handleRankingTask(task: BGProcessingTask) {
        print("📊 랭킹 집계 BGTask 시작 (sendToTime: \(sendToTime))")
        print("📊 현재 시간: \(Date())")
        task.expirationHandler = {
            print("❌ 랭킹 집계 BGTask 만료됨")
            task.setTaskCompleted(success: false)
        }
        
        // 다음 스케줄 예약 (BGTask로, sendToTime 전달)
        scheduleRankingBGTask(sendToTime: sendToTime)
        
        executeRankingSync { success in
            print("📊 랭킹 집계 BGTask 완료: \(success)")
            task.setTaskCompleted(success: success)
        }
    }
    
    func handleMidnightTask(task: BGProcessingTask) {
        print("🌙 자정 초기화 BGTask 시작")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        scheduleMidnightBGTask() // 다음 자정 예약

        executeMidnightReset { success in
            task.setTaskCompleted(success: success)
        }
    }
    
    // MARK: - 실제 작업 실행
    
    func executeWalkReportSync(completion: @escaping (Bool) -> Void) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            completion(false)
            return
        }
        
        // 위치 채널 사용
        locationChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/location",
            binaryMessenger: controller.binaryMessenger
        )

        DispatchQueue.main.async {
            self.locationChannel?.invokeMethod("syncWalkDataInBackground", arguments: nil) { result in
                print("📬 걸음 수 동기화 완료: \(String(describing: result))")
                completion(true)
            }
        }
    }
    
    func executeRankingSync(completion: @escaping (Bool) -> Void) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("❌ FlutterViewController를 찾을 수 없음")
            completion(false)
            return
        }
        
        // 위치 채널 사용
        locationChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/location",
            binaryMessenger: controller.binaryMessenger
        )
        
        print("📊 Flutter와 통신하여 랭킹 집계 시작")
        DispatchQueue.main.async {
            self.locationChannel?.invokeMethod("syncRankingInBackground", arguments: nil) { result in
                print("📊 랭킹 집계 완료: \(String(describing: result))")
                completion(true)
            }
        }
    }
    
    func executeMidnightReset(completion: @escaping (Bool) -> Void) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("❌ FlutterViewController를 찾을 수 없음")
            completion(false)
            return
        }
        
        // 위치 채널 사용
        locationChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/location",
            binaryMessenger: controller.binaryMessenger
        )
        
        print("🌙 Flutter와 통신하여 자정 초기화 시작")
        DispatchQueue.main.async {
            self.locationChannel?.invokeMethod("midnightReset", arguments: nil) { result in
                print("🌙 자정 초기화 완료: \(String(describing: result))")
                completion(true)
            }
        }
    }
    
    // MARK: - ✅ Flutter 타이머 기능 중 "자정 초기화"만 iOS에서 처리
//    var midnightTimer: Timer?
//    var eventDurationTimer: Timer?
    
//    func startCustomTimers(isHoliday: Bool) {
//        invalidateCustomTimers()
//        
//        // ✅ 자정 타이머 (공휴일 여부 관계없이 항상 실행)
//        midnightTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            let date = Date()
//            let calendar = Calendar.current
//            let hour = calendar.component(.hour, from: date)
//            let minute = calendar.component(.minute, from: date)
//            let second = calendar.component(.second, from: date)
//            
//            if hour == 0 && minute == 0 && second == 0 {
//                self.locationChannel?.invokeMethod("midnightReset", arguments: nil)
//            }
//        }
//        
//        // ✅ 이벤트 타이머 (공휴일 아닐 때만 실행)
////        if !isHoliday {
////            eventDurationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
////                let date = Date()
////                let calendar = Calendar.current
////                let hour = calendar.component(.hour, from: date)
////                let minute = calendar.component(.minute, from: date)
////                let second = calendar.component(.second, from: date)
////                
////                if hour >= 18 && minute >= 0 && second >= 0 {
////                    self.locationChannel?.invokeMethod("eventDurationReset", arguments: nil)
////                }
////            }
////        }
//        
//        print("✅ Custom timers started (isHoliday: \(isHoliday))")
//    }
//    
//    func invalidateCustomTimers() {
//        midnightTimer?.invalidate()
//        midnightTimer = nil
//        
////        eventDurationTimer?.invalidate()
////        eventDurationTimer = nil
//        
//        print("🛑 Custom timers stopped")
//    }
}

extension Calendar {
    func startOfHour(for date: Date) -> Date {
        let components = dateComponents([.year, .month, .day, .hour], from: date)
        return self.date(from: components)!
    }
}
