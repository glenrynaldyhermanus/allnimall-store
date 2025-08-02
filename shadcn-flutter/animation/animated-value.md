List<Color> colors = [
Colors.red,
Colors.green,
Colors.blue,
];
int index = 0;
@override
Widget build(BuildContext context) {
return Column(
children: [
AnimatedValueBuilder(
value: colors[index],
duration: const Duration(seconds: 1),
lerp: Color.lerp,
builder: (context, value, child) {
return Container(
width: 100,
height: 100,
color: value,
);
},
),
const Gap(32),
PrimaryButton(
onPressed: () {
setState(() {
index = (index + 1) % colors.length;
});
},
child: const Text('Change Color'),
),
],
);
}

With Initial Value
List<Color> colors = [
Colors.red,
Colors.green,
Colors.blue,
];
int index = 0;
@override
Widget build(BuildContext context) {
return Column(
children: [
AnimatedValueBuilder(
value: colors[index],
duration: const Duration(seconds: 1),
lerp: Color.lerp,
builder: (context, value, child) {
return Container(
width: 100,
height: 100,
color: value,
);
},
),
const Gap(32),
PrimaryButton(
onPressed: () {
setState(() {
index = (index + 1) % colors.length;
});
},
child: const Text('Change Color'),
),
],
);
}
