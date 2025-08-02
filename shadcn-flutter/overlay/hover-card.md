HoverCard(
hoverBuilder: (context) {
return const SurfaceCard(
child: Basic(
leading: FlutterLogo(),
title: Text('@flutter'),
content: Text(
'The Flutter SDK provides the tools to build beautiful apps for mobile, web, and desktop from a single codebase.'),
),
).sized(width: 300);
},
child: LinkButton(
onPressed: () {},
child: const Text('@flutter'),
),
)
