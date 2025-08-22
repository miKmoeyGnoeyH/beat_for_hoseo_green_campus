import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';

class PedometerController extends GetxController {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
      // _steps = '?';
  final Rx<int?> _steps = 0.obs;
  int? get steps => _steps.value;
  set steps(int? value) => _steps.value = value;

  PedometerController() {
    // initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    // setState(() {
    //   _steps = event.steps.toString();
    // });
    steps = event.steps;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('onPedestrianStatusChanged $event');
    // setState(() {
    //   _status = event.status;
    // });
    _status = event.status;
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    _status = 'Pedestrian Status not available';
    // setState(() {
    //   _status = 'Pedestrian Status not available';
    // });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    steps = null;
    // setState(() {
    //   _steps = 'Step Count not available';
    // });
  }

  // Future<bool> _checkActivityRecognitionPermission() async {
  //   bool granted = await Permission.activityRecognition.isGranted;
  //
  //   if (!granted) {
  //     granted = await Permission.activityRecognition.request() ==
  //         PermissionStatus.granted;
  //   }
  //
  //   return granted;
  // }

  // Future<void> initPlatformState() async {
  //   bool granted = await _checkActivityRecognitionPermission();
  //   if (!granted) {
  //     // tell user, the app will not work
  //   }
  //
  //   _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  //   (await _pedestrianStatusStream.listen(onPedestrianStatusChanged))
  //       .onError(onPedestrianStatusError);
  //
  //   _stepCountStream = Pedometer.stepCountStream;
  //   _stepCountStream.listen(onStepCount).onError(onStepCountError);
  //
  //   if (!mounted) return;
  // }
}