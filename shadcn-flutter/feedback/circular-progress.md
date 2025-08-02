Example
const CircularProgressIndicator()

With Value Example
double \_progress = 0;
@override
Widget build(BuildContext context) {
return Column(
mainAxisSize: MainAxisSize.min,
children: [
CircularProgressIndicator(
value: \_progress.clamp(0, 100) / 100,
size: 48,
),
const Gap(48),
Row(
children: [
DestructiveButton(
onPressed: () {
setState(() {
_progress = 0;
});
},
child: const Text('Reset'),
),
const Gap(16),
PrimaryButton(
onPressed: () {
setState(() {
_progress -= 10;
});
},
child: const Text('Decrease by 10'),
),
const Gap(16),
PrimaryButton(
onPressed: () {
setState(() {
_progress += 10;
});
},
child: const Text('Increase by 10'),
),
],
)
],
);
}
