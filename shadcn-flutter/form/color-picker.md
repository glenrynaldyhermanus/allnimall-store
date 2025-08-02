Color Picker
ColorDerivative color = ColorDerivative.fromColor(Colors.blue);
@override
Widget build(BuildContext context) {
return SizedBox(
width: 200,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(
width: 32,
height: 32,
child: ColorInput(
color: color,
mode: PromptMode.popover,
onChanged: (value) {
setState(() {
color = value;
});
},
storage: ColorHistoryStorage.of(context),
),
),
const Gap(16),
ColorInput(
color: color,
mode: PromptMode.dialog,
dialogTitle: const Text('Select Color'),
onChanged: (value) {
setState(() {
color = value;
});
},
showLabel: true,
storage: ColorHistoryStorage.of(context),
),
],
),
);
}

Screen Color Picker
PrimaryButton(
onPressed: () async {
final history = ColorHistoryStorage.of(context);
final result = await pickColorFromScreen(context, history);
if (result != null && context.mounted) {
showToast(
context: context,
builder: (context, overlay) {
return SurfaceCard(
child: Row(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text('Color: ${colorToHex(result)}'),
const Gap(16),
Container(
width: 24,
height: 24,
decoration: BoxDecoration(
color: result,
borderRadius: BorderRadius.circular(4),
),
),
],
));
},
);
}
},
child: const Text('Pick Color'),
)

With Trigger
Column(
mainAxisSize: MainAxisSize.min,
children: [
PrimaryButton(
onPressed: () {
showColorPicker(
context: context,
offset: const Offset(0, 8),
color: ColorDerivative.fromColor(Colors.blue),
onColorChanged: (value) {
// Handle color change
},
);
},
child: const Text('Open Color Picker Popover'),
),
const Gap(16),
PrimaryButton(
onPressed: () {
showColorPickerDialog(
context: context,
title: const Text('Select Color'),
onColorChanged: (value) {
// Handle color change
},
color: ColorDerivative.fromColor(Colors.blue),
);
},
child: const Text('Open Color Picker Dialog'),
),
],
)
