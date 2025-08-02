PrimaryButton(
onPressed: () {
showItemPicker<int>(
context,
title: Text('Pick an item'),
items: ItemBuilder(
itemCount: 1000,
itemBuilder: (index) {
return index;
},
),
builder: (context, item) {
return ItemPickerOption(
value: item, child: Text(item.toString()).large);
},
).then(
(value) {
if (value != null) {
showToast(
context: context,
builder: (context, overlay) {
return SurfaceCard(
child: Text('You picked $value!'),
);
},
);
} else {
showToast(
context: context,
builder: (context, overlay) {
return const SurfaceCard(
child: Text('You picked nothing!'),
);
},
);
}
},
);
},
child: const Text('Show Item Picker'),
)

With Dialog
PrimaryButton(
onPressed: () {
showItemPickerDialog<int>(
context,
title: const Text('Pick a number'),
items: ItemBuilder(
itemBuilder: (index) {
return index;
},
),
builder: (context, item) {
return ItemPickerOption(
value: item, child: Text(item.toString()).large);
},
).then(
(value) {
if (value != null) {
showToast(
context: context,
builder: (context, overlay) {
return SurfaceCard(
child: Text('You picked $value!'),
);
},
);
} else {
showToast(
context: context,
builder: (context, overlay) {
return const SurfaceCard(
child: Text('You picked nothing!'),
);
},
);
}
},
);
},
child: const Text('Show Item Picker'),
)

Fixed List Item
final List<NamedColor> colors = const [
NamedColor('Red', Colors.red),
NamedColor('Green', Colors.green),
NamedColor('Blue', Colors.blue),
NamedColor('Yellow', Colors.yellow),
NamedColor('Purple', Colors.purple),
NamedColor('Cyan', Colors.cyan),
NamedColor('Orange', Colors.orange),
NamedColor('Pink', Colors.pink),
NamedColor('Teal', Colors.teal),
NamedColor('Amber', Colors.amber),
];
int selectedColor = 0;
@override
Widget build(BuildContext context) {
return PrimaryButton(
onPressed: () {
showItemPickerDialog<NamedColor>(
context,
items: ItemList(colors),
initialValue: colors[selectedColor],
title: const Text('Pick a color'),
builder: (context, item) {
return ItemPickerOption(
value: item,
selectedStyle: const ButtonStyle.primary(
shape: ButtonShape.circle,
),
style: const ButtonStyle.ghost(
shape: ButtonShape.circle,
),
label: Text(item.name),
child: Container(
padding: const EdgeInsets.all(8),
width: 100,
height: 100,
alignment: Alignment.center,
decoration:
BoxDecoration(color: item.color, shape: BoxShape.circle),
),
);
},
).then(
(value) {
if (value != null) {
selectedColor = colors.indexOf(value);
showToast(
context: context,
builder: (context, overlay) {
return SurfaceCard(
child: Text('You picked ${value.name}!'),
);
},
);
} else {
showToast(
context: context,
builder: (context, overlay) {
return const SurfaceCard(
child: Text('You picked nothing!'),
);
},
);
}
},
);
},
child: const Text('Show Item Picker'),
);
}

List Layout
final List<NamedColor> colors = const [
NamedColor('Red', Colors.red),
NamedColor('Green', Colors.green),
NamedColor('Blue', Colors.blue),
NamedColor('Yellow', Colors.yellow),
NamedColor('Purple', Colors.purple),
NamedColor('Cyan', Colors.cyan),
NamedColor('Orange', Colors.orange),
NamedColor('Pink', Colors.pink),
NamedColor('Teal', Colors.teal),
NamedColor('Amber', Colors.amber),
];
int selectedColor = 0;
@override
Widget build(BuildContext context) {
return PrimaryButton(
onPressed: () {
showItemPickerDialog<NamedColor>(
context,
items: ItemList(colors),
initialValue: colors[selectedColor],
layout: ItemPickerLayout.list,
title: const Text('Pick a color'),
builder: (context, item) {
return ItemPickerOption(
value: item,
label: Text(item.name),
child: Container(
width: 40,
height: 40,
decoration: BoxDecoration(
color: item.color,
shape: BoxShape.circle,
),
));
},
).then(
(value) {
if (value != null) {
selectedColor = colors.indexOf(value);
showToast(
context: context,
builder: (context, overlay) {
return SurfaceCard(
child: Text('You picked ${value.name}!'),
);
},
);
} else {
showToast(
context: context,
builder: (context, overlay) {
return const SurfaceCard(
child: Text('You picked nothing!'),
);
},
);
}
},
);
},
child: const Text('Show Item Picker'),
);
}

Form Example
final List<NamedColor> colors = const [
NamedColor('Red', Colors.red),
NamedColor('Green', Colors.green),
NamedColor('Blue', Colors.blue),
NamedColor('Yellow', Colors.yellow),
NamedColor('Purple', Colors.purple),
NamedColor('Cyan', Colors.cyan),
NamedColor('Orange', Colors.orange),
NamedColor('Pink', Colors.pink),
NamedColor('Teal', Colors.teal),
NamedColor('Amber', Colors.amber),
];
int selectedColor = 0;
@override
Widget build(BuildContext context) {
return ItemPicker<NamedColor>(
items: ItemList(colors),
mode: PromptMode.popover,
title: const Text('Pick a color'),
builder: (context, item) {
return ItemPickerOption(
value: item,
label: Text(item.name),
style: const ButtonStyle.ghostIcon(
shape: ButtonShape.circle,
),
selectedStyle: const ButtonStyle.primary(
shape: ButtonShape.circle,
),
child: Container(
constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
decoration: BoxDecoration(
color: item.color,
shape: BoxShape.circle,
),
),
);
},
value: colors[selectedColor],
placeholder: const Text('Pick a color'),
onChanged: (value) {
print('You picked $value!');
if (value != null) {
setState(() {
selectedColor = colors.indexOf(value);
});
}
},
);
}
