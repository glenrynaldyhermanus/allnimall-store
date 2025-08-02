Wrap(
spacing: 8,
runSpacing: 8,
children: [
Chip(
trailing: ChipButton(
onPressed: () {},
child: const Icon(Icons.close),
),
child: const Text('Apple'),
),
Chip(
style: const ButtonStyle.primary(),
trailing: ChipButton(
onPressed: () {},
child: const Icon(Icons.close),
),
child: const Text('Banana'),
),
Chip(
style: const ButtonStyle.outline(),
trailing: ChipButton(
onPressed: () {},
child: const Icon(Icons.close),
),
child: const Text('Cherry'),
),
Chip(
style: const ButtonStyle.ghost(),
trailing: ChipButton(
onPressed: () {},
child: const Icon(Icons.close),
),
child: const Text('Durian'),
),
Chip(
style: const ButtonStyle.destructive(),
trailing: ChipButton(
onPressed: () {},
child: const Icon(Icons.close),
),
child: const Text('Elderberry'),
),
],
)
