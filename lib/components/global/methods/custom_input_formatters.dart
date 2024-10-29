import 'package:flutter/services.dart';

FilteringTextInputFormatter onlyEnglishAndKoreanInputFormatter() {
  return FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Zㄱ-ㅎ가-힣]'));
}

FilteringTextInputFormatter onlyDigitsInputFormatter() => FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));