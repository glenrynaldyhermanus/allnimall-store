EXAMPLE
const TextField(
placeholder: Text('Enter your name'),
)

FEATURES EXAMPLE
Column(
children: [
TextField(
placeholder: const Text('Enter your name'),
features: [
const InputFeature.clear(),
InputFeature.hint(
popupBuilder: (context) {
return const TooltipContainer(
child: Text('This is for your username'));
},
),
const InputFeature.copy(),
const InputFeature.paste(),
],
),
const Gap(24),
const TextField(
placeholder: Text('Enter your password'),
features: [
InputFeature.clear(
visibility: InputFeatureVisibility.textNotEmpty,
),
InputFeature.passwordToggle(mode: PasswordPeekMode.hold),
],
),
],
)

REVALIDATE EXAMPLE
Form(
child: FormField(
key: const InputKey(#test),
label: const Text('Username'),
validator: ConditionalValidator((value) async {
// simulate a network delay for example purpose
await Future.delayed(const Duration(seconds: 1));
return !['sunarya-thito', 'septogeddon', 'admin'].contains(value);
}, message: 'Username already taken'),
child: const TextField(
placeholder: Text('Enter your username'),
initialValue: 'sunarya-thito',
features: [
InputFeature.revalidate(),
],
),
),
)
