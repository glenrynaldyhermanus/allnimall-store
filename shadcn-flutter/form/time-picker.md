TimeOfDay \_value = TimeOfDay.now();
@override
Widget build(BuildContext context) {
return Column(
children: [
TimePicker(
value: _value,
mode: PromptMode.popover,
onChanged: (value) {
setState(() {
_value = value ?? TimeOfDay.now();
});
},
),
const Gap(16),
TimePicker(
value: _value,
mode: PromptMode.dialog,
dialogTitle: const Text('Select Time'),
onChanged: (value) {
setState(() {
_value = value ?? TimeOfDay.now();
});
},
),
],
);
}
