Horizontal
@override
Widget build(BuildContext context) {
return const OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: ResizablePanel.horizontal(
children: [
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 0,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 1,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 120,
child: NumberedContainer(
index: 2,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 3,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 4,
height: 200,
fill: false,
),
),
],
),
);
}

Vertical
@override
Widget build(BuildContext context) {
return const OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: ResizablePanel.vertical(
children: [
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 0,
width: 200,
fill: false,
),
),
ResizablePane(
initialSize: 120,
child: NumberedContainer(
index: 1,
width: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 2,
width: 200,
fill: false,
),
),
],
),
);
}

Horizontal with Dragger
@override
Widget build(BuildContext context) {
return OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: ResizablePanel.horizontal(
draggerBuilder: (context) {
return const HorizontalResizableDragger();
},
children: const [
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 0,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 1,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 120,
child: NumberedContainer(
index: 2,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 3,
height: 200,
fill: false,
),
),
ResizablePane(
initialSize: 80,
child: NumberedContainer(
index: 4,
height: 200,
fill: false,
),
),
],
),
);
}

Controller
final AbsoluteResizablePaneController controller1 =
AbsoluteResizablePaneController(80);
final AbsoluteResizablePaneController controller2 =
AbsoluteResizablePaneController(80);
final AbsoluteResizablePaneController controller3 =
AbsoluteResizablePaneController(120);
final AbsoluteResizablePaneController controller4 =
AbsoluteResizablePaneController(80);
final AbsoluteResizablePaneController controller5 =
AbsoluteResizablePaneController(80);
@override
Widget build(BuildContext context) {
return Column(
children: [
OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: ResizablePanel.horizontal(
children: [
ResizablePane.controlled(
controller: controller1,
child: const NumberedContainer(
index: 0,
height: 200,
fill: false,
),
),
ResizablePane.controlled(
controller: controller2,
child: const NumberedContainer(
index: 1,
height: 200,
fill: false,
),
),
ResizablePane.controlled(
controller: controller3,
maxSize: 200,
child: const NumberedContainer(
index: 2,
height: 200,
fill: false,
),
),
ResizablePane.controlled(
controller: controller4,
child: const NumberedContainer(
index: 3,
height: 200,
fill: false,
),
),
ResizablePane.controlled(
controller: controller5,
minSize: 80,
collapsedSize: 20,
child: const NumberedContainer(
index: 4,
height: 200,
fill: false,
),
),
],
),
),
const Gap(48),
Wrap(
spacing: 16,
runSpacing: 16,
children: [
PrimaryButton(
onPressed: () {
controller1.size = 80;
controller2.size = 80;
controller3.size = 120;
controller4.size = 80;
controller5.size = 80;
},
child: const Text('Reset'),
),
PrimaryButton(
onPressed: () {
controller3.tryExpandSize(20);
},
child: const Text('Expand Panel 2'),
),
PrimaryButton(
onPressed: () {
controller3.tryExpandSize(-20);
},
child: const Text('Shrink Panel 2'),
),
PrimaryButton(
onPressed: () {
controller2.tryExpandSize(20);
},
child: const Text('Expand Panel 1'),
),
PrimaryButton(
onPressed: () {
controller2.tryExpandSize(-20);
},
child: const Text('Shrink Panel 1'),
),
PrimaryButton(
onPressed: () {
controller5.tryExpandSize(20);
},
child: const Text('Expand Panel 4'),
),
PrimaryButton(
onPressed: () {
controller5.tryExpandSize(-20);
},
child: const Text('Shrink Panel 4'),
),
PrimaryButton(
onPressed: () {
controller5.tryCollapse();
},
child: const Text('Collapse Panel 4'),
),
PrimaryButton(
onPressed: () {
controller5.tryExpand();
},
child: const Text('Expand Panel 4'),
),
],
)
],
);
}

Collapsible
final ResizablePaneController controller =
AbsoluteResizablePaneController(120);
final ResizablePaneController controller2 =
AbsoluteResizablePaneController(120);
@override
Widget build(BuildContext context) {
return OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: ResizablePanel.horizontal(
children: [
ResizablePane.controlled(
minSize: 100,
collapsedSize: 40,
controller: controller,
child: AnimatedBuilder(
animation: controller,
builder: (context, child) {
if (controller.collapsed) {
return Container(
alignment: Alignment.center,
height: 200,
child: const RotatedBox(
quarterTurns: -1,
child: Text('Collapsed'),
),
);
}
return Container(
alignment: Alignment.center,
height: 200,
child: const Text('Expanded'),
);
},
),
),
ResizablePane(
initialSize: 300,
child: Container(
alignment: Alignment.center,
height: 200,
child: const Text('Resizable'),
),
),
ResizablePane.controlled(
minSize: 100,
collapsedSize: 40,
controller: controller2,
child: AnimatedBuilder(
animation: controller2,
builder: (context, child) {
if (controller2.collapsed) {
return Container(
alignment: Alignment.center,
height: 200,
child: const RotatedBox(
quarterTurns: -1,
child: Text('Collapsed'),
),
);
}
return Container(
alignment: Alignment.center,
height: 200,
child: const Text('Expanded'),
);
},
),
),
],
),
);
}

Nested
@override
Widget build(BuildContext context) {
return const OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: ResizablePanel.horizontal(
children: [
ResizablePane(
initialSize: 100,
minSize: 40,
child: NumberedContainer(
index: 0,
height: 200,
fill: false,
),
),
ResizablePane(
minSize: 100,
initialSize: 300,
child: ResizablePanel.vertical(
children: [
ResizablePane(
initialSize: 80,
minSize: 40,
child: NumberedContainer(
index: 1,
fill: false,
),
),
ResizablePane(
minSize: 40,
initialSize: 120,
child: ResizablePanel.horizontal(
children: [
ResizablePane.flex(
child: NumberedContainer(
index: 2,
fill: false,
),
),
ResizablePane.flex(
child: NumberedContainer(
index: 3,
fill: false,
),
),
ResizablePane.flex(
child: NumberedContainer(
index: 4,
fill: false,
),
),
],
),
),
],
),
),
ResizablePane(
initialSize: 100,
minSize: 40,
child: NumberedContainer(
index: 5,
height: 200,
fill: false,
),
),
],
),
);
}

Dynamic Children
final List<Color> \_items = List.generate(2, (index) => \_generateColor());

static Color \_generateColor() {
Random random = Random();
return HSVColor.fromAHSV(
1.0,
random.nextInt(360).toDouble(),
0.8,
0.8,
).toColor();
}

@override
Widget build(BuildContext context) {
return OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: Column(
mainAxisSize: MainAxisSize.min,
spacing: 12,
children: [
ResizablePanel.vertical(
children: [
for (int i = 0; i < \_items.length; i++)
ResizablePane(
key: ValueKey(\_items[i].toARGB32()),
initialSize: 200,
minSize: 100,
child: Container(
color: \_items[i],
child: Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextButton(
child: Text('Insert Before'),
onPressed: () {
setState(() {
_items.insert(i, _generateColor());
});
},
),
TextButton(
child: Text('Remove'),
onPressed: () {
setState(() {
_items.removeAt(i);
});
},
),
TextButton(
child: Text('Insert After'),
onPressed: () {
setState(() {
_items.insert(i + 1, _generateColor());
});
},
),
],
),
),
),
),
],
),
PrimaryButton(
child: Text('Add'),
onPressed: () {
setState(() {
\_items.add(\_generateColor());
});
},
),
],
),
);
}
