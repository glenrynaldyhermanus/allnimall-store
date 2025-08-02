int index = 0;
@override
Widget build(BuildContext context) {
return Column(
children: [
Tabs(
index: index,
children: const [
TabItem(child: Text('Tab 1')),
TabItem(child: Text('Tab 2')),
TabItem(child: Text('Tab 3')),
],
onChanged: (int value) {
setState(() {
index = value;
});
},
),
const Gap(8),
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
