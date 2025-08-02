const Column(
children: [
KeyboardDisplay(keys: [
LogicalKeyboardKey.control,
LogicalKeyboardKey.alt,
LogicalKeyboardKey.delete,
]),
Gap(24),
KeyboardDisplay.fromActivator(
activator: SingleActivator(
LogicalKeyboardKey.keyA,
control: true,
shift: true,
),
)
],
).textSmall()
