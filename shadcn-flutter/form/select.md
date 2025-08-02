String? selectedValue;
@override
Widget build(BuildContext context) {
return Select<String>(
itemBuilder: (context, item) {
return Text(item);
},
popupConstraints: const BoxConstraints(
maxHeight: 300,
maxWidth: 200,
),
onChanged: (value) {
setState(() {
selectedValue = value;
});
},
value: selectedValue,
placeholder: const Text('Select a fruit'),
popup: const SelectPopup(
items: SelectItemList(
children: [
SelectItemButton(
value: 'Apple',
child: Text('Apple'),
),
SelectItemButton(
value: 'Banana',
child: Text('Banana'),
),
SelectItemButton(
value: 'Cherry',
child: Text('Cherry'),
),
],
),
),
);
}

With Search
final Map<String, List<String>> fruits = {
'Apple': ['Red Apple', 'Green Apple'],
'Banana': ['Yellow Banana', 'Brown Banana'],
'Lemon': ['Yellow Lemon', 'Green Lemon'],
'Tomato': ['Red', 'Green', 'Yellow', 'Brown'],
};
String? selectedValue;

Iterable<MapEntry<String, List<String>>> \_filteredFruits(
String searchQuery) sync\* {
for (final entry in fruits.entries) {
final filteredValues = entry.value
.where((value) => \_filterName(value, searchQuery))
.toList();
if (filteredValues.isNotEmpty) {
yield MapEntry(entry.key, filteredValues);
} else if (\_filterName(entry.key, searchQuery)) {
yield entry;
}
}
}

bool \_filterName(String name, String searchQuery) {
return name.toLowerCase().contains(searchQuery);
}

@override
Widget build(BuildContext context) {
return Select<String>(
itemBuilder: (context, item) {
return Text(item);
},
popup: SelectPopup.builder(
searchPlaceholder: const Text('Search fruit'),
builder: (context, searchQuery) {
final filteredFruits = searchQuery == null
? fruits.entries
: \_filteredFruits(searchQuery);
return SelectItemList(
children: [
for (final entry in filteredFruits)
SelectGroup(
headers: [
SelectLabel(
child: Text(entry.key),
),
],
children: [
for (final value in entry.value)
SelectItemButton(
value: value,
child: Text(value),
),
],
),
],
);
},
),
onChanged: (value) {
setState(() {
selectedValue = value;
});
},
constraints: const BoxConstraints(
minWidth: 200,
),
value: selectedValue,
placeholder: const Text('Select a fruit'),
);
}

Async Infinite
final Map<String, List<String>> fruits = {
'Apple': ['Red Apple', 'Green Apple'],
'Banana': ['Yellow Banana', 'Brown Banana'],
'Lemon': ['Yellow Lemon', 'Green Lemon'],
'Tomato': ['Red', 'Green', 'Yellow', 'Brown'],
};
String? selectedValue;

Iterable<MapEntry<String, List<String>>> \_filteredFruits(
String searchQuery) sync\* {
for (final entry in fruits.entries) {
final filteredValues = entry.value
.where((value) => \_filterName(value, searchQuery))
.toList();
if (filteredValues.isNotEmpty) {
yield MapEntry(entry.key, filteredValues);
} else if (\_filterName(entry.key, searchQuery)) {
yield entry;
}
}
}

bool \_filterName(String name, String searchQuery) {
return name.toLowerCase().contains(searchQuery);
}

@override
Widget build(BuildContext context) {
return Select<String>(
itemBuilder: (context, item) {
return Text(item);
},
popup: SelectPopup.builder(
searchPlaceholder: const Text('Search fruit'),
emptyBuilder: (context) {
return const Center(
child: Text('No fruit found'),
);
},
loadingBuilder: (context) {
return const Center(
child: CircularProgressIndicator(),
);
},
builder: (context, searchQuery) async {
final filteredFruits = searchQuery == null
? fruits.entries.toList()
: \_filteredFruits(searchQuery).toList();
// Simulate a delay for loading
// In a real-world scenario, you would fetch data from an API or database
await Future.delayed(const Duration(milliseconds: 500));
return SelectItemBuilder(
childCount: filteredFruits.isEmpty ? 0 : null,
builder: (context, index) {
final entry = filteredFruits[index % filteredFruits.length];
return SelectGroup(
headers: [
SelectLabel(
child: Text(entry.key),
),
],
children: [
for (final value in entry.value)
SelectItemButton(
value: value,
child: Text(value),
),
],
);
},
);
},
),
onChanged: (value) {
setState(() {
selectedValue = value;
});
},
constraints: const BoxConstraints(
minWidth: 200,
),
value: selectedValue,
placeholder: const Text('Select a fruit'),
);
}

No Virtualization
String? selectedValue;
@override
Widget build(BuildContext context) {
return Select<String>(
itemBuilder: (context, item) {
return Text(item);
},
popupConstraints: const BoxConstraints(
maxHeight: 300,
maxWidth: 200,
),
onChanged: (value) {
setState(() {
selectedValue = value;
});
},
value: selectedValue,
placeholder: const Text('Select a fruit'),
popupWidthConstraint: PopoverConstraint.intrinsic,
popup: const SelectPopup.noVirtualization(
items: SelectItemList(
children: [
SelectItemButton(
value: 'Apple',
child: Text('Apple'),
),
SelectItemButton(
value: 'Banana',
child: Text('Banana'),
),
SelectItemButton(
value: 'Cherry',
child: Text('Cherry'),
),
],
),
),
);
}
