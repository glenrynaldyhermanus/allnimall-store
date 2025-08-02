int index = 0;
@override
Widget build(BuildContext context) {
return Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
TabList(
index: index,
onChanged: (value) {
setState(() {
index = value;
});
},
children: const [
TabItem(
child: Text('Tab 1'),
),
TabItem(
child: Text('Tab 2'),
),
TabItem(
child: Text('Tab 3'),
),
],
),
const Gap(16),
IndexedStack(
index: index,
children: const [
NumberedContainer(
index: 1,
),
NumberedContainer(
index: 2,
),
NumberedContainer(
index: 3,
),
],
).sized(height: 300),
],
);
}
