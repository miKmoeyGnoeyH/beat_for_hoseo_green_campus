import 'package:flutter/services.dart';

FilteringTextInputFormatter onlyEnglishAndKoreanAndNumberInputFormatter() {
  return FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Zㄱ-ㅎ가-힣0-9]'));
}

FilteringTextInputFormatter onlyEnglishAndKoreanInputFormatter() {
  return FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Zㄱ-ㅎ가-힣]'));
}

FilteringTextInputFormatter onlyDigitsInputFormatter() => FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

FilteringTextInputFormatter emailInputFormatter() {
  return FilteringTextInputFormatter.allow(
      RegExp(r"^(?=.{1,64}$)([A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)?)$"));
}

FilteringTextInputFormatter denySpaceFormatter() {
  return FilteringTextInputFormatter.deny(
      RegExp(r" "));
}