int? selectedValue;

@override
Widget build(BuildContext context) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
RadioGroup<int>(
value: selectedValue,
onChanged: (value) {
setState(() {
selectedValue = value;
});
},
child: const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
RadioItem(
value: 1,
trailing: Text('Option 1'),
),
RadioItem(
value: 2,
trailing: Text('Option 2'),
),
RadioItem(
value: 3,
trailing: Text('Option 3'),
),
],
),
),
const Gap(16),
Text('Selected: $selectedValue'),
],
);
}
