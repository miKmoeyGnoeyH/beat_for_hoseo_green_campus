// 1) 한글 자모(현대/확장/호환) + 모든 ‘중점’ 계열(·)
final koreanInitialConsonantRegExp = RegExp(
  r'[\u1100-\u11FF\u3130-\u318F\uA960-\uA97F\uD7B0-\uD7FF' // Jamo & Ext
  r'\u00B7\u30FB\u2027\u2219]',                             // ·, ・, ‧, ∙
  unicode: true,
);

// 2) 국제 이름 허용: [문자]+(구분자+[문자]+)*  —> 구분자는 공백/하이픈/아포스트로피
//    길이(예: 1~30자) 제한을 넣고 싶으면 (?=.{1,30}$)를 맨 앞에 추가.
final intlNameRegExp = RegExp(
  r"^(?=.{1,30}$)"                                  // 길이 제한(원하면 조절)
  r"(?:"
  r"[A-Za-z\u00C0-\u00FF\u0100-\u017F\u0180-\u024F\u1E00-\u1EFF"  // Latin + 확장
  r"\uAC00-\uD7A3"                                                // 한글 완성형
  r"\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+"                    // 아랍(기본/보충/확장-A)
  r"(?:[ \-’']"                                                   // 구분자: 공백/하이픈/아포스트로피
  r"[A-Za-z\u00C0-\u00FF\u0100-\u017F\u0180-\u024F\u1E00-\u1EFF"
  r"\uAC00-\uD7A3\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+"
  r")*"
  r")$",
  unicode: true,
);
final RegExp koreanNameRegExp = RegExp(
    r'^(?=.{1,30}$)(?!.*[\u1100-\u11FF\u3130-\u318F])(?!.*[\u00B7\u30FB])(?:[A-Za-z\uAC00-\uD7A3]+(?:[ -][A-Za-z\uAC00-\uD7A3]+)*)$');
final RegExp initialConsonantRegExp = RegExp(r'[ㅏ-ㅣㄱ-ㅎ·\u00B7\u30FB]');
final RegExp emailRegExp = RegExp(
    r"^(?=.{1,64}$)([A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)?)$");
final passwordRegex =
    RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])\S{8,}$');


// 눈에 안 보이는 문자/변형 선택자/소프트 하이픈/양방향 마크/줄 구분자
final _invisibleChars = RegExp(
  r'[\u034F\u061C\u180E\u200B-\u200F\u2028\u2029\u2060\uFEFF\u00AD\uFE00-\uFE0F]',
  unicode: true,
);

// Plane-14 Variation Selectors Supplement (U+E0100–U+E01EF) → 서로게이트 페어: \uDB40[\uDD00-\uDDEF]
final _variationSelectorsSup = RegExp(r'\uDB40[\uDD00-\uDDEF]');

// 특수 공백류를 일반 공백으로
final _weirdSpaces = RegExp(
  r'[\u00A0\u1680\u2000-\u200A\u202F\u205F\u3000]',
  unicode: true,
);

String canonicalizeName(String input) {
  return input
      .replaceAll(_invisibleChars, '')
      .replaceAll(_variationSelectorsSup, '')
      .replaceAll(_weirdSpaces, ' ')
      .trim();
  // (옵션) NFC 정규화가 필요하면 unorm_dart 패키지의 nfc()를 여기에 적용
}