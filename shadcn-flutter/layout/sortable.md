List<SortableData<String>> invited = [
const SortableData('James'),
const SortableData('John'),
const SortableData('Robert'),
const SortableData('Michael'),
const SortableData('William'),
];
List<SortableData<String>> reserved = [
const SortableData('David'),
const SortableData('Richard'),
const SortableData('Joseph'),
const SortableData('Thomas'),
const SortableData('Charles'),
];

@override
void initState() {
super.initState();
}

@override
Widget build(BuildContext context) {
return SizedBox(
height: 500,
child: SortableLayer(
child: Row(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Expanded(
child: Card(
child: SortableDropFallback<String>(
onAccept: (value) {
setState(() {
swapItemInLists(
[invited, reserved], value, invited, invited.length);
});
},
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
for (int i = 0; i < invited.length; i++)
Sortable<String>(
data: invited[i],
onAcceptTop: (value) {
setState(() {
swapItemInLists(
[invited, reserved], value, invited, i);
});
},
onAcceptBottom: (value) {
setState(() {
swapItemInLists(
[invited, reserved], value, invited, i + 1);
});
},
child: OutlinedContainer(
padding: const EdgeInsets.all(12),
child: Center(child: Text(invited[i].data)),
),
),
],
),
),
),
),
gap(12),
Expanded(
child: Card(
child: SortableDropFallback<String>(
onAccept: (value) {
setState(() {
swapItemInLists([invited, reserved], value, reserved,
reserved.length);
});
},
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
for (int i = 0; i < reserved.length; i++)
Sortable<String>(
data: reserved[i],
onAcceptTop: (value) {
setState(() {
swapItemInLists(
[invited, reserved], value, reserved, i);
});
},
onAcceptBottom: (value) {
setState(() {
swapItemInLists(
[invited, reserved], value, reserved, i + 1);
});
},
child: OutlinedContainer(
padding: const EdgeInsets.all(12),
child: Center(child: Text(reserved[i].data)),
),
),
],
),
),
),
),
],
),
),
);
}

Locked Axis
List<SortableData<String>> names = [
const SortableData('James'),
const SortableData('John'),
const SortableData('Robert'),
const SortableData('Michael'),
const SortableData('William'),
];

@override
Widget build(BuildContext context) {
return SortableLayer(
lock: true,
child: SortableDropFallback<int>(
onAccept: (value) {
setState(() {
names.add(names.removeAt(value.data));
});
},
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
for (int i = 0; i < names.length; i++)
Sortable<String>(
key: ValueKey(i),
data: names[i],
onAcceptTop: (value) {
setState(() {
names.swapItem(value, i);
});
},
onAcceptBottom: (value) {
setState(() {
names.swapItem(value, i + 1);
});
},
child: OutlinedContainer(
padding: const EdgeInsets.all(12),
child: Center(child: Text(names[i].data)),
),
),
],
),
),
);
}

Horizontal
List<SortableData<String>> names = [
const SortableData('James'),
const SortableData('John'),
const SortableData('Robert'),
const SortableData('Michael'),
const SortableData('William'),
];

@override
Widget build(BuildContext context) {
return SortableLayer(
lock: true,
child: SortableDropFallback<int>(
onAccept: (value) {
setState(() {
names.add(names.removeAt(value.data));
});
},
child: SizedBox(
height: 50,
child: Row(
crossAxisAlignment: CrossAxisAlignment.stretch,
mainAxisSize: MainAxisSize.min,
children: [
for (int i = 0; i < names.length; i++)
Sortable<String>(
key: ValueKey(i),
data: names[i],
onAcceptLeft: (value) {
setState(() {
names.swapItem(value, i);
});
},
onAcceptRight: (value) {
setState(() {
names.swapItem(value, i + 1);
});
},
child: OutlinedContainer(
width: 100,
padding: const EdgeInsets.all(12),
child: Center(child: Text(names[i].data)),
),
),
],
),
),
),
);
}

ListView
List<SortableData<String>> names = [
const SortableData('James'),
const SortableData('John'),
const SortableData('Robert'),
const SortableData('Michael'),
const SortableData('William'),
const SortableData('David'),
const SortableData('Richard'),
const SortableData('Joseph'),
const SortableData('Thomas'),
const SortableData('Charles'),
const SortableData('Daniel'),
const SortableData('Matthew'),
const SortableData('Anthony'),
const SortableData('Donald'),
const SortableData('Mark'),
const SortableData('Paul'),
const SortableData('Steven'),
const SortableData('Andrew'),
const SortableData('Kenneth'),
];

final ScrollController controller = ScrollController();

@override
Widget build(BuildContext context) {
return SizedBox(
height: 400,
child: SortableLayer(
lock: true,
child: SortableDropFallback<int>(
onAccept: (value) {
setState(() {
names.add(names.removeAt(value.data));
});
},
child: ScrollableSortableLayer(
controller: controller,
child: ListView.builder(
controller: controller,
itemBuilder: (context, i) {
return Sortable<String>(
key: ValueKey(i),
data: names[i],
onAcceptTop: (value) {
setState(() {
names.swapItem(value, i);
});
},
onAcceptBottom: (value) {
setState(() {
names.swapItem(value, i + 1);
});
},
child: OutlinedContainer(
padding: const EdgeInsets.all(12),
child: Center(child: Text(names[i].data)),
),
);
},
itemCount: names.length,
),
),
),
),
);
}

Drag Handle
List<SortableData<String>> names = [
const SortableData('James'),
const SortableData('John'),
const SortableData('Robert'),
const SortableData('Michael'),
const SortableData('William'),
];

@override
Widget build(BuildContext context) {
return SortableLayer(
lock: true,
child: SortableDropFallback<int>(
onAccept: (value) {
setState(() {
names.add(names.removeAt(value.data));
});
},
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
for (int i = 0; i < names.length; i++)
Sortable<String>(
key: ValueKey(i),
data: names[i],
// we only want user to drag the item from the handle,
// so we disable the drag on the item itself
enabled: false,
onAcceptTop: (value) {
setState(() {
names.swapItem(value, i);
});
},
onAcceptBottom: (value) {
setState(() {
names.swapItem(value, i + 1);
});
},
child: OutlinedContainer(
padding: const EdgeInsets.all(12),
child: Row(
children: [
const SortableDragHandle(child: Icon(Icons.drag_handle)),
const SizedBox(width: 8),
Expanded(child: Text(names[i].data)),
],
),
),
),
],
),
),
);
}

Remove Item
late List<SortableData<String>> names;

@override
void initState() {
super.initState();
\_reset();
}

void \_reset() {
names = [
const SortableData('James'),
const SortableData('John'),
const SortableData('Robert'),
const SortableData('Michael'),
const SortableData('William'),
];
}

@override
Widget build(BuildContext context) {
return SortableLayer(
child: Builder(
// this builder is needed to access the context of the SortableLayer
builder: (context) {
return SortableDropFallback<int>(
onAccept: (value) {
setState(() {
names.add(names.removeAt(value.data));
});
},
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
PrimaryButton(
onPressed: () {
setState(() {
\_reset();
});
},
child: const Text('Reset'),
),
for (int i = 0; i < names.length; i++)
Sortable<String>(
key: ValueKey(i),
data: names[i],
// we only want user to drag the item from the handle,
// so we disable the drag on the item itself
enabled: false,
onAcceptTop: (value) {
setState(() {
names.swapItem(value, i);
});
},
onAcceptBottom: (value) {
setState(() {
names.swapItem(value, i + 1);
});
},
onDropFailed: () {
// Remove the item from the list if the drop failed
setState(() {
var removed = names.removeAt(i);
SortableLayer.ensureAndDismissDrop(context, removed);
// Dismissing drop will prevent the SortableLayer from
// animating the item back to its original position
});
},
child: OutlinedContainer(
padding: const EdgeInsets.all(12),
child: Row(
children: [
const SortableDragHandle(
child: Icon(Icons.drag_handle)),
const SizedBox(width: 8),
Expanded(child: Text(names[i].data)),
],
),
),
),
],
),
);
}),
);
}
