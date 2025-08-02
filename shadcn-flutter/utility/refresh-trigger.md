final GlobalKey<RefreshTriggerState> \_refreshTriggerKey =
GlobalKey<RefreshTriggerState>();
@override
Widget build(BuildContext context) {
return RefreshTrigger(
key: \_refreshTriggerKey,
onRefresh: () async {
await Future.delayed(const Duration(seconds: 2));
},
child: SingleChildScrollView(
child: Container(
height: 800,
padding: const EdgeInsets.only(top: 32),
alignment: Alignment.topCenter,
child: Column(
children: [
const Text('Pull Me'),
const Gap(16),
PrimaryButton(
onPressed: () {
_refreshTriggerKey.currentState!.refresh();
},
child: const Text('Refresh'),
),
],
),
),
),
);
}
