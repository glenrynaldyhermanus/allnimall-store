DateTime? \_value;
@override
Widget build(BuildContext context) {
return Column(
children: [
DatePicker(
value: _value,
mode: PromptMode.popover,
stateBuilder: (date) {
if (date.isAfter(DateTime.now())) {
return DateState.disabled;
}
return DateState.enabled;
},
onChanged: (value) {
setState(() {
_value = value;
});
},
),
const Gap(16),
DatePicker(
value: _value,
mode: PromptMode.dialog,
dialogTitle: const Text('Select Date'),
stateBuilder: (date) {
if (date.isAfter(DateTime.now())) {
return DateState.disabled;
}
return DateState.enabled;
},
onChanged: (value) {
setState(() {
_value = value;
});
},
),
],
);
}

Date Range
DateTimeRange? \_value;
@override
Widget build(BuildContext context) {
return Column(
children: [
DateRangePicker(
value: _value,
mode: PromptMode.popover,
onChanged: (value) {
setState(() {
_value = value;
});
},
),
const Gap(16),
DateRangePicker(
value: _value,
mode: PromptMode.dialog,
dialogTitle: const Text('Select Date Range'),
onChanged: (value) {
setState(() {
_value = value;
});
},
),
],
);
}
