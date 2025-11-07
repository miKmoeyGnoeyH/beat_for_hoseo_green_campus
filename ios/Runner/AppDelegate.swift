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
                    self.startBackgroundTasks(isHoliday: isHoliday, sendToTime: 0)
                } else {
                    self.startBackgroundTasks(isHoliday: true, sendToTime: 0)
                }
                result("Background tasks started")
                
            } else if call.method == "stopBackgroundTasks" {
                self.stopBackgroundTasks()
                result("Background tasks stopped")
                
            } else if call.method == "updateHolidayStatus" {
                if let args = call.arguments as? [String: Any],
                   let isHoliday = args["isHoliday"] as? Bool {
                    if isHoliday {
                        self.locationManager?.stopUpdatingLocation()
                        self.locationManager = nil
                    } else {
                        self.initLocationTracking()
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
            } else if call.method == "getStepsSinceMidnight" {
                let cal = Calendar.current
                let now = Date()
                let from = cal.startOfDay(for: now)
                if CMPedometer.isStepCountingAvailable() {
                    pedometer.queryPedometerData(from: from, to: now) { data, _ in
                        let steps = data?.numberOfSteps.intValue ?? 0
                        result(steps)
                    }
                } else {
                    result(0)
                }
            } else if call.method == "startPedometer" {
                startPedometer()
                print("pedometerChannel: Pedometer Background Task Started.")
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
        self.sendToTime = sendToTime

        if isHoliday {
            locationManager?.stopUpdatingLocation()
            locationManager = nil
            print("Holiday: location tracking ensured stopped")
        } else {
            initLocationTracking()
            print("Workday: location tracking started")
        }
    }
    
    // MARK: - 로그아웃 시 호출
    func stopBackgroundTasks() {
        // 위치 추적 중지
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    // MARK: - Pedometer
    func startPedometer() {
        stopPedometer()

        if CMPedometer.isStepCountingAvailable() {
            let from = Calendar.current.startOfDay(for: Date())
            pedometer.startUpdates(from: from) { data, _ in
                guard let steps = data?.numberOfSteps else { return }
                DispatchQueue.main.async {
                    self.pedometerChannel?.invokeMethod(
                        "updateStepsFromNative",
                        arguments: ["steps": steps.intValue]
                    )
                }
            }
        }
        
        print("iOS startPedometer Called.")
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
        print("iOS startActivityUpdate Called.")
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
        
        print("iOS initLocationTracking Called.")
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
}

extension Calendar {
    func startOfHour(for date: Date) -> Date {
        let components = dateComponents([.year, .month, .day, .hour], from: date)
        return self.date(from: components)!
    }
}
