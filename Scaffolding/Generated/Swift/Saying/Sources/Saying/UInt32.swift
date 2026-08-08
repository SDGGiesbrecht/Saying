func _0028_0029의_0020자모_003AUnicode_0020scalar_0020numerical_0020value_003AUnicode_0020scalars(_ 글자_0020마디: UInt32) -> String.UnicodeScalarView {
  let 글자_0020마디의_0020색인: UInt32 = 글자_0020마디 &- 첫_0020글자_0020마디_003AUnicode_0020scalar_0020numerical_0020value()
  var 자모: String.UnicodeScalarView = "".unicodeScalars
  자모.append(Unicode.Scalar(skippingValidityCheck: 첫_0020초성_003AUnicode_0020scalar_0020numerical_0020value() &+ 글자_0020마디의_0020색인 / 최종_0020쌍의_0020수_003AUnicode_0020scalar_0020numerical_0020value()))
  자모.append(Unicode.Scalar(skippingValidityCheck: 첫_0020중성_003AUnicode_0020scalar_0020numerical_0020value() &+ 글자_0020마디의_0020색인 % 최종_0020쌍의_0020수_003AUnicode_0020scalar_0020numerical_0020value() / 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value()))
  let 종성의_0020색인: UInt32 = 글자_0020마디의_0020색인 % 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value()
  if 종성의_0020색인 > 0x0 {
    자모.append(Unicode.Scalar(skippingValidityCheck: 첫_0020종성_0020직전_003AUnicode_0020scalar_0020numerical_0020value() &+ 종성의_0020색인))
  }
  return 자모
}

func canonical_0020combining_0020class_0020of_0020_0028_0029_003AUnicode_0020scalar_0020numerical_0020value_003A8_2010bit_0020natural_0020number(_ scalar: UInt32) -> UInt8 {
  if scalar <= 0x02FF {
    return 0
  }
  if scalar <= 0x0314 {
    return 230
  }
  if scalar <= 0x0315 {
    return 232
  }
  if scalar <= 0x0319 {
    return 220
  }
  if scalar <= 0x031A {
    return 232
  }
  if scalar <= 0x031B {
    return 216
  }
  if scalar <= 0x0320 {
    return 220
  }
  if scalar <= 0x0322 {
    return 202
  }
  if scalar <= 0x0326 {
    return 220
  }
  if scalar <= 0x0328 {
    return 202
  }
  if scalar <= 0x0333 {
    return 220
  }
  if scalar <= 0x0338 {
    return 1
  }
  if scalar <= 0x033C {
    return 220
  }
  if scalar <= 0x0344 {
    return 230
  }
  if scalar <= 0x0345 {
    return 240
  }
  if scalar <= 0x0346 {
    return 230
  }
  if scalar <= 0x0349 {
    return 220
  }
  if scalar <= 0x034C {
    return 230
  }
  if scalar <= 0x034E {
    return 220
  }
  if scalar <= 0x034F {
    return 0
  }
  if scalar <= 0x0352 {
    return 230
  }
  if scalar <= 0x0356 {
    return 220
  }
  if scalar <= 0x0357 {
    return 230
  }
  if scalar <= 0x0358 {
    return 232
  }
  if scalar <= 0x035A {
    return 220
  }
  if scalar <= 0x035B {
    return 230
  }
  if scalar <= 0x035C {
    return 233
  }
  if scalar <= 0x035E {
    return 234
  }
  if scalar <= 0x035F {
    return 233
  }
  if scalar <= 0x0361 {
    return 234
  }
  if scalar <= 0x0362 {
    return 233
  }
  if scalar <= 0x036F {
    return 230
  }
  if scalar <= 0x0482 {
    return 0
  }
  if scalar <= 0x0487 {
    return 230
  }
  if scalar <= 0x0590 {
    return 0
  }
  if scalar <= 0x0591 {
    return 220
  }
  if scalar <= 0x0595 {
    return 230
  }
  if scalar <= 0x0596 {
    return 220
  }
  if scalar <= 0x0599 {
    return 230
  }
  if scalar <= 0x059A {
    return 222
  }
  if scalar <= 0x059B {
    return 220
  }
  if scalar <= 0x05A1 {
    return 230
  }
  if scalar <= 0x05A7 {
    return 220
  }
  if scalar <= 0x05A9 {
    return 230
  }
  if scalar <= 0x05AA {
    return 220
  }
  if scalar <= 0x05AC {
    return 230
  }
  if scalar <= 0x05AD {
    return 222
  }
  if scalar <= 0x05AE {
    return 228
  }
  if scalar <= 0x05AF {
    return 230
  }
  if scalar <= 0x05B0 {
    return 10
  }
  if scalar <= 0x05B1 {
    return 11
  }
  if scalar <= 0x05B2 {
    return 12
  }
  if scalar <= 0x05B3 {
    return 13
  }
  if scalar <= 0x05B4 {
    return 14
  }
  if scalar <= 0x05B5 {
    return 15
  }
  if scalar <= 0x05B6 {
    return 16
  }
  if scalar <= 0x05B7 {
    return 17
  }
  if scalar <= 0x05B8 {
    return 18
  }
  if scalar <= 0x05BA {
    return 19
  }
  if scalar <= 0x05BB {
    return 20
  }
  if scalar <= 0x05BC {
    return 21
  }
  if scalar <= 0x05BD {
    return 22
  }
  if scalar <= 0x05BE {
    return 0
  }
  if scalar <= 0x05BF {
    return 23
  }
  if scalar <= 0x05C0 {
    return 0
  }
  if scalar <= 0x05C1 {
    return 24
  }
  if scalar <= 0x05C2 {
    return 25
  }
  if scalar <= 0x05C3 {
    return 0
  }
  if scalar <= 0x05C4 {
    return 230
  }
  if scalar <= 0x05C5 {
    return 220
  }
  if scalar <= 0x05C6 {
    return 0
  }
  if scalar <= 0x05C7 {
    return 18
  }
  if scalar <= 0x060F {
    return 0
  }
  if scalar <= 0x0617 {
    return 230
  }
  if scalar <= 0x0618 {
    return 30
  }
  if scalar <= 0x0619 {
    return 31
  }
  if scalar <= 0x061A {
    return 32
  }
  if scalar <= 0x064A {
    return 0
  }
  if scalar <= 0x064B {
    return 27
  }
  if scalar <= 0x064C {
    return 28
  }
  if scalar <= 0x064D {
    return 29
  }
  if scalar <= 0x064E {
    return 30
  }
  if scalar <= 0x064F {
    return 31
  }
  if scalar <= 0x0650 {
    return 32
  }
  if scalar <= 0x0651 {
    return 33
  }
  if scalar <= 0x0652 {
    return 34
  }
  if scalar <= 0x0654 {
    return 230
  }
  if scalar <= 0x0656 {
    return 220
  }
  if scalar <= 0x065B {
    return 230
  }
  if scalar <= 0x065C {
    return 220
  }
  if scalar <= 0x065E {
    return 230
  }
  if scalar <= 0x065F {
    return 220
  }
  if scalar <= 0x066F {
    return 0
  }
  if scalar <= 0x0670 {
    return 35
  }
  if scalar <= 0x06D5 {
    return 0
  }
  if scalar <= 0x06DC {
    return 230
  }
  if scalar <= 0x06DE {
    return 0
  }
  if scalar <= 0x06E2 {
    return 230
  }
  if scalar <= 0x06E3 {
    return 220
  }
  if scalar <= 0x06E4 {
    return 230
  }
  if scalar <= 0x06E6 {
    return 0
  }
  if scalar <= 0x06E8 {
    return 230
  }
  if scalar <= 0x06E9 {
    return 0
  }
  if scalar <= 0x06EA {
    return 220
  }
  if scalar <= 0x06EC {
    return 230
  }
  if scalar <= 0x06ED {
    return 220
  }
  if scalar <= 0x0710 {
    return 0
  }
  if scalar <= 0x0711 {
    return 36
  }
  if scalar <= 0x072F {
    return 0
  }
  if scalar <= 0x0730 {
    return 230
  }
  if scalar <= 0x0731 {
    return 220
  }
  if scalar <= 0x0733 {
    return 230
  }
  if scalar <= 0x0734 {
    return 220
  }
  if scalar <= 0x0736 {
    return 230
  }
  if scalar <= 0x0739 {
    return 220
  }
  if scalar <= 0x073A {
    return 230
  }
  if scalar <= 0x073C {
    return 220
  }
  if scalar <= 0x073D {
    return 230
  }
  if scalar <= 0x073E {
    return 220
  }
  if scalar <= 0x0741 {
    return 230
  }
  if scalar <= 0x0742 {
    return 220
  }
  if scalar <= 0x0743 {
    return 230
  }
  if scalar <= 0x0744 {
    return 220
  }
  if scalar <= 0x0745 {
    return 230
  }
  if scalar <= 0x0746 {
    return 220
  }
  if scalar <= 0x0747 {
    return 230
  }
  if scalar <= 0x0748 {
    return 220
  }
  if scalar <= 0x074A {
    return 230
  }
  if scalar <= 0x07EA {
    return 0
  }
  if scalar <= 0x07F1 {
    return 230
  }
  if scalar <= 0x07F2 {
    return 220
  }
  if scalar <= 0x07F3 {
    return 230
  }
  if scalar <= 0x07FC {
    return 0
  }
  if scalar <= 0x07FD {
    return 220
  }
  if scalar <= 0x0815 {
    return 0
  }
  if scalar <= 0x0819 {
    return 230
  }
  if scalar <= 0x081A {
    return 0
  }
  if scalar <= 0x0823 {
    return 230
  }
  if scalar <= 0x0824 {
    return 0
  }
  if scalar <= 0x0827 {
    return 230
  }
  if scalar <= 0x0828 {
    return 0
  }
  if scalar <= 0x082D {
    return 230
  }
  if scalar <= 0x0858 {
    return 0
  }
  if scalar <= 0x085B {
    return 220
  }
  if scalar <= 0x0896 {
    return 0
  }
  if scalar <= 0x0898 {
    return 230
  }
  if scalar <= 0x089B {
    return 220
  }
  if scalar <= 0x089F {
    return 230
  }
  if scalar <= 0x08C9 {
    return 0
  }
  if scalar <= 0x08CE {
    return 230
  }
  if scalar <= 0x08D3 {
    return 220
  }
  if scalar <= 0x08E1 {
    return 230
  }
  if scalar <= 0x08E2 {
    return 0
  }
  if scalar <= 0x08E3 {
    return 220
  }
  if scalar <= 0x08E5 {
    return 230
  }
  if scalar <= 0x08E6 {
    return 220
  }
  if scalar <= 0x08E8 {
    return 230
  }
  if scalar <= 0x08E9 {
    return 220
  }
  if scalar <= 0x08EC {
    return 230
  }
  if scalar <= 0x08EF {
    return 220
  }
  if scalar <= 0x08F0 {
    return 27
  }
  if scalar <= 0x08F1 {
    return 28
  }
  if scalar <= 0x08F2 {
    return 29
  }
  if scalar <= 0x08F5 {
    return 230
  }
  if scalar <= 0x08F6 {
    return 220
  }
  if scalar <= 0x08F8 {
    return 230
  }
  if scalar <= 0x08FA {
    return 220
  }
  if scalar <= 0x08FF {
    return 230
  }
  if scalar <= 0x093B {
    return 0
  }
  if scalar <= 0x093C {
    return 7
  }
  if scalar <= 0x094C {
    return 0
  }
  if scalar <= 0x094D {
    return 9
  }
  if scalar <= 0x0950 {
    return 0
  }
  if scalar <= 0x0951 {
    return 230
  }
  if scalar <= 0x0952 {
    return 220
  }
  if scalar <= 0x0954 {
    return 230
  }
  if scalar <= 0x09BB {
    return 0
  }
  if scalar <= 0x09BC {
    return 7
  }
  if scalar <= 0x09CC {
    return 0
  }
  if scalar <= 0x09CD {
    return 9
  }
  if scalar <= 0x09FD {
    return 0
  }
  if scalar <= 0x09FE {
    return 230
  }
  if scalar <= 0x0A3B {
    return 0
  }
  if scalar <= 0x0A3C {
    return 7
  }
  if scalar <= 0x0A4C {
    return 0
  }
  if scalar <= 0x0A4D {
    return 9
  }
  if scalar <= 0x0ABB {
    return 0
  }
  if scalar <= 0x0ABC {
    return 7
  }
  if scalar <= 0x0ACC {
    return 0
  }
  if scalar <= 0x0ACD {
    return 9
  }
  if scalar <= 0x0B3B {
    return 0
  }
  if scalar <= 0x0B3C {
    return 7
  }
  if scalar <= 0x0B4C {
    return 0
  }
  if scalar <= 0x0B4D {
    return 9
  }
  if scalar <= 0x0BCC {
    return 0
  }
  if scalar <= 0x0BCD {
    return 9
  }
  if scalar <= 0x0C3B {
    return 0
  }
  if scalar <= 0x0C3C {
    return 7
  }
  if scalar <= 0x0C4C {
    return 0
  }
  if scalar <= 0x0C4D {
    return 9
  }
  if scalar <= 0x0C54 {
    return 0
  }
  if scalar <= 0x0C55 {
    return 84
  }
  if scalar <= 0x0C56 {
    return 91
  }
  if scalar <= 0x0CBB {
    return 0
  }
  if scalar <= 0x0CBC {
    return 7
  }
  if scalar <= 0x0CCC {
    return 0
  }
  if scalar <= 0x0CCD {
    return 9
  }
  if scalar <= 0x0D3A {
    return 0
  }
  if scalar <= 0x0D3C {
    return 9
  }
  if scalar <= 0x0D4C {
    return 0
  }
  if scalar <= 0x0D4D {
    return 9
  }
  if scalar <= 0x0DC9 {
    return 0
  }
  if scalar <= 0x0DCA {
    return 9
  }
  if scalar <= 0x0E37 {
    return 0
  }
  if scalar <= 0x0E39 {
    return 103
  }
  if scalar <= 0x0E3A {
    return 9
  }
  if scalar <= 0x0E47 {
    return 0
  }
  if scalar <= 0x0E4B {
    return 107
  }
  if scalar <= 0x0EB7 {
    return 0
  }
  if scalar <= 0x0EB9 {
    return 118
  }
  if scalar <= 0x0EBA {
    return 9
  }
  if scalar <= 0x0EC7 {
    return 0
  }
  if scalar <= 0x0ECB {
    return 122
  }
  if scalar <= 0x0F17 {
    return 0
  }
  if scalar <= 0x0F19 {
    return 220
  }
  if scalar <= 0x0F34 {
    return 0
  }
  if scalar <= 0x0F35 {
    return 220
  }
  if scalar <= 0x0F36 {
    return 0
  }
  if scalar <= 0x0F37 {
    return 220
  }
  if scalar <= 0x0F38 {
    return 0
  }
  if scalar <= 0x0F39 {
    return 216
  }
  if scalar <= 0x0F70 {
    return 0
  }
  if scalar <= 0x0F71 {
    return 129
  }
  if scalar <= 0x0F72 {
    return 130
  }
  if scalar <= 0x0F73 {
    return 0
  }
  if scalar <= 0x0F74 {
    return 132
  }
  if scalar <= 0x0F79 {
    return 0
  }
  if scalar <= 0x0F7D {
    return 130
  }
  if scalar <= 0x0F7F {
    return 0
  }
  if scalar <= 0x0F80 {
    return 130
  }
  if scalar <= 0x0F81 {
    return 0
  }
  if scalar <= 0x0F83 {
    return 230
  }
  if scalar <= 0x0F84 {
    return 9
  }
  if scalar <= 0x0F85 {
    return 0
  }
  if scalar <= 0x0F87 {
    return 230
  }
  if scalar <= 0x0FC5 {
    return 0
  }
  if scalar <= 0x0FC6 {
    return 220
  }
  if scalar <= 0x1036 {
    return 0
  }
  if scalar <= 0x1037 {
    return 7
  }
  if scalar <= 0x1038 {
    return 0
  }
  if scalar <= 0x103A {
    return 9
  }
  if scalar <= 0x108C {
    return 0
  }
  if scalar <= 0x108D {
    return 220
  }
  if scalar <= 0x135C {
    return 0
  }
  if scalar <= 0x135F {
    return 230
  }
  if scalar <= 0x1713 {
    return 0
  }
  if scalar <= 0x1715 {
    return 9
  }
  if scalar <= 0x1733 {
    return 0
  }
  if scalar <= 0x1734 {
    return 9
  }
  if scalar <= 0x17D1 {
    return 0
  }
  if scalar <= 0x17D2 {
    return 9
  }
  if scalar <= 0x17DC {
    return 0
  }
  if scalar <= 0x17DD {
    return 230
  }
  if scalar <= 0x18A8 {
    return 0
  }
  if scalar <= 0x18A9 {
    return 228
  }
  if scalar <= 0x1938 {
    return 0
  }
  if scalar <= 0x1939 {
    return 222
  }
  if scalar <= 0x193A {
    return 230
  }
  if scalar <= 0x193B {
    return 220
  }
  if scalar <= 0x1A16 {
    return 0
  }
  if scalar <= 0x1A17 {
    return 230
  }
  if scalar <= 0x1A18 {
    return 220
  }
  if scalar <= 0x1A5F {
    return 0
  }
  if scalar <= 0x1A60 {
    return 9
  }
  if scalar <= 0x1A74 {
    return 0
  }
  if scalar <= 0x1A7C {
    return 230
  }
  if scalar <= 0x1A7E {
    return 0
  }
  if scalar <= 0x1A7F {
    return 220
  }
  if scalar <= 0x1AAF {
    return 0
  }
  if scalar <= 0x1AB4 {
    return 230
  }
  if scalar <= 0x1ABA {
    return 220
  }
  if scalar <= 0x1ABC {
    return 230
  }
  if scalar <= 0x1ABD {
    return 220
  }
  if scalar <= 0x1ABE {
    return 0
  }
  if scalar <= 0x1AC0 {
    return 220
  }
  if scalar <= 0x1AC2 {
    return 230
  }
  if scalar <= 0x1AC4 {
    return 220
  }
  if scalar <= 0x1AC9 {
    return 230
  }
  if scalar <= 0x1ACA {
    return 220
  }
  if scalar <= 0x1ADC {
    return 230
  }
  if scalar <= 0x1ADD {
    return 220
  }
  if scalar <= 0x1ADF {
    return 0
  }
  if scalar <= 0x1AE5 {
    return 230
  }
  if scalar <= 0x1AE6 {
    return 220
  }
  if scalar <= 0x1AEA {
    return 230
  }
  if scalar <= 0x1AEB {
    return 234
  }
  if scalar <= 0x1B33 {
    return 0
  }
  if scalar <= 0x1B34 {
    return 7
  }
  if scalar <= 0x1B43 {
    return 0
  }
  if scalar <= 0x1B44 {
    return 9
  }
  if scalar <= 0x1B6A {
    return 0
  }
  if scalar <= 0x1B6B {
    return 230
  }
  if scalar <= 0x1B6C {
    return 220
  }
  if scalar <= 0x1B73 {
    return 230
  }
  if scalar <= 0x1BA9 {
    return 0
  }
  if scalar <= 0x1BAB {
    return 9
  }
  if scalar <= 0x1BE5 {
    return 0
  }
  if scalar <= 0x1BE6 {
    return 7
  }
  if scalar <= 0x1BF1 {
    return 0
  }
  if scalar <= 0x1BF3 {
    return 9
  }
  if scalar <= 0x1C36 {
    return 0
  }
  if scalar <= 0x1C37 {
    return 7
  }
  if scalar <= 0x1CCF {
    return 0
  }
  if scalar <= 0x1CD2 {
    return 230
  }
  if scalar <= 0x1CD3 {
    return 0
  }
  if scalar <= 0x1CD4 {
    return 1
  }
  if scalar <= 0x1CD9 {
    return 220
  }
  if scalar <= 0x1CDB {
    return 230
  }
  if scalar <= 0x1CDF {
    return 220
  }
  if scalar <= 0x1CE0 {
    return 230
  }
  if scalar <= 0x1CE1 {
    return 0
  }
  if scalar <= 0x1CE8 {
    return 1
  }
  if scalar <= 0x1CEC {
    return 0
  }
  if scalar <= 0x1CED {
    return 220
  }
  if scalar <= 0x1CF3 {
    return 0
  }
  if scalar <= 0x1CF4 {
    return 230
  }
  if scalar <= 0x1CF7 {
    return 0
  }
  if scalar <= 0x1CF9 {
    return 230
  }
  if scalar <= 0x1DBF {
    return 0
  }
  if scalar <= 0x1DC1 {
    return 230
  }
  if scalar <= 0x1DC2 {
    return 220
  }
  if scalar <= 0x1DC9 {
    return 230
  }
  if scalar <= 0x1DCA {
    return 220
  }
  if scalar <= 0x1DCC {
    return 230
  }
  if scalar <= 0x1DCD {
    return 234
  }
  if scalar <= 0x1DCE {
    return 214
  }
  if scalar <= 0x1DCF {
    return 220
  }
  if scalar <= 0x1DD0 {
    return 202
  }
  if scalar <= 0x1DF5 {
    return 230
  }
  if scalar <= 0x1DF6 {
    return 232
  }
  if scalar <= 0x1DF8 {
    return 228
  }
  if scalar <= 0x1DF9 {
    return 220
  }
  if scalar <= 0x1DFA {
    return 218
  }
  if scalar <= 0x1DFB {
    return 230
  }
  if scalar <= 0x1DFC {
    return 233
  }
  if scalar <= 0x1DFD {
    return 220
  }
  if scalar <= 0x1DFE {
    return 230
  }
  if scalar <= 0x1DFF {
    return 220
  }
  if scalar <= 0x20CF {
    return 0
  }
  if scalar <= 0x20D1 {
    return 230
  }
  if scalar <= 0x20D3 {
    return 1
  }
  if scalar <= 0x20D7 {
    return 230
  }
  if scalar <= 0x20DA {
    return 1
  }
  if scalar <= 0x20DC {
    return 230
  }
  if scalar <= 0x20E0 {
    return 0
  }
  if scalar <= 0x20E1 {
    return 230
  }
  if scalar <= 0x20E4 {
    return 0
  }
  if scalar <= 0x20E6 {
    return 1
  }
  if scalar <= 0x20E7 {
    return 230
  }
  if scalar <= 0x20E8 {
    return 220
  }
  if scalar <= 0x20E9 {
    return 230
  }
  if scalar <= 0x20EB {
    return 1
  }
  if scalar <= 0x20EF {
    return 220
  }
  if scalar <= 0x20F0 {
    return 230
  }
  if scalar <= 0x2CEE {
    return 0
  }
  if scalar <= 0x2CF1 {
    return 230
  }
  if scalar <= 0x2D7E {
    return 0
  }
  if scalar <= 0x2D7F {
    return 9
  }
  if scalar <= 0x2DDF {
    return 0
  }
  if scalar <= 0x2DFF {
    return 230
  }
  if scalar <= 0x3029 {
    return 0
  }
  if scalar <= 0x302A {
    return 218
  }
  if scalar <= 0x302B {
    return 228
  }
  if scalar <= 0x302C {
    return 232
  }
  if scalar <= 0x302D {
    return 222
  }
  if scalar <= 0x302F {
    return 224
  }
  if scalar <= 0x3098 {
    return 0
  }
  if scalar <= 0x309A {
    return 8
  }
  if scalar <= 0xA66E {
    return 0
  }
  if scalar <= 0xA66F {
    return 230
  }
  if scalar <= 0xA673 {
    return 0
  }
  if scalar <= 0xA67D {
    return 230
  }
  if scalar <= 0xA69D {
    return 0
  }
  if scalar <= 0xA69F {
    return 230
  }
  if scalar <= 0xA6EF {
    return 0
  }
  if scalar <= 0xA6F1 {
    return 230
  }
  if scalar <= 0xA805 {
    return 0
  }
  if scalar <= 0xA806 {
    return 9
  }
  if scalar <= 0xA82B {
    return 0
  }
  if scalar <= 0xA82C {
    return 9
  }
  if scalar <= 0xA8C3 {
    return 0
  }
  if scalar <= 0xA8C4 {
    return 9
  }
  if scalar <= 0xA8DF {
    return 0
  }
  if scalar <= 0xA8F1 {
    return 230
  }
  if scalar <= 0xA92A {
    return 0
  }
  if scalar <= 0xA92D {
    return 220
  }
  if scalar <= 0xA952 {
    return 0
  }
  if scalar <= 0xA953 {
    return 9
  }
  if scalar <= 0xA9B2 {
    return 0
  }
  if scalar <= 0xA9B3 {
    return 7
  }
  if scalar <= 0xA9BF {
    return 0
  }
  if scalar <= 0xA9C0 {
    return 9
  }
  if scalar <= 0xAAAF {
    return 0
  }
  if scalar <= 0xAAB0 {
    return 230
  }
  if scalar <= 0xAAB1 {
    return 0
  }
  if scalar <= 0xAAB3 {
    return 230
  }
  if scalar <= 0xAAB4 {
    return 220
  }
  if scalar <= 0xAAB6 {
    return 0
  }
  if scalar <= 0xAAB8 {
    return 230
  }
  if scalar <= 0xAABD {
    return 0
  }
  if scalar <= 0xAABF {
    return 230
  }
  if scalar <= 0xAAC0 {
    return 0
  }
  if scalar <= 0xAAC1 {
    return 230
  }
  if scalar <= 0xAAF5 {
    return 0
  }
  if scalar <= 0xAAF6 {
    return 9
  }
  if scalar <= 0xABEC {
    return 0
  }
  if scalar <= 0xABED {
    return 9
  }
  if scalar <= 0xFB1D {
    return 0
  }
  if scalar <= 0xFB1E {
    return 26
  }
  if scalar <= 0xFE1F {
    return 0
  }
  if scalar <= 0xFE26 {
    return 230
  }
  if scalar <= 0xFE2D {
    return 220
  }
  if scalar <= 0xFE2F {
    return 230
  }
  if scalar <= 0x101FC {
    return 0
  }
  if scalar <= 0x101FD {
    return 220
  }
  if scalar <= 0x102DF {
    return 0
  }
  if scalar <= 0x102E0 {
    return 220
  }
  if scalar <= 0x10375 {
    return 0
  }
  if scalar <= 0x1037A {
    return 230
  }
  if scalar <= 0x10A0C {
    return 0
  }
  if scalar <= 0x10A0D {
    return 220
  }
  if scalar <= 0x10A0E {
    return 0
  }
  if scalar <= 0x10A0F {
    return 230
  }
  if scalar <= 0x10A37 {
    return 0
  }
  if scalar <= 0x10A38 {
    return 230
  }
  if scalar <= 0x10A39 {
    return 1
  }
  if scalar <= 0x10A3A {
    return 220
  }
  if scalar <= 0x10A3E {
    return 0
  }
  if scalar <= 0x10A3F {
    return 9
  }
  if scalar <= 0x10AE4 {
    return 0
  }
  if scalar <= 0x10AE5 {
    return 230
  }
  if scalar <= 0x10AE6 {
    return 220
  }
  if scalar <= 0x10D23 {
    return 0
  }
  if scalar <= 0x10D27 {
    return 230
  }
  if scalar <= 0x10D68 {
    return 0
  }
  if scalar <= 0x10D6D {
    return 230
  }
  if scalar <= 0x10EAA {
    return 0
  }
  if scalar <= 0x10EAC {
    return 230
  }
  if scalar <= 0x10EF9 {
    return 0
  }
  if scalar <= 0x10EFB {
    return 220
  }
  if scalar <= 0x10EFC {
    return 0
  }
  if scalar <= 0x10EFF {
    return 220
  }
  if scalar <= 0x10F45 {
    return 0
  }
  if scalar <= 0x10F47 {
    return 220
  }
  if scalar <= 0x10F4A {
    return 230
  }
  if scalar <= 0x10F4B {
    return 220
  }
  if scalar <= 0x10F4C {
    return 230
  }
  if scalar <= 0x10F50 {
    return 220
  }
  if scalar <= 0x10F81 {
    return 0
  }
  if scalar <= 0x10F82 {
    return 230
  }
  if scalar <= 0x10F83 {
    return 220
  }
  if scalar <= 0x10F84 {
    return 230
  }
  if scalar <= 0x10F85 {
    return 220
  }
  if scalar <= 0x11045 {
    return 0
  }
  if scalar <= 0x11046 {
    return 9
  }
  if scalar <= 0x1106F {
    return 0
  }
  if scalar <= 0x11070 {
    return 9
  }
  if scalar <= 0x1107E {
    return 0
  }
  if scalar <= 0x1107F {
    return 9
  }
  if scalar <= 0x110B8 {
    return 0
  }
  if scalar <= 0x110B9 {
    return 9
  }
  if scalar <= 0x110BA {
    return 7
  }
  if scalar <= 0x110FF {
    return 0
  }
  if scalar <= 0x11102 {
    return 230
  }
  if scalar <= 0x11132 {
    return 0
  }
  if scalar <= 0x11134 {
    return 9
  }
  if scalar <= 0x11172 {
    return 0
  }
  if scalar <= 0x11173 {
    return 7
  }
  if scalar <= 0x111BF {
    return 0
  }
  if scalar <= 0x111C0 {
    return 9
  }
  if scalar <= 0x111C9 {
    return 0
  }
  if scalar <= 0x111CA {
    return 7
  }
  if scalar <= 0x11234 {
    return 0
  }
  if scalar <= 0x11235 {
    return 9
  }
  if scalar <= 0x11236 {
    return 7
  }
  if scalar <= 0x112E8 {
    return 0
  }
  if scalar <= 0x112E9 {
    return 7
  }
  if scalar <= 0x112EA {
    return 9
  }
  if scalar <= 0x1133A {
    return 0
  }
  if scalar <= 0x1133C {
    return 7
  }
  if scalar <= 0x1134C {
    return 0
  }
  if scalar <= 0x1134D {
    return 9
  }
  if scalar <= 0x11365 {
    return 0
  }
  if scalar <= 0x1136C {
    return 230
  }
  if scalar <= 0x1136F {
    return 0
  }
  if scalar <= 0x11374 {
    return 230
  }
  if scalar <= 0x113CD {
    return 0
  }
  if scalar <= 0x113D0 {
    return 9
  }
  if scalar <= 0x11441 {
    return 0
  }
  if scalar <= 0x11442 {
    return 9
  }
  if scalar <= 0x11445 {
    return 0
  }
  if scalar <= 0x11446 {
    return 7
  }
  if scalar <= 0x1145D {
    return 0
  }
  if scalar <= 0x1145E {
    return 230
  }
  if scalar <= 0x114C1 {
    return 0
  }
  if scalar <= 0x114C2 {
    return 9
  }
  if scalar <= 0x114C3 {
    return 7
  }
  if scalar <= 0x115BE {
    return 0
  }
  if scalar <= 0x115BF {
    return 9
  }
  if scalar <= 0x115C0 {
    return 7
  }
  if scalar <= 0x1163E {
    return 0
  }
  if scalar <= 0x1163F {
    return 9
  }
  if scalar <= 0x116B5 {
    return 0
  }
  if scalar <= 0x116B6 {
    return 9
  }
  if scalar <= 0x116B7 {
    return 7
  }
  if scalar <= 0x1172A {
    return 0
  }
  if scalar <= 0x1172B {
    return 9
  }
  if scalar <= 0x11838 {
    return 0
  }
  if scalar <= 0x11839 {
    return 9
  }
  if scalar <= 0x1183A {
    return 7
  }
  if scalar <= 0x1193C {
    return 0
  }
  if scalar <= 0x1193E {
    return 9
  }
  if scalar <= 0x11942 {
    return 0
  }
  if scalar <= 0x11943 {
    return 7
  }
  if scalar <= 0x119DF {
    return 0
  }
  if scalar <= 0x119E0 {
    return 9
  }
  if scalar <= 0x11A33 {
    return 0
  }
  if scalar <= 0x11A34 {
    return 9
  }
  if scalar <= 0x11A46 {
    return 0
  }
  if scalar <= 0x11A47 {
    return 9
  }
  if scalar <= 0x11A98 {
    return 0
  }
  if scalar <= 0x11A99 {
    return 9
  }
  if scalar <= 0x11C3E {
    return 0
  }
  if scalar <= 0x11C3F {
    return 9
  }
  if scalar <= 0x11D41 {
    return 0
  }
  if scalar <= 0x11D42 {
    return 7
  }
  if scalar <= 0x11D43 {
    return 0
  }
  if scalar <= 0x11D45 {
    return 9
  }
  if scalar <= 0x11D96 {
    return 0
  }
  if scalar <= 0x11D97 {
    return 9
  }
  if scalar <= 0x11F40 {
    return 0
  }
  if scalar <= 0x11F42 {
    return 9
  }
  if scalar <= 0x1612E {
    return 0
  }
  if scalar <= 0x1612F {
    return 9
  }
  if scalar <= 0x16AEF {
    return 0
  }
  if scalar <= 0x16AF4 {
    return 1
  }
  if scalar <= 0x16B2F {
    return 0
  }
  if scalar <= 0x16B36 {
    return 230
  }
  if scalar <= 0x16FEF {
    return 0
  }
  if scalar <= 0x16FF1 {
    return 6
  }
  if scalar <= 0x1BC9D {
    return 0
  }
  if scalar <= 0x1BC9E {
    return 1
  }
  if scalar <= 0x1D164 {
    return 0
  }
  if scalar <= 0x1D166 {
    return 216
  }
  if scalar <= 0x1D169 {
    return 1
  }
  if scalar <= 0x1D16C {
    return 0
  }
  if scalar <= 0x1D16D {
    return 226
  }
  if scalar <= 0x1D172 {
    return 216
  }
  if scalar <= 0x1D17A {
    return 0
  }
  if scalar <= 0x1D182 {
    return 220
  }
  if scalar <= 0x1D184 {
    return 0
  }
  if scalar <= 0x1D189 {
    return 230
  }
  if scalar <= 0x1D18B {
    return 220
  }
  if scalar <= 0x1D1A9 {
    return 0
  }
  if scalar <= 0x1D1AD {
    return 230
  }
  if scalar <= 0x1D241 {
    return 0
  }
  if scalar <= 0x1D244 {
    return 230
  }
  if scalar <= 0x1DFFF {
    return 0
  }
  if scalar <= 0x1E006 {
    return 230
  }
  if scalar <= 0x1E007 {
    return 0
  }
  if scalar <= 0x1E018 {
    return 230
  }
  if scalar <= 0x1E01A {
    return 0
  }
  if scalar <= 0x1E021 {
    return 230
  }
  if scalar <= 0x1E022 {
    return 0
  }
  if scalar <= 0x1E024 {
    return 230
  }
  if scalar <= 0x1E025 {
    return 0
  }
  if scalar <= 0x1E02A {
    return 230
  }
  if scalar <= 0x1E08E {
    return 0
  }
  if scalar <= 0x1E08F {
    return 230
  }
  if scalar <= 0x1E12F {
    return 0
  }
  if scalar <= 0x1E136 {
    return 230
  }
  if scalar <= 0x1E2AD {
    return 0
  }
  if scalar <= 0x1E2AE {
    return 230
  }
  if scalar <= 0x1E2EB {
    return 0
  }
  if scalar <= 0x1E2EF {
    return 230
  }
  if scalar <= 0x1E4EB {
    return 0
  }
  if scalar <= 0x1E4ED {
    return 232
  }
  if scalar <= 0x1E4EE {
    return 220
  }
  if scalar <= 0x1E4EF {
    return 230
  }
  if scalar <= 0x1E5ED {
    return 0
  }
  if scalar <= 0x1E5EE {
    return 230
  }
  if scalar <= 0x1E5EF {
    return 220
  }
  if scalar <= 0x1E6E2 {
    return 0
  }
  if scalar <= 0x1E6E3 {
    return 230
  }
  if scalar <= 0x1E6E5 {
    return 0
  }
  if scalar <= 0x1E6E6 {
    return 230
  }
  if scalar <= 0x1E6ED {
    return 0
  }
  if scalar <= 0x1E6EF {
    return 230
  }
  if scalar <= 0x1E6F4 {
    return 0
  }
  if scalar <= 0x1E6F5 {
    return 230
  }
  if scalar <= 0x1E8CF {
    return 0
  }
  if scalar <= 0x1E8D6 {
    return 220
  }
  if scalar <= 0x1E943 {
    return 0
  }
  if scalar <= 0x1E949 {
    return 230
  }
  if scalar <= 0x1E94A {
    return 7
  }
  return 0
}

func compatibility_0020decomposition_0020quick_0020check_0020of_0020_0028_0029_003AUnicode_0020scalar_0020numerical_0020value_003Aערך_0020אמת(_ scalar: UInt32) -> Bool {
  if scalar <= 0x009F {
    return true
  }
  if scalar <= 0x00A0 {
    return false
  }
  if scalar <= 0x00A7 {
    return true
  }
  if scalar <= 0x00A8 {
    return false
  }
  if scalar <= 0x00A9 {
    return true
  }
  if scalar <= 0x00AA {
    return false
  }
  if scalar <= 0x00AE {
    return true
  }
  if scalar <= 0x00AF {
    return false
  }
  if scalar <= 0x00B1 {
    return true
  }
  if scalar <= 0x00B5 {
    return false
  }
  if scalar <= 0x00B7 {
    return true
  }
  if scalar <= 0x00BA {
    return false
  }
  if scalar <= 0x00BB {
    return true
  }
  if scalar <= 0x00BE {
    return false
  }
  if scalar <= 0x00BF {
    return true
  }
  if scalar <= 0x00C5 {
    return false
  }
  if scalar <= 0x00C6 {
    return true
  }
  if scalar <= 0x00CF {
    return false
  }
  if scalar <= 0x00D0 {
    return true
  }
  if scalar <= 0x00D6 {
    return false
  }
  if scalar <= 0x00D8 {
    return true
  }
  if scalar <= 0x00DD {
    return false
  }
  if scalar <= 0x00DF {
    return true
  }
  if scalar <= 0x00E5 {
    return false
  }
  if scalar <= 0x00E6 {
    return true
  }
  if scalar <= 0x00EF {
    return false
  }
  if scalar <= 0x00F0 {
    return true
  }
  if scalar <= 0x00F6 {
    return false
  }
  if scalar <= 0x00F8 {
    return true
  }
  if scalar <= 0x00FD {
    return false
  }
  if scalar <= 0x00FE {
    return true
  }
  if scalar <= 0x010F {
    return false
  }
  if scalar <= 0x0111 {
    return true
  }
  if scalar <= 0x0125 {
    return false
  }
  if scalar <= 0x0127 {
    return true
  }
  if scalar <= 0x0130 {
    return false
  }
  if scalar <= 0x0131 {
    return true
  }
  if scalar <= 0x0137 {
    return false
  }
  if scalar <= 0x0138 {
    return true
  }
  if scalar <= 0x0140 {
    return false
  }
  if scalar <= 0x0142 {
    return true
  }
  if scalar <= 0x0149 {
    return false
  }
  if scalar <= 0x014B {
    return true
  }
  if scalar <= 0x0151 {
    return false
  }
  if scalar <= 0x0153 {
    return true
  }
  if scalar <= 0x0165 {
    return false
  }
  if scalar <= 0x0167 {
    return true
  }
  if scalar <= 0x017F {
    return false
  }
  if scalar <= 0x019F {
    return true
  }
  if scalar <= 0x01A1 {
    return false
  }
  if scalar <= 0x01AE {
    return true
  }
  if scalar <= 0x01B0 {
    return false
  }
  if scalar <= 0x01C3 {
    return true
  }
  if scalar <= 0x01DC {
    return false
  }
  if scalar <= 0x01DD {
    return true
  }
  if scalar <= 0x01E3 {
    return false
  }
  if scalar <= 0x01E5 {
    return true
  }
  if scalar <= 0x01F5 {
    return false
  }
  if scalar <= 0x01F7 {
    return true
  }
  if scalar <= 0x021B {
    return false
  }
  if scalar <= 0x021D {
    return true
  }
  if scalar <= 0x021F {
    return false
  }
  if scalar <= 0x0225 {
    return true
  }
  if scalar <= 0x0233 {
    return false
  }
  if scalar <= 0x02AF {
    return true
  }
  if scalar <= 0x02B8 {
    return false
  }
  if scalar <= 0x02D7 {
    return true
  }
  if scalar <= 0x02DD {
    return false
  }
  if scalar <= 0x02DF {
    return true
  }
  if scalar <= 0x02E4 {
    return false
  }
  if scalar <= 0x033F {
    return true
  }
  if scalar <= 0x0341 {
    return false
  }
  if scalar <= 0x0342 {
    return true
  }
  if scalar <= 0x0344 {
    return false
  }
  if scalar <= 0x0373 {
    return true
  }
  if scalar <= 0x0374 {
    return false
  }
  if scalar <= 0x0379 {
    return true
  }
  if scalar <= 0x037A {
    return false
  }
  if scalar <= 0x037D {
    return true
  }
  if scalar <= 0x037E {
    return false
  }
  if scalar <= 0x0383 {
    return true
  }
  if scalar <= 0x038A {
    return false
  }
  if scalar <= 0x038B {
    return true
  }
  if scalar <= 0x038C {
    return false
  }
  if scalar <= 0x038D {
    return true
  }
  if scalar <= 0x0390 {
    return false
  }
  if scalar <= 0x03A9 {
    return true
  }
  if scalar <= 0x03B0 {
    return false
  }
  if scalar <= 0x03C9 {
    return true
  }
  if scalar <= 0x03CE {
    return false
  }
  if scalar <= 0x03CF {
    return true
  }
  if scalar <= 0x03D6 {
    return false
  }
  if scalar <= 0x03EF {
    return true
  }
  if scalar <= 0x03F2 {
    return false
  }
  if scalar <= 0x03F3 {
    return true
  }
  if scalar <= 0x03F5 {
    return false
  }
  if scalar <= 0x03F8 {
    return true
  }
  if scalar <= 0x03F9 {
    return false
  }
  if scalar <= 0x03FF {
    return true
  }
  if scalar <= 0x0401 {
    return false
  }
  if scalar <= 0x0402 {
    return true
  }
  if scalar <= 0x0403 {
    return false
  }
  if scalar <= 0x0406 {
    return true
  }
  if scalar <= 0x0407 {
    return false
  }
  if scalar <= 0x040B {
    return true
  }
  if scalar <= 0x040E {
    return false
  }
  if scalar <= 0x0418 {
    return true
  }
  if scalar <= 0x0419 {
    return false
  }
  if scalar <= 0x0438 {
    return true
  }
  if scalar <= 0x0439 {
    return false
  }
  if scalar <= 0x044F {
    return true
  }
  if scalar <= 0x0451 {
    return false
  }
  if scalar <= 0x0452 {
    return true
  }
  if scalar <= 0x0453 {
    return false
  }
  if scalar <= 0x0456 {
    return true
  }
  if scalar <= 0x0457 {
    return false
  }
  if scalar <= 0x045B {
    return true
  }
  if scalar <= 0x045E {
    return false
  }
  if scalar <= 0x0475 {
    return true
  }
  if scalar <= 0x0477 {
    return false
  }
  if scalar <= 0x04C0 {
    return true
  }
  if scalar <= 0x04C2 {
    return false
  }
  if scalar <= 0x04CF {
    return true
  }
  if scalar <= 0x04D3 {
    return false
  }
  if scalar <= 0x04D5 {
    return true
  }
  if scalar <= 0x04D7 {
    return false
  }
  if scalar <= 0x04D9 {
    return true
  }
  if scalar <= 0x04DF {
    return false
  }
  if scalar <= 0x04E1 {
    return true
  }
  if scalar <= 0x04E7 {
    return false
  }
  if scalar <= 0x04E9 {
    return true
  }
  if scalar <= 0x04F5 {
    return false
  }
  if scalar <= 0x04F7 {
    return true
  }
  if scalar <= 0x04F9 {
    return false
  }
  if scalar <= 0x0586 {
    return true
  }
  if scalar <= 0x0587 {
    return false
  }
  if scalar <= 0x0621 {
    return true
  }
  if scalar <= 0x0626 {
    return false
  }
  if scalar <= 0x0674 {
    return true
  }
  if scalar <= 0x0678 {
    return false
  }
  if scalar <= 0x06BF {
    return true
  }
  if scalar <= 0x06C0 {
    return false
  }
  if scalar <= 0x06C1 {
    return true
  }
  if scalar <= 0x06C2 {
    return false
  }
  if scalar <= 0x06D2 {
    return true
  }
  if scalar <= 0x06D3 {
    return false
  }
  if scalar <= 0x0928 {
    return true
  }
  if scalar <= 0x0929 {
    return false
  }
  if scalar <= 0x0930 {
    return true
  }
  if scalar <= 0x0931 {
    return false
  }
  if scalar <= 0x0933 {
    return true
  }
  if scalar <= 0x0934 {
    return false
  }
  if scalar <= 0x0957 {
    return true
  }
  if scalar <= 0x095F {
    return false
  }
  if scalar <= 0x09CA {
    return true
  }
  if scalar <= 0x09CC {
    return false
  }
  if scalar <= 0x09DB {
    return true
  }
  if scalar <= 0x09DD {
    return false
  }
  if scalar <= 0x09DE {
    return true
  }
  if scalar <= 0x09DF {
    return false
  }
  if scalar <= 0x0A32 {
    return true
  }
  if scalar <= 0x0A33 {
    return false
  }
  if scalar <= 0x0A35 {
    return true
  }
  if scalar <= 0x0A36 {
    return false
  }
  if scalar <= 0x0A58 {
    return true
  }
  if scalar <= 0x0A5B {
    return false
  }
  if scalar <= 0x0A5D {
    return true
  }
  if scalar <= 0x0A5E {
    return false
  }
  if scalar <= 0x0B47 {
    return true
  }
  if scalar <= 0x0B48 {
    return false
  }
  if scalar <= 0x0B4A {
    return true
  }
  if scalar <= 0x0B4C {
    return false
  }
  if scalar <= 0x0B5B {
    return true
  }
  if scalar <= 0x0B5D {
    return false
  }
  if scalar <= 0x0B93 {
    return true
  }
  if scalar <= 0x0B94 {
    return false
  }
  if scalar <= 0x0BC9 {
    return true
  }
  if scalar <= 0x0BCC {
    return false
  }
  if scalar <= 0x0C47 {
    return true
  }
  if scalar <= 0x0C48 {
    return false
  }
  if scalar <= 0x0CBF {
    return true
  }
  if scalar <= 0x0CC0 {
    return false
  }
  if scalar <= 0x0CC6 {
    return true
  }
  if scalar <= 0x0CC8 {
    return false
  }
  if scalar <= 0x0CC9 {
    return true
  }
  if scalar <= 0x0CCB {
    return false
  }
  if scalar <= 0x0D49 {
    return true
  }
  if scalar <= 0x0D4C {
    return false
  }
  if scalar <= 0x0DD9 {
    return true
  }
  if scalar <= 0x0DDA {
    return false
  }
  if scalar <= 0x0DDB {
    return true
  }
  if scalar <= 0x0DDE {
    return false
  }
  if scalar <= 0x0E32 {
    return true
  }
  if scalar <= 0x0E33 {
    return false
  }
  if scalar <= 0x0EB2 {
    return true
  }
  if scalar <= 0x0EB3 {
    return false
  }
  if scalar <= 0x0EDB {
    return true
  }
  if scalar <= 0x0EDD {
    return false
  }
  if scalar <= 0x0F0B {
    return true
  }
  if scalar <= 0x0F0C {
    return false
  }
  if scalar <= 0x0F42 {
    return true
  }
  if scalar <= 0x0F43 {
    return false
  }
  if scalar <= 0x0F4C {
    return true
  }
  if scalar <= 0x0F4D {
    return false
  }
  if scalar <= 0x0F51 {
    return true
  }
  if scalar <= 0x0F52 {
    return false
  }
  if scalar <= 0x0F56 {
    return true
  }
  if scalar <= 0x0F57 {
    return false
  }
  if scalar <= 0x0F5B {
    return true
  }
  if scalar <= 0x0F5C {
    return false
  }
  if scalar <= 0x0F68 {
    return true
  }
  if scalar <= 0x0F69 {
    return false
  }
  if scalar <= 0x0F72 {
    return true
  }
  if scalar <= 0x0F73 {
    return false
  }
  if scalar <= 0x0F74 {
    return true
  }
  if scalar <= 0x0F79 {
    return false
  }
  if scalar <= 0x0F80 {
    return true
  }
  if scalar <= 0x0F81 {
    return false
  }
  if scalar <= 0x0F92 {
    return true
  }
  if scalar <= 0x0F93 {
    return false
  }
  if scalar <= 0x0F9C {
    return true
  }
  if scalar <= 0x0F9D {
    return false
  }
  if scalar <= 0x0FA1 {
    return true
  }
  if scalar <= 0x0FA2 {
    return false
  }
  if scalar <= 0x0FA6 {
    return true
  }
  if scalar <= 0x0FA7 {
    return false
  }
  if scalar <= 0x0FAB {
    return true
  }
  if scalar <= 0x0FAC {
    return false
  }
  if scalar <= 0x0FB8 {
    return true
  }
  if scalar <= 0x0FB9 {
    return false
  }
  if scalar <= 0x1025 {
    return true
  }
  if scalar <= 0x1026 {
    return false
  }
  if scalar <= 0x10FB {
    return true
  }
  if scalar <= 0x10FC {
    return false
  }
  if scalar <= 0x1B05 {
    return true
  }
  if scalar <= 0x1B06 {
    return false
  }
  if scalar <= 0x1B07 {
    return true
  }
  if scalar <= 0x1B08 {
    return false
  }
  if scalar <= 0x1B09 {
    return true
  }
  if scalar <= 0x1B0A {
    return false
  }
  if scalar <= 0x1B0B {
    return true
  }
  if scalar <= 0x1B0C {
    return false
  }
  if scalar <= 0x1B0D {
    return true
  }
  if scalar <= 0x1B0E {
    return false
  }
  if scalar <= 0x1B11 {
    return true
  }
  if scalar <= 0x1B12 {
    return false
  }
  if scalar <= 0x1B3A {
    return true
  }
  if scalar <= 0x1B3B {
    return false
  }
  if scalar <= 0x1B3C {
    return true
  }
  if scalar <= 0x1B3D {
    return false
  }
  if scalar <= 0x1B3F {
    return true
  }
  if scalar <= 0x1B41 {
    return false
  }
  if scalar <= 0x1B42 {
    return true
  }
  if scalar <= 0x1B43 {
    return false
  }
  if scalar <= 0x1D2B {
    return true
  }
  if scalar <= 0x1D2E {
    return false
  }
  if scalar <= 0x1D2F {
    return true
  }
  if scalar <= 0x1D3A {
    return false
  }
  if scalar <= 0x1D3B {
    return true
  }
  if scalar <= 0x1D4D {
    return false
  }
  if scalar <= 0x1D4E {
    return true
  }
  if scalar <= 0x1D6A {
    return false
  }
  if scalar <= 0x1D77 {
    return true
  }
  if scalar <= 0x1D78 {
    return false
  }
  if scalar <= 0x1D9A {
    return true
  }
  if scalar <= 0x1DBF {
    return false
  }
  if scalar <= 0x1DFF {
    return true
  }
  if scalar <= 0x1E9B {
    return false
  }
  if scalar <= 0x1E9F {
    return true
  }
  if scalar <= 0x1EF9 {
    return false
  }
  if scalar <= 0x1EFF {
    return true
  }
  if scalar <= 0x1F15 {
    return false
  }
  if scalar <= 0x1F17 {
    return true
  }
  if scalar <= 0x1F1D {
    return false
  }
  if scalar <= 0x1F1F {
    return true
  }
  if scalar <= 0x1F45 {
    return false
  }
  if scalar <= 0x1F47 {
    return true
  }
  if scalar <= 0x1F4D {
    return false
  }
  if scalar <= 0x1F4F {
    return true
  }
  if scalar <= 0x1F57 {
    return false
  }
  if scalar <= 0x1F58 {
    return true
  }
  if scalar <= 0x1F59 {
    return false
  }
  if scalar <= 0x1F5A {
    return true
  }
  if scalar <= 0x1F5B {
    return false
  }
  if scalar <= 0x1F5C {
    return true
  }
  if scalar <= 0x1F5D {
    return false
  }
  if scalar <= 0x1F5E {
    return true
  }
  if scalar <= 0x1F7D {
    return false
  }
  if scalar <= 0x1F7F {
    return true
  }
  if scalar <= 0x1FB4 {
    return false
  }
  if scalar <= 0x1FB5 {
    return true
  }
  if scalar <= 0x1FC4 {
    return false
  }
  if scalar <= 0x1FC5 {
    return true
  }
  if scalar <= 0x1FD3 {
    return false
  }
  if scalar <= 0x1FD5 {
    return true
  }
  if scalar <= 0x1FDB {
    return false
  }
  if scalar <= 0x1FDC {
    return true
  }
  if scalar <= 0x1FEF {
    return false
  }
  if scalar <= 0x1FF1 {
    return true
  }
  if scalar <= 0x1FF4 {
    return false
  }
  if scalar <= 0x1FF5 {
    return true
  }
  if scalar <= 0x1FFE {
    return false
  }
  if scalar <= 0x1FFF {
    return true
  }
  if scalar <= 0x200A {
    return false
  }
  if scalar <= 0x2010 {
    return true
  }
  if scalar <= 0x2011 {
    return false
  }
  if scalar <= 0x2016 {
    return true
  }
  if scalar <= 0x2017 {
    return false
  }
  if scalar <= 0x2023 {
    return true
  }
  if scalar <= 0x2026 {
    return false
  }
  if scalar <= 0x202E {
    return true
  }
  if scalar <= 0x202F {
    return false
  }
  if scalar <= 0x2032 {
    return true
  }
  if scalar <= 0x2034 {
    return false
  }
  if scalar <= 0x2035 {
    return true
  }
  if scalar <= 0x2037 {
    return false
  }
  if scalar <= 0x203B {
    return true
  }
  if scalar <= 0x203C {
    return false
  }
  if scalar <= 0x203D {
    return true
  }
  if scalar <= 0x203E {
    return false
  }
  if scalar <= 0x2046 {
    return true
  }
  if scalar <= 0x2049 {
    return false
  }
  if scalar <= 0x2056 {
    return true
  }
  if scalar <= 0x2057 {
    return false
  }
  if scalar <= 0x205E {
    return true
  }
  if scalar <= 0x205F {
    return false
  }
  if scalar <= 0x206F {
    return true
  }
  if scalar <= 0x2071 {
    return false
  }
  if scalar <= 0x2073 {
    return true
  }
  if scalar <= 0x208E {
    return false
  }
  if scalar <= 0x208F {
    return true
  }
  if scalar <= 0x209C {
    return false
  }
  if scalar <= 0x20A7 {
    return true
  }
  if scalar <= 0x20A8 {
    return false
  }
  if scalar <= 0x20FF {
    return true
  }
  if scalar <= 0x2103 {
    return false
  }
  if scalar <= 0x2104 {
    return true
  }
  if scalar <= 0x2107 {
    return false
  }
  if scalar <= 0x2108 {
    return true
  }
  if scalar <= 0x2113 {
    return false
  }
  if scalar <= 0x2114 {
    return true
  }
  if scalar <= 0x2116 {
    return false
  }
  if scalar <= 0x2118 {
    return true
  }
  if scalar <= 0x211D {
    return false
  }
  if scalar <= 0x211F {
    return true
  }
  if scalar <= 0x2122 {
    return false
  }
  if scalar <= 0x2123 {
    return true
  }
  if scalar <= 0x2124 {
    return false
  }
  if scalar <= 0x2125 {
    return true
  }
  if scalar <= 0x2126 {
    return false
  }
  if scalar <= 0x2127 {
    return true
  }
  if scalar <= 0x2128 {
    return false
  }
  if scalar <= 0x2129 {
    return true
  }
  if scalar <= 0x212D {
    return false
  }
  if scalar <= 0x212E {
    return true
  }
  if scalar <= 0x2131 {
    return false
  }
  if scalar <= 0x2132 {
    return true
  }
  if scalar <= 0x2139 {
    return false
  }
  if scalar <= 0x213A {
    return true
  }
  if scalar <= 0x2140 {
    return false
  }
  if scalar <= 0x2144 {
    return true
  }
  if scalar <= 0x2149 {
    return false
  }
  if scalar <= 0x214F {
    return true
  }
  if scalar <= 0x217F {
    return false
  }
  if scalar <= 0x2188 {
    return true
  }
  if scalar <= 0x2189 {
    return false
  }
  if scalar <= 0x2199 {
    return true
  }
  if scalar <= 0x219B {
    return false
  }
  if scalar <= 0x21AD {
    return true
  }
  if scalar <= 0x21AE {
    return false
  }
  if scalar <= 0x21CC {
    return true
  }
  if scalar <= 0x21CF {
    return false
  }
  if scalar <= 0x2203 {
    return true
  }
  if scalar <= 0x2204 {
    return false
  }
  if scalar <= 0x2208 {
    return true
  }
  if scalar <= 0x2209 {
    return false
  }
  if scalar <= 0x220B {
    return true
  }
  if scalar <= 0x220C {
    return false
  }
  if scalar <= 0x2223 {
    return true
  }
  if scalar <= 0x2224 {
    return false
  }
  if scalar <= 0x2225 {
    return true
  }
  if scalar <= 0x2226 {
    return false
  }
  if scalar <= 0x222B {
    return true
  }
  if scalar <= 0x222D {
    return false
  }
  if scalar <= 0x222E {
    return true
  }
  if scalar <= 0x2230 {
    return false
  }
  if scalar <= 0x2240 {
    return true
  }
  if scalar <= 0x2241 {
    return false
  }
  if scalar <= 0x2243 {
    return true
  }
  if scalar <= 0x2244 {
    return false
  }
  if scalar <= 0x2246 {
    return true
  }
  if scalar <= 0x2247 {
    return false
  }
  if scalar <= 0x2248 {
    return true
  }
  if scalar <= 0x2249 {
    return false
  }
  if scalar <= 0x225F {
    return true
  }
  if scalar <= 0x2260 {
    return false
  }
  if scalar <= 0x2261 {
    return true
  }
  if scalar <= 0x2262 {
    return false
  }
  if scalar <= 0x226C {
    return true
  }
  if scalar <= 0x2271 {
    return false
  }
  if scalar <= 0x2273 {
    return true
  }
  if scalar <= 0x2275 {
    return false
  }
  if scalar <= 0x2277 {
    return true
  }
  if scalar <= 0x2279 {
    return false
  }
  if scalar <= 0x227F {
    return true
  }
  if scalar <= 0x2281 {
    return false
  }
  if scalar <= 0x2283 {
    return true
  }
  if scalar <= 0x2285 {
    return false
  }
  if scalar <= 0x2287 {
    return true
  }
  if scalar <= 0x2289 {
    return false
  }
  if scalar <= 0x22AB {
    return true
  }
  if scalar <= 0x22AF {
    return false
  }
  if scalar <= 0x22DF {
    return true
  }
  if scalar <= 0x22E3 {
    return false
  }
  if scalar <= 0x22E9 {
    return true
  }
  if scalar <= 0x22ED {
    return false
  }
  if scalar <= 0x2328 {
    return true
  }
  if scalar <= 0x232A {
    return false
  }
  if scalar <= 0x245F {
    return true
  }
  if scalar <= 0x24EA {
    return false
  }
  if scalar <= 0x2A0B {
    return true
  }
  if scalar <= 0x2A0C {
    return false
  }
  if scalar <= 0x2A73 {
    return true
  }
  if scalar <= 0x2A76 {
    return false
  }
  if scalar <= 0x2ADB {
    return true
  }
  if scalar <= 0x2ADC {
    return false
  }
  if scalar <= 0x2C7B {
    return true
  }
  if scalar <= 0x2C7D {
    return false
  }
  if scalar <= 0x2D6E {
    return true
  }
  if scalar <= 0x2D6F {
    return false
  }
  if scalar <= 0x2E9E {
    return true
  }
  if scalar <= 0x2E9F {
    return false
  }
  if scalar <= 0x2EF2 {
    return true
  }
  if scalar <= 0x2EF3 {
    return false
  }
  if scalar <= 0x2EFF {
    return true
  }
  if scalar <= 0x2FD5 {
    return false
  }
  if scalar <= 0x2FFF {
    return true
  }
  if scalar <= 0x3000 {
    return false
  }
  if scalar <= 0x3035 {
    return true
  }
  if scalar <= 0x3036 {
    return false
  }
  if scalar <= 0x3037 {
    return true
  }
  if scalar <= 0x303A {
    return false
  }
  if scalar <= 0x304B {
    return true
  }
  if scalar <= 0x304C {
    return false
  }
  if scalar <= 0x304D {
    return true
  }
  if scalar <= 0x304E {
    return false
  }
  if scalar <= 0x304F {
    return true
  }
  if scalar <= 0x3050 {
    return false
  }
  if scalar <= 0x3051 {
    return true
  }
  if scalar <= 0x3052 {
    return false
  }
  if scalar <= 0x3053 {
    return true
  }
  if scalar <= 0x3054 {
    return false
  }
  if scalar <= 0x3055 {
    return true
  }
  if scalar <= 0x3056 {
    return false
  }
  if scalar <= 0x3057 {
    return true
  }
  if scalar <= 0x3058 {
    return false
  }
  if scalar <= 0x3059 {
    return true
  }
  if scalar <= 0x305A {
    return false
  }
  if scalar <= 0x305B {
    return true
  }
  if scalar <= 0x305C {
    return false
  }
  if scalar <= 0x305D {
    return true
  }
  if scalar <= 0x305E {
    return false
  }
  if scalar <= 0x305F {
    return true
  }
  if scalar <= 0x3060 {
    return false
  }
  if scalar <= 0x3061 {
    return true
  }
  if scalar <= 0x3062 {
    return false
  }
  if scalar <= 0x3064 {
    return true
  }
  if scalar <= 0x3065 {
    return false
  }
  if scalar <= 0x3066 {
    return true
  }
  if scalar <= 0x3067 {
    return false
  }
  if scalar <= 0x3068 {
    return true
  }
  if scalar <= 0x3069 {
    return false
  }
  if scalar <= 0x306F {
    return true
  }
  if scalar <= 0x3071 {
    return false
  }
  if scalar <= 0x3072 {
    return true
  }
  if scalar <= 0x3074 {
    return false
  }
  if scalar <= 0x3075 {
    return true
  }
  if scalar <= 0x3077 {
    return false
  }
  if scalar <= 0x3078 {
    return true
  }
  if scalar <= 0x307A {
    return false
  }
  if scalar <= 0x307B {
    return true
  }
  if scalar <= 0x307D {
    return false
  }
  if scalar <= 0x3093 {
    return true
  }
  if scalar <= 0x3094 {
    return false
  }
  if scalar <= 0x309A {
    return true
  }
  if scalar <= 0x309C {
    return false
  }
  if scalar <= 0x309D {
    return true
  }
  if scalar <= 0x309F {
    return false
  }
  if scalar <= 0x30AB {
    return true
  }
  if scalar <= 0x30AC {
    return false
  }
  if scalar <= 0x30AD {
    return true
  }
  if scalar <= 0x30AE {
    return false
  }
  if scalar <= 0x30AF {
    return true
  }
  if scalar <= 0x30B0 {
    return false
  }
  if scalar <= 0x30B1 {
    return true
  }
  if scalar <= 0x30B2 {
    return false
  }
  if scalar <= 0x30B3 {
    return true
  }
  if scalar <= 0x30B4 {
    return false
  }
  if scalar <= 0x30B5 {
    return true
  }
  if scalar <= 0x30B6 {
    return false
  }
  if scalar <= 0x30B7 {
    return true
  }
  if scalar <= 0x30B8 {
    return false
  }
  if scalar <= 0x30B9 {
    return true
  }
  if scalar <= 0x30BA {
    return false
  }
  if scalar <= 0x30BB {
    return true
  }
  if scalar <= 0x30BC {
    return false
  }
  if scalar <= 0x30BD {
    return true
  }
  if scalar <= 0x30BE {
    return false
  }
  if scalar <= 0x30BF {
    return true
  }
  if scalar <= 0x30C0 {
    return false
  }
  if scalar <= 0x30C1 {
    return true
  }
  if scalar <= 0x30C2 {
    return false
  }
  if scalar <= 0x30C4 {
    return true
  }
  if scalar <= 0x30C5 {
    return false
  }
  if scalar <= 0x30C6 {
    return true
  }
  if scalar <= 0x30C7 {
    return false
  }
  if scalar <= 0x30C8 {
    return true
  }
  if scalar <= 0x30C9 {
    return false
  }
  if scalar <= 0x30CF {
    return true
  }
  if scalar <= 0x30D1 {
    return false
  }
  if scalar <= 0x30D2 {
    return true
  }
  if scalar <= 0x30D4 {
    return false
  }
  if scalar <= 0x30D5 {
    return true
  }
  if scalar <= 0x30D7 {
    return false
  }
  if scalar <= 0x30D8 {
    return true
  }
  if scalar <= 0x30DA {
    return false
  }
  if scalar <= 0x30DB {
    return true
  }
  if scalar <= 0x30DD {
    return false
  }
  if scalar <= 0x30F3 {
    return true
  }
  if scalar <= 0x30F4 {
    return false
  }
  if scalar <= 0x30F6 {
    return true
  }
  if scalar <= 0x30FA {
    return false
  }
  if scalar <= 0x30FD {
    return true
  }
  if scalar <= 0x30FF {
    return false
  }
  if scalar <= 0x3130 {
    return true
  }
  if scalar <= 0x318E {
    return false
  }
  if scalar <= 0x3191 {
    return true
  }
  if scalar <= 0x319F {
    return false
  }
  if scalar <= 0x31FF {
    return true
  }
  if scalar <= 0x321E {
    return false
  }
  if scalar <= 0x321F {
    return true
  }
  if scalar <= 0x3247 {
    return false
  }
  if scalar <= 0x324F {
    return true
  }
  if scalar <= 0x327E {
    return false
  }
  if scalar <= 0x327F {
    return true
  }
  if scalar <= 0x33FF {
    return false
  }
  if scalar <= 0xA69B {
    return true
  }
  if scalar <= 0xA69D {
    return false
  }
  if scalar <= 0xA76F {
    return true
  }
  if scalar <= 0xA770 {
    return false
  }
  if scalar <= 0xA7F0 {
    return true
  }
  if scalar <= 0xA7F4 {
    return false
  }
  if scalar <= 0xA7F7 {
    return true
  }
  if scalar <= 0xA7F9 {
    return false
  }
  if scalar <= 0xAB5B {
    return true
  }
  if scalar <= 0xAB5F {
    return false
  }
  if scalar <= 0xAB68 {
    return true
  }
  if scalar <= 0xAB69 {
    return false
  }
  if scalar <= 0xABFF {
    return true
  }
  if scalar <= 0xD7A3 {
    return false
  }
  if scalar <= 0xF8FF {
    return true
  }
  if scalar <= 0xFA0D {
    return false
  }
  if scalar <= 0xFA0F {
    return true
  }
  if scalar <= 0xFA10 {
    return false
  }
  if scalar <= 0xFA11 {
    return true
  }
  if scalar <= 0xFA12 {
    return false
  }
  if scalar <= 0xFA14 {
    return true
  }
  if scalar <= 0xFA1E {
    return false
  }
  if scalar <= 0xFA1F {
    return true
  }
  if scalar <= 0xFA20 {
    return false
  }
  if scalar <= 0xFA21 {
    return true
  }
  if scalar <= 0xFA22 {
    return false
  }
  if scalar <= 0xFA24 {
    return true
  }
  if scalar <= 0xFA26 {
    return false
  }
  if scalar <= 0xFA29 {
    return true
  }
  if scalar <= 0xFA6D {
    return false
  }
  if scalar <= 0xFA6F {
    return true
  }
  if scalar <= 0xFAD9 {
    return false
  }
  if scalar <= 0xFAFF {
    return true
  }
  if scalar <= 0xFB06 {
    return false
  }
  if scalar <= 0xFB12 {
    return true
  }
  if scalar <= 0xFB17 {
    return false
  }
  if scalar <= 0xFB1C {
    return true
  }
  if scalar <= 0xFB1D {
    return false
  }
  if scalar <= 0xFB1E {
    return true
  }
  if scalar <= 0xFB36 {
    return false
  }
  if scalar <= 0xFB37 {
    return true
  }
  if scalar <= 0xFB3C {
    return false
  }
  if scalar <= 0xFB3D {
    return true
  }
  if scalar <= 0xFB3E {
    return false
  }
  if scalar <= 0xFB3F {
    return true
  }
  if scalar <= 0xFB41 {
    return false
  }
  if scalar <= 0xFB42 {
    return true
  }
  if scalar <= 0xFB44 {
    return false
  }
  if scalar <= 0xFB45 {
    return true
  }
  if scalar <= 0xFBB1 {
    return false
  }
  if scalar <= 0xFBD2 {
    return true
  }
  if scalar <= 0xFD3D {
    return false
  }
  if scalar <= 0xFD4F {
    return true
  }
  if scalar <= 0xFD8F {
    return false
  }
  if scalar <= 0xFD91 {
    return true
  }
  if scalar <= 0xFDC7 {
    return false
  }
  if scalar <= 0xFDEF {
    return true
  }
  if scalar <= 0xFDFC {
    return false
  }
  if scalar <= 0xFE0F {
    return true
  }
  if scalar <= 0xFE19 {
    return false
  }
  if scalar <= 0xFE2F {
    return true
  }
  if scalar <= 0xFE44 {
    return false
  }
  if scalar <= 0xFE46 {
    return true
  }
  if scalar <= 0xFE52 {
    return false
  }
  if scalar <= 0xFE53 {
    return true
  }
  if scalar <= 0xFE66 {
    return false
  }
  if scalar <= 0xFE67 {
    return true
  }
  if scalar <= 0xFE6B {
    return false
  }
  if scalar <= 0xFE6F {
    return true
  }
  if scalar <= 0xFE72 {
    return false
  }
  if scalar <= 0xFE73 {
    return true
  }
  if scalar <= 0xFE74 {
    return false
  }
  if scalar <= 0xFE75 {
    return true
  }
  if scalar <= 0xFEFC {
    return false
  }
  if scalar <= 0xFF00 {
    return true
  }
  if scalar <= 0xFFBE {
    return false
  }
  if scalar <= 0xFFC1 {
    return true
  }
  if scalar <= 0xFFC7 {
    return false
  }
  if scalar <= 0xFFC9 {
    return true
  }
  if scalar <= 0xFFCF {
    return false
  }
  if scalar <= 0xFFD1 {
    return true
  }
  if scalar <= 0xFFD7 {
    return false
  }
  if scalar <= 0xFFD9 {
    return true
  }
  if scalar <= 0xFFDC {
    return false
  }
  if scalar <= 0xFFDF {
    return true
  }
  if scalar <= 0xFFE6 {
    return false
  }
  if scalar <= 0xFFE7 {
    return true
  }
  if scalar <= 0xFFEE {
    return false
  }
  if scalar <= 0x105C8 {
    return true
  }
  if scalar <= 0x105C9 {
    return false
  }
  if scalar <= 0x105E3 {
    return true
  }
  if scalar <= 0x105E4 {
    return false
  }
  if scalar <= 0x10780 {
    return true
  }
  if scalar <= 0x10785 {
    return false
  }
  if scalar <= 0x10786 {
    return true
  }
  if scalar <= 0x107B0 {
    return false
  }
  if scalar <= 0x107B1 {
    return true
  }
  if scalar <= 0x107BA {
    return false
  }
  if scalar <= 0x11099 {
    return true
  }
  if scalar <= 0x1109A {
    return false
  }
  if scalar <= 0x1109B {
    return true
  }
  if scalar <= 0x1109C {
    return false
  }
  if scalar <= 0x110AA {
    return true
  }
  if scalar <= 0x110AB {
    return false
  }
  if scalar <= 0x1112D {
    return true
  }
  if scalar <= 0x1112F {
    return false
  }
  if scalar <= 0x1134A {
    return true
  }
  if scalar <= 0x1134C {
    return false
  }
  if scalar <= 0x11382 {
    return true
  }
  if scalar <= 0x11383 {
    return false
  }
  if scalar <= 0x11384 {
    return true
  }
  if scalar <= 0x11385 {
    return false
  }
  if scalar <= 0x1138D {
    return true
  }
  if scalar <= 0x1138E {
    return false
  }
  if scalar <= 0x11390 {
    return true
  }
  if scalar <= 0x11391 {
    return false
  }
  if scalar <= 0x113C4 {
    return true
  }
  if scalar <= 0x113C5 {
    return false
  }
  if scalar <= 0x113C6 {
    return true
  }
  if scalar <= 0x113C8 {
    return false
  }
  if scalar <= 0x114BA {
    return true
  }
  if scalar <= 0x114BC {
    return false
  }
  if scalar <= 0x114BD {
    return true
  }
  if scalar <= 0x114BE {
    return false
  }
  if scalar <= 0x115B9 {
    return true
  }
  if scalar <= 0x115BB {
    return false
  }
  if scalar <= 0x11937 {
    return true
  }
  if scalar <= 0x11938 {
    return false
  }
  if scalar <= 0x16120 {
    return true
  }
  if scalar <= 0x16128 {
    return false
  }
  if scalar <= 0x16D67 {
    return true
  }
  if scalar <= 0x16D6A {
    return false
  }
  if scalar <= 0x1CCD5 {
    return true
  }
  if scalar <= 0x1CCF9 {
    return false
  }
  if scalar <= 0x1D15D {
    return true
  }
  if scalar <= 0x1D164 {
    return false
  }
  if scalar <= 0x1D1BA {
    return true
  }
  if scalar <= 0x1D1C0 {
    return false
  }
  if scalar <= 0x1D3FF {
    return true
  }
  if scalar <= 0x1D454 {
    return false
  }
  if scalar <= 0x1D455 {
    return true
  }
  if scalar <= 0x1D49C {
    return false
  }
  if scalar <= 0x1D49D {
    return true
  }
  if scalar <= 0x1D49F {
    return false
  }
  if scalar <= 0x1D4A1 {
    return true
  }
  if scalar <= 0x1D4A2 {
    return false
  }
  if scalar <= 0x1D4A4 {
    return true
  }
  if scalar <= 0x1D4A6 {
    return false
  }
  if scalar <= 0x1D4A8 {
    return true
  }
  if scalar <= 0x1D4AC {
    return false
  }
  if scalar <= 0x1D4AD {
    return true
  }
  if scalar <= 0x1D4B9 {
    return false
  }
  if scalar <= 0x1D4BA {
    return true
  }
  if scalar <= 0x1D4BB {
    return false
  }
  if scalar <= 0x1D4BC {
    return true
  }
  if scalar <= 0x1D4C3 {
    return false
  }
  if scalar <= 0x1D4C4 {
    return true
  }
  if scalar <= 0x1D505 {
    return false
  }
  if scalar <= 0x1D506 {
    return true
  }
  if scalar <= 0x1D50A {
    return false
  }
  if scalar <= 0x1D50C {
    return true
  }
  if scalar <= 0x1D514 {
    return false
  }
  if scalar <= 0x1D515 {
    return true
  }
  if scalar <= 0x1D51C {
    return false
  }
  if scalar <= 0x1D51D {
    return true
  }
  if scalar <= 0x1D539 {
    return false
  }
  if scalar <= 0x1D53A {
    return true
  }
  if scalar <= 0x1D53E {
    return false
  }
  if scalar <= 0x1D53F {
    return true
  }
  if scalar <= 0x1D544 {
    return false
  }
  if scalar <= 0x1D545 {
    return true
  }
  if scalar <= 0x1D546 {
    return false
  }
  if scalar <= 0x1D549 {
    return true
  }
  if scalar <= 0x1D550 {
    return false
  }
  if scalar <= 0x1D551 {
    return true
  }
  if scalar <= 0x1D6A5 {
    return false
  }
  if scalar <= 0x1D6A7 {
    return true
  }
  if scalar <= 0x1D7CB {
    return false
  }
  if scalar <= 0x1D7CD {
    return true
  }
  if scalar <= 0x1D7FF {
    return false
  }
  if scalar <= 0x1E02F {
    return true
  }
  if scalar <= 0x1E06D {
    return false
  }
  if scalar <= 0x1EDFF {
    return true
  }
  if scalar <= 0x1EE03 {
    return false
  }
  if scalar <= 0x1EE04 {
    return true
  }
  if scalar <= 0x1EE1F {
    return false
  }
  if scalar <= 0x1EE20 {
    return true
  }
  if scalar <= 0x1EE22 {
    return false
  }
  if scalar <= 0x1EE23 {
    return true
  }
  if scalar <= 0x1EE24 {
    return false
  }
  if scalar <= 0x1EE26 {
    return true
  }
  if scalar <= 0x1EE27 {
    return false
  }
  if scalar <= 0x1EE28 {
    return true
  }
  if scalar <= 0x1EE32 {
    return false
  }
  if scalar <= 0x1EE33 {
    return true
  }
  if scalar <= 0x1EE37 {
    return false
  }
  if scalar <= 0x1EE38 {
    return true
  }
  if scalar <= 0x1EE39 {
    return false
  }
  if scalar <= 0x1EE3A {
    return true
  }
  if scalar <= 0x1EE3B {
    return false
  }
  if scalar <= 0x1EE41 {
    return true
  }
  if scalar <= 0x1EE42 {
    return false
  }
  if scalar <= 0x1EE46 {
    return true
  }
  if scalar <= 0x1EE47 {
    return false
  }
  if scalar <= 0x1EE48 {
    return true
  }
  if scalar <= 0x1EE49 {
    return false
  }
  if scalar <= 0x1EE4A {
    return true
  }
  if scalar <= 0x1EE4B {
    return false
  }
  if scalar <= 0x1EE4C {
    return true
  }
  if scalar <= 0x1EE4F {
    return false
  }
  if scalar <= 0x1EE50 {
    return true
  }
  if scalar <= 0x1EE52 {
    return false
  }
  if scalar <= 0x1EE53 {
    return true
  }
  if scalar <= 0x1EE54 {
    return false
  }
  if scalar <= 0x1EE56 {
    return true
  }
  if scalar <= 0x1EE57 {
    return false
  }
  if scalar <= 0x1EE58 {
    return true
  }
  if scalar <= 0x1EE59 {
    return false
  }
  if scalar <= 0x1EE5A {
    return true
  }
  if scalar <= 0x1EE5B {
    return false
  }
  if scalar <= 0x1EE5C {
    return true
  }
  if scalar <= 0x1EE5D {
    return false
  }
  if scalar <= 0x1EE5E {
    return true
  }
  if scalar <= 0x1EE5F {
    return false
  }
  if scalar <= 0x1EE60 {
    return true
  }
  if scalar <= 0x1EE62 {
    return false
  }
  if scalar <= 0x1EE63 {
    return true
  }
  if scalar <= 0x1EE64 {
    return false
  }
  if scalar <= 0x1EE66 {
    return true
  }
  if scalar <= 0x1EE6A {
    return false
  }
  if scalar <= 0x1EE6B {
    return true
  }
  if scalar <= 0x1EE72 {
    return false
  }
  if scalar <= 0x1EE73 {
    return true
  }
  if scalar <= 0x1EE77 {
    return false
  }
  if scalar <= 0x1EE78 {
    return true
  }
  if scalar <= 0x1EE7C {
    return false
  }
  if scalar <= 0x1EE7D {
    return true
  }
  if scalar <= 0x1EE7E {
    return false
  }
  if scalar <= 0x1EE7F {
    return true
  }
  if scalar <= 0x1EE89 {
    return false
  }
  if scalar <= 0x1EE8A {
    return true
  }
  if scalar <= 0x1EE9B {
    return false
  }
  if scalar <= 0x1EEA0 {
    return true
  }
  if scalar <= 0x1EEA3 {
    return false
  }
  if scalar <= 0x1EEA4 {
    return true
  }
  if scalar <= 0x1EEA9 {
    return false
  }
  if scalar <= 0x1EEAA {
    return true
  }
  if scalar <= 0x1EEBB {
    return false
  }
  if scalar <= 0x1F0FF {
    return true
  }
  if scalar <= 0x1F10A {
    return false
  }
  if scalar <= 0x1F10F {
    return true
  }
  if scalar <= 0x1F12E {
    return false
  }
  if scalar <= 0x1F12F {
    return true
  }
  if scalar <= 0x1F14F {
    return false
  }
  if scalar <= 0x1F169 {
    return true
  }
  if scalar <= 0x1F16C {
    return false
  }
  if scalar <= 0x1F18F {
    return true
  }
  if scalar <= 0x1F190 {
    return false
  }
  if scalar <= 0x1F1FF {
    return true
  }
  if scalar <= 0x1F202 {
    return false
  }
  if scalar <= 0x1F20F {
    return true
  }
  if scalar <= 0x1F23B {
    return false
  }
  if scalar <= 0x1F23F {
    return true
  }
  if scalar <= 0x1F248 {
    return false
  }
  if scalar <= 0x1F24F {
    return true
  }
  if scalar <= 0x1F251 {
    return false
  }
  if scalar <= 0x1FBEF {
    return true
  }
  if scalar <= 0x1FBF9 {
    return false
  }
  if scalar <= 0x2F7FF {
    return true
  }
  if scalar <= 0x2FA1D {
    return false
  }
  return true
}

func 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x1C
}

func 중성의_0020개수_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x15
}

func 첫_0020글자_0020마디_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0xAC00
}

func 첫_0020종성_0020직전_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x11A7
}

func 첫_0020중성_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x1161
}

func 첫_0020초성_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x1100
}

func 최종_0020쌍의_0020수_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 중성의_0020개수_003AUnicode_0020scalar_0020numerical_0020value() &* 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value()
}
