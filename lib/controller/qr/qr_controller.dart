import 'package:BEAT/controller/qr/qr_event.dart';
import 'package:BEAT/data/provider/qr_provider.dart';
import 'package:BEAT/data/states/qr_state.dart';
import 'package:bloc/bloc.dart';

class QRController extends Bloc<QREvent, QRState> {
  QRController() :super(QRInitial()) {
    on<QRCheck>(_onQRCheck);
    on<QRCredit>(_onQRCredit);
    on<QRSign>(_onQRSign);
  }

  void _onQRCheck(QREvent event, Emitter<QRState> emit) async {
    emit(QRLoading());
    final QRState qrState = await qrProvider.handleQRCheckRequest(event.requestUrl, event.authorization);
    emit(qrState);
  }
  void _onQRCredit(QREvent event, Emitter<QRState> emit) async {
    emit(QRLoading());
    final QRState qrState = await qrProvider.handleQRCreditRequest(event.requestUrl, event.authorization);
    emit(qrState);
  }
  void _onQRSign(QREvent event, Emitter<QRState> emit) async {
    emit(QRLoading());
    final QRState qrState = await qrProvider.handleQRSignRequest(event.requestUrl, event.authorization);
    emit(qrState);
  }

  final QRProvider qrProvider = QRProvider();
}