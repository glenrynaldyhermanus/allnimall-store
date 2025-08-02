#Number Ticker
int \_number = 0;
final TextEditingController \_controller = TextEditingController();

@override
Widget build(BuildContext context) {
return Column(
children: [
NumberTicker(
initialNumber: 0,
number: _number,
style: const TextStyle(fontSize: 32),
formatter: (number) {
return NumberFormat.compact().format(number);
},
),
const Gap(24),
TextField(
initialValue: _number.toString(),
controller: _controller,
onEditingComplete: () {
int? number = int.tryParse(_controller.text);
if (number != null) {
setState(() {
_number = number;
});
}
},
)
],
);
}
