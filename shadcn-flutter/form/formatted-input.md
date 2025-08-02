Formatted Input
FormattedInput(
onChanged: (value) {
List<String> parts = [];
for (FormattedValuePart part in value.values) {
parts.add(part.value ?? '');
}
print(parts.join('/'));
},
initialValue: FormattedValue([
const InputPart.editable(length: 2, width: 40, placeholder: Text('MM'))
.withValue('01'),
const InputPart.static('/'),
const InputPart.editable(length: 2, width: 40, placeholder: Text('DD'))
.withValue('02'),
const InputPart.static('/'),
const InputPart.editable(length: 4, width: 60, placeholder: Text('YYYY'))
.withValue('2021'),
]),
)

Date Input
DateTime? \_selectedDate;
@override
Widget build(BuildContext context) {
return Column(
children: [
DateInput(
onChanged: (value) => setState(() => _selectedDate = value),
),
const Gap(16),
if (_selectedDate != null) Text('Selected date: $_selectedDate'),
],
);
}

Time Input
TimeOfDay? \_selected;
@override
Widget build(BuildContext context) {
return Column(
children: [
TimeInput(
onChanged: (value) => setState(() => _selected = value),
),
const Gap(16),
if (_selected != null) Text('Selected time: $_selected'),
],
);
}

Duration Input
Duration? \_selected;
@override
Widget build(BuildContext context) {
return Column(
children: [
DurationInput(
onChanged: (value) => setState(() => _selected = value),
showSeconds: true,
),
const Gap(16),
if (_selected != null) Text('Selected duration: $_selected'),
],
);
}
