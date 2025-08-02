List<String> \_chips = [];
List<String> \_suggestions = [];
final TextEditingController \_controller = TextEditingController();
static const List<String> \_availableSuggestions = [
'hello world',
'lorem ipsum',
'do re mi',
'foo bar',
'flutter dart',
];

@override
void initState() {
super.initState();
\_controller.addListener(
() {
setState(() {
var value = \_controller.text;
if (value.isNotEmpty) {
\_suggestions = \_availableSuggestions.where((element) {
return element.startsWith(value);
}).toList();
} else {
\_suggestions = [];
}
});
},
);
}

@override
Widget build(BuildContext context) {
return ChipInput<String>(
controller: \_controller,
onSubmitted: (value) {
setState(() {
\_chips.add(value);
\_suggestions.clear();
\_controller.clear();
});
},
suggestions: \_suggestions,
onSuggestionChoosen: (index) {
setState(() {
\_chips.add(\_suggestions[index]);
\_controller.clear();
});
},
onChanged: (value) {
setState(() {
\_chips = value;
});
},
chips: \_chips,
chipBuilder: (context, chip) {
return Text(chip);
},
);
}
