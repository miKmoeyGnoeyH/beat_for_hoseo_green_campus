import UIKit
import Flutter
import CoreLocation
import flutter_local_notifications
import BackgroundTasks
import CoreMotion

let pedometer = CMPedometer()

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var flutterChannel: FlutterMethodChannel?
    
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
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.beat.app.walkreport", using: nil) { task in
            self.handleWalkReportTask(task: task as! BGProcessingTask)
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
                   let isHoliday = args["isHoliday"] as? Bool {
                    self.startBackgroundTasks(isHoliday: isHoliday)
                } else {
                    self.startBackgroundTasks(isHoliday: false)
                }
                result("Background tasks started")
                
            } else if call.method == "stopBackgroundTasks" {
                self.stopBackgroundTasks()
                result("Background tasks stopped")
                
            } else if call.method == "updateHolidayStatus" {
                if let args = call.arguments as? [String: Any],
                   let isHoliday = args["isHoliday"] as? Bool {
                    // ✅ 공휴일 상태 업데이트 반영
                    self.invalidateCustomTimers()
                    self.startCustomTimers(isHoliday: isHoliday)
                    
                    if isHoliday {
                        self.locationManager?.stopUpdatingLocation()
                        print("🛑 Holiday: location tracking/event timer stopped")
                    } else {
                        self.initLocationTracking()
                        print("✅ Holiday ended: location tracking/event timer resumed")
                    }
                }
                result("Holiday status updated")
            } else if call.method == "isMotionPermissionGranted" {
                let granted = CMPedometer.isStepCountingAvailable()
                result(granted)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: - 로그인 성공 시 호출
    func startBackgroundTasks(isHoliday: Bool) {
        scheduleWalkReportTask()
        startPedometer()
        startCustomTimers(isHoliday: isHoliday)   // ✅ 커스텀 타이머 시작
        
        // 공휴일 여부에 따라 위치 추적 처리
        if !isHoliday {
            initLocationTracking()
            print("✅ Background tasks started (isHoliday: false)")
        } else {
            print("✅ Background tasks started (isHoliday: true) — location tracking stopped, event timer disabled")
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
        
        // 커스텀 타이머 해제
        invalidateCustomTimers()
        
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
    
    // MARK: - BGTask (1시간마다 동기화)
    func scheduleWalkReportTask() {
        let request = BGProcessingTaskRequest(identifier: "com.beat.app.walkreport")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ BGTask scheduled")
        } catch {
            print("❌ Failed to schedule BGTask: \(error)")
        }
    }
    
    func handleWalkReportTask(task: BGProcessingTask) {
        print("📡 BGTask started")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        scheduleWalkReportTask()
        
        if let controller = window?.rootViewController as? FlutterViewController {
            flutterChannel = FlutterMethodChannel(
                name: "com.beat.walkreport/channel",
                binaryMessenger: controller.binaryMessenger
            )
            
            DispatchQueue.main.async {
                self.flutterChannel?.invokeMethod("syncWalkDataInBackground", arguments: nil) { result in
                    print("📬 syncWalkDataInBackground complete: \(String(describing: result))")
                    task.setTaskCompleted(success: true)
                }
            }
        } else {
            task.setTaskCompleted(success: false)
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
