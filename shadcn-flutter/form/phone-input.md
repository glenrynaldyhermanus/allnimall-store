PhoneNumber? \_phoneNumber;
@override
Widget build(BuildContext context) {
return Column(
mainAxisSize: MainAxisSize.min,
children: [
PhoneInput(
initialCountry: Country.indonesia,
onChanged: (value) {
setState(() {
_phoneNumber = value;
});
},
),
const Gap(24),
Text(
_phoneNumber?.value ?? '(No value)',
),
],
);
}
