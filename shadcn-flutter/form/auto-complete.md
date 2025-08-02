final List<String> suggestions = [
'Apple',
'Banana',
'Cherry',
'Date',
'Grape',
'Kiwi',
'Lemon',
'Mango',
'Orange',
'Peach',
'Pear',
'Pineapple',
'Strawberry',
'Watermelon',
];

List<String> \_currentSuggestions = [];
final TextEditingController \_controller = TextEditingController();

void \_updateSuggestions(String value) {
String? currentWord = \_controller.currentWord;
if (currentWord == null || currentWord.isEmpty) {
setState(() {
\_currentSuggestions = [];
});
return;
}
setState(() {
\_currentSuggestions = suggestions
.where((element) =>
element.toLowerCase().contains(currentWord.toLowerCase()))
.toList();
});
}

@override
Widget build(BuildContext context) {
return AutoComplete(
suggestions: \_currentSuggestions,
child: TextField(
controller: \_controller,
onChanged: \_updateSuggestions,
trailing: const IconButton.text(
density: ButtonDensity.compact,
icon: Icon(Icons.clear),
onPressed: clearActiveTextInput,
),
),
);
}
