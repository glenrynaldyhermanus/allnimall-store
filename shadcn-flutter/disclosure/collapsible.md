Collapsible(
children: [
const CollapsibleTrigger(
child: Text('@sunarya-thito starred 3 repositories'),
),
OutlinedContainer(
child: const Text('@sunarya-thito/shadcn_flutter')
.small()
.mono()
.withPadding(horizontal: 16, vertical: 8),
).withPadding(top: 8),
CollapsibleContent(
child: OutlinedContainer(
child: const Text('@flutter/flutter')
.small()
.mono()
.withPadding(horizontal: 16, vertical: 8),
).withPadding(top: 8),
),
CollapsibleContent(
child: OutlinedContainer(
child: const Text('@dart-lang/sdk')
.small()
.mono()
.withPadding(horizontal: 16, vertical: 8),
).withPadding(top: 8),
),
],
)
