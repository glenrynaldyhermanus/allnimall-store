double value = 0;
@override
Widget build(BuildContext context) {
return Column(
children: [
SizedBox(
width: 100,
child: TextField(
initialValue: value.toString(),
onChanged: (value) {
setState(() {
this.value = double.tryParse(value) ?? 0;
});
},
features: const [
InputFeature.spinner(),
],
submitFormatters: [
TextInputFormatters.mathExpression(),
],
),
),
gap(8),
Text('Value: $value'),
],
);
}
