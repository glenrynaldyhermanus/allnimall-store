Padding
Container(
color: Colors.red,
child: Container(
color: Colors.green,
child: Container(
color: Colors.blue,
height: 20,
).withPadding(all: 16),
).withPadding(top: 24, bottom: 12, horizontal: 16),
)

Margin
Container(
color: Colors.red,
child: Container(
color: Colors.green,
child: Container(
color: Colors.blue,
height: 20,
).withMargin(all: 16),
).withMargin(top: 24, bottom: 12, horizontal: 16),
)

Center
Container(
color: Colors.red,
height: 30,
width: 30,
).center()

Gapped Row
const Row(
children: [
Text('Item 1'),
Text('Item 2'),
Text('Item 3'),
],
).gap(32)

Separated Column
IntrinsicWidth(
child: const Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Text('Item 1'),
Text('Item 2'),
Text('Item 3'),
],
).separator(const Divider()),
)

Separated Row
@override
Widget build(BuildContext context) {
return IntrinsicHeight(
child: const Row(
crossAxisAlignment: CrossAxisAlignment.stretch,
mainAxisSize: MainAxisSize.min,
children: [
Text(' Item 1 '),
Text(' Item 2 '),
Text(' Item 3 '),
],
).separator(const VerticalDivider()),
);
}

Basic Layout
const Basic(
title: Text('Title'),
leading: Icon(Icons.star),
trailing: Icon(Icons.arrow_forward),
subtitle: Text('Subtitle'),
content: Text('Lorem ipsum dolor sit amet'),
)
