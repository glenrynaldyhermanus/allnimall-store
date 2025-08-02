Horizontal
const SizedBox(
width: 300,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Text('Item 1'),
Divider(),
Text('Item 2'),
Divider(),
Text('Item 3'),
],
),
)

Vertical
const SizedBox(
width: 300,
height: 100,
child: Row(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Expanded(child: Text('Item 1')),
VerticalDivider(),
Expanded(child: Text('Item 2')),
VerticalDivider(),
Expanded(child: Text('Item 3')),
],
),
)

Divider with Text
const SizedBox(
width: 300,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Text('Item 1'),
Divider(
child: Text('Divider'),
),
Text('Item 2'),
Divider(
child: Text('Divider'),
),
Text('Item 3'),
],
),
)
