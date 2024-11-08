import 'package:BEAT/controller/qr/qr_event.dart';
import 'package:BEAT/data/provider/qr_provider.dart';
import 'package:BEAT/data/states/qr_state.dart';
import 'package:bloc/bloc.dart';

class QRController extends Bloc<QREvent, QRState> {
  QRController() :super(QRInitial()) {
    // on<QRCheck>();
    on<QRCredit>(_onQRCredit);
    // on<QRSign>();
  }

  void _onQRCheck(QREvent event, Emitter<QRState> emit) {}
  void _onQRCredit(QREvent event, Emitter<QRState> emit) async {
    emit(QRLoading());
    final QRState qrState = await qrProvider.handleQRCreditRequest(event.requestUrl, event.authorization);
    emit(qrState);
  }
  void _onQRSign(QREvent event, Emitter<QRState> emit) {}

  final QRProvider qrProvider = QRProvider();
}