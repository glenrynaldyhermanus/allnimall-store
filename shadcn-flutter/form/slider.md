SliderValue value = const SliderValue.single(0.5);
@override
Widget build(BuildContext context) {
return Slider(
value: value,
onChanged: (value) {
setState(() {
this.value = value;
});
},
);
}

With Range
SliderValue value = const SliderValue.ranged(0.5, 0.75);
@override
Widget build(BuildContext context) {
return Column(
mainAxisSize: MainAxisSize.min,
children: [
Slider(
value: value,
onChanged: (value) {
setState(() {
this.value = value;
});
},
),
const Gap(16),
Text('Value: ${value.start} - ${value.end}'),
],
);
}

With Divisions
SliderValue value = const SliderValue.single(0.5);
@override
Widget build(BuildContext context) {
return Column(
mainAxisSize: MainAxisSize.min,
children: [
Slider(
max: 2,
divisions: 10,
value: value,
onChanged: (value) {
setState(() {
this.value = value;
});
},
),
const Gap(16),
Text('Value: ${value.value}'),
],
);
}
