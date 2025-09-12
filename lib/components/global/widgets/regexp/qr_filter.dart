// deprecated
final RegExp qrRawValueFileterCheck = RegExp(r'https://beat.hoseo.ac.kr/event/qr/mission/check/([0-9]+)');
final RegExp qrRawValueFileterCheckDebug = RegExp(r'^http://192.168.1.11:8080/event/qr/mission/check/([0-9]+)$');
final RegExp qrRawValueFileterCredit = RegExp(r'https://beat.hoseo.ac.kr/qr/credit/([0-9]+)');
final RegExp qrRawValueFileterCreditDebug = RegExp(r'^http://192.168.1.11:8080/event/qr/mission/check/([0-9]+)$');
final RegExp qrRawValueFileterSign = RegExp(r'https://beat.hoseo.ac.kr/qr/sign/([0-9]+)');
final RegExp qrRawValueFileterSignDebug = RegExp(r'^http://192.168.1.11:8080/event/qr/mission/check/([0-9]+)$');

// valid
final RegExp qrRawValueFilterRelease = RegExp(r'https://beat.hoseo.ac.kr/event/qr/mission/check/([0-9]+)');
final RegExp qrRawValueFilterDebug = RegExp(r'^http://192.168.1.11:8080/event/qr/mission/check/([0-9]+)$');