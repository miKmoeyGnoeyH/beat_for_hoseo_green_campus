import UIKit
import Flutter
import CoreLocation
import flutter_local_notifications
import BackgroundTasks
import CoreMotion
import UserNotifications

let pedometer = CMPedometer()

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var flutterChannel: FlutterMethodChannel?
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
        // 실제 Flutter 통신은 모두 "com.beat.walkreport/channel"을 통해 이루어짐
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
        flutterChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        flutterChannel?.setMethodCallHandler { [weak self] (call, result) in
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
                    self.startBackgroundTasks(isHoliday: false, sendToTime: 0)
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
            } else if call.method == "isMotionPermissionGranted" {
                // 하드웨어 지원 여부와 권한 상태를 모두 확인
                let hardwareAvailable = CMPedometer.isStepCountingAvailable()
                let permissionGranted = CMMotionActivityManager.authorizationStatus() == .authorized
                let granted = hardwareAvailable && permissionGranted
                result(granted)
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
        startPedometer()
        
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
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { data, error in
                if let steps = data?.numberOfSteps {
                    DispatchQueue.main.async {
                        self.flutterChannel?.invokeMethod(
                            "updateStepsFromNative",
                            arguments: ["steps": steps]
                        )
                    }
                }
            }
        }
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
            self.flutterChannel?.invokeMethod("backgroundLocationUpdate", arguments: [
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
    
    /// 걸음 수 동기화 BGTask 스케줄링 (4시간마다 - Apple 가이드라인 준수)
    func scheduleWalkReportBGTask() {
        let request = BGProcessingTaskRequest(identifier: "com.beat.app.walkreport")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 14400) // 4시간 후 (Apple 가이드라인)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ 걸음 수 동기화 BGTask 스케줄 완료 (4시간 후)")
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
        let calendar = Calendar.current
        let now = Date()
        var targetDate: Date
        
        let currentMinute = calendar.component(.minute, from: now)
        let currentSecond = calendar.component(.second, from: now)
        
        if currentMinute > 59 || (currentMinute == 59 && currentSecond >= sendToTime) {
            // 다음 시간의 59분 {sendToTime}초로 설정
            targetDate = calendar.date(byAdding: .hour, value: 1, to: calendar.startOfHour(for: now))!
            targetDate = calendar.date(byAdding: .minute, value: 59, to: targetDate)!
            targetDate = calendar.date(byAdding: .second, value: sendToTime, to: targetDate)!
        } else {
            // 현재 시간의 59분 {sendToTime}초로 설정
            targetDate = calendar.startOfHour(for: now)
            targetDate = calendar.date(byAdding: .minute, value: 59, to: targetDate)!
            targetDate = calendar.date(byAdding: .second, value: sendToTime, to: targetDate)!
        }
        
        request.earliestBeginDate = targetDate
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ 랭킹 집계 BGTask 스케줄 완료: \(targetDate) (59분 \(sendToTime)초)")
            print("✅ 현재 시간: \(Date())")
            print("✅ 다음 실행까지 남은 시간: \(targetDate.timeIntervalSinceNow)초")
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
        print("🌙 현재 시간: \(Date())")
        task.expirationHandler = {
            print("❌ 자정 초기화 BGTask 만료됨")
            task.setTaskCompleted(success: false)
        }
        
        // 다음 스케줄 예약 (BGTask로)
        scheduleMidnightBGTask()
        
        executeMidnightReset { success in
            print("🌙 자정 초기화 BGTask 완료: \(success)")
            task.setTaskCompleted(success: success)
        }
    }
    
    // MARK: - 실제 작업 실행
    
    func executeWalkReportSync(completion: @escaping (Bool) -> Void) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            completion(false)
            return
        }
        
        // Flutter와 통신하기 위한 MethodChannel 생성 (모든 작업이 같은 채널 사용)
        flutterChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        DispatchQueue.main.async {
            self.flutterChannel?.invokeMethod("syncWalkDataInBackground", arguments: nil) { result in
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
        
        // Flutter와 통신하기 위한 MethodChannel 생성 (모든 작업이 같은 채널 사용)
        flutterChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        print("📊 Flutter와 통신하여 랭킹 집계 시작")
        DispatchQueue.main.async {
            self.flutterChannel?.invokeMethod("syncRankingInBackground", arguments: nil) { result in
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
        
        // Flutter와 통신하기 위한 MethodChannel 생성 (모든 작업이 같은 채널 사용)
        flutterChannel = FlutterMethodChannel(
            name: "com.beat.walkreport/channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        print("🌙 Flutter와 통신하여 자정 초기화 시작")
        DispatchQueue.main.async {
            self.flutterChannel?.invokeMethod("midnightReset", arguments: nil) { result in
                print("🌙 자정 초기화 완료: \(String(describing: result))")
                completion(true)
            }
        }
    }
    
    // MARK: - ✅ Flutter 타이머 기능 중 "자정 초기화"만 iOS에서 처리
    var midnightTimer: Timer?
    var eventDurationTimer: Timer?
    
    func startCustomTimers(isHoliday: Bool) {
        invalidateCustomTimers()
        
        // ✅ 자정 타이머 (공휴일 여부 관계없이 항상 실행)
        midnightTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            let second = calendar.component(.second, from: date)
            
            if hour == 0 && minute == 0 && second == 0 {
                self.flutterChannel?.invokeMethod("midnightReset", arguments: nil)
            }
        }
        
        // ✅ 이벤트 타이머 (공휴일 아닐 때만 실행)
        if !isHoliday {
            eventDurationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minute = calendar.component(.minute, from: date)
                let second = calendar.component(.second, from: date)
                
                if hour >= 18 && minute >= 0 && second >= 0 {
                    self.flutterChannel?.invokeMethod("eventDurationReset", arguments: nil)
                }
            }
        }
        
        print("✅ Custom timers started (isHoliday: \(isHoliday))")
    }
    
    func invalidateCustomTimers() {
        midnightTimer?.invalidate()
        midnightTimer = nil
        
        eventDurationTimer?.invalidate()
        eventDurationTimer = nil
        
        print("🛑 Custom timers stopped")
    }
}

extension Calendar {
    func startOfHour(for date: Date) -> Date {
        let components = dateComponents([.year, .month, .day, .hour], from: date)
        return self.date(from: components)!
    }
}
