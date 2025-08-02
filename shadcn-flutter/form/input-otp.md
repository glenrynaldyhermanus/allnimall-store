String value = '';
String? submittedValue;
@override
Widget build(BuildContext context) {
return Column(
mainAxisSize: MainAxisSize.min,
children: [
InputOTP(
onChanged: (value) {
setState(() {
this.value = value.otpToString();
});
},
onSubmitted: (value) {
setState(() {
submittedValue = value.otpToString();
});
},
children: [
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
InputOTPChild.separator,
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
],
),
gap(16),
Text('Value: $value'),
Text('Submitted Value: $submittedValue'),
],
);
}

Initial Value
InputOTP(
initialValue: '123'.codeUnits,
children: [
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
InputOTPChild.separator,
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
InputOTPChild.character(allowDigit: true),
],
)

Obscured
InputOTP(
children: [
InputOTPChild.character(allowDigit: true, obscured: true),
InputOTPChild.character(allowDigit: true, obscured: true),
InputOTPChild.character(allowDigit: true, obscured: true),
InputOTPChild.separator,
InputOTPChild.character(allowDigit: true, obscured: true),
InputOTPChild.character(allowDigit: true, obscured: true),
InputOTPChild.character(allowDigit: true, obscured: true),
],
)

Uppercase Alphabet
InputOTP(
children: [
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.separator,
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.separator,
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
InputOTPChild.character(
allowLowercaseAlphabet: true,
allowUppercaseAlphabet: true,
onlyUppercaseAlphabet: true),
],
)
