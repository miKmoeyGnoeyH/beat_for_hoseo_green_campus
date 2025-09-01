import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/data/states/nickname_state.dart';
import 'package:beat_flutter/data/provider/nickname_check_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

sealed class NicknameEvent {}

final class NicknameChanged extends NicknameEvent {}

final class NicknameRequest extends NicknameEvent {}

class RegisterNicknameController extends Bloc<NicknameEvent, NicknameState> {
  RegisterNicknameController() : super(NicknameNotChecked()) {
    on<NicknameChanged>((event, emit) => emit(NicknameNotChecked()));
    on<NicknameRequest>(_nicknameRequest);
  }

  Future<void> _nicknameRequest(
      NicknameEvent event, Emitter<NicknameState> emit) async {
    emit(NicknameChecking());

    final String studentId = nicknameController.text;

    NicknameState nicknameState = await Get.showOverlay(
      asyncFunction: () => _nicknameCheckProvider.emailRequest(studentId),
      loadingWidget: const CustomCircularProgressIndicator(),
    );
    emit(nicknameState);

    if (nicknameState is! NicknameChecked) {
      emit(NicknameNotChecked());
    }
  }

  final NicknameCheckProvider _nicknameCheckProvider = NicknameCheckProvider();
  final TextEditingController nicknameController = TextEditingController();
}
