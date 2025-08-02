OutlinedContainer(
clipBehavior: Clip.antiAlias,
child: AppBar(
header: const Text('This is Header'),
title: const Text('This is Title'),
subtitle: const Text('This is Subtitle'),
leading: [
OutlineButton(
density: ButtonDensity.icon,
onPressed: () {},
child: const Icon(Icons.arrow_back),
),
],
trailing: [
OutlineButton(
density: ButtonDensity.icon,
onPressed: () {},
child: const Icon(Icons.search),
),
OutlineButton(
density: ButtonDensity.icon,
onPressed: () {},
child: const Icon(Icons.more_vert),
),
],
),
)
