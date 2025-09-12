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
                self.startBackgroundTasks()
                result("Background tasks started")
            } else if call.method == "stopBackgroundTasks" {
                self.stopBackgroundTasks()
                result("Background tasks stopped")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - 로그인 성공 시 호출
    func startBackgroundTasks() {
        scheduleWalkReportTask()
        initLocationTracking()
        startPedometer()
        print("✅ Background tasks started")
    }

    // MARK: - 로그아웃 시 호출
    func stopBackgroundTasks() {
        // 위치 추적 중지
        locationManager?.stopUpdatingLocation()
        locationManager = nil

        // Pedometer 중지 → 객체를 새로 생성해서 덮어씌우는 방식
        // CMPedometer 자체에는 stop 메서드 없음
        // 그냥 pedometer 객체 사용 안 하면 됨
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

    // MARK: - BGTask
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
}
