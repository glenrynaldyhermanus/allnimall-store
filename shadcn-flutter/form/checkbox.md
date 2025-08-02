Basic
CheckboxState \_state = CheckboxState.unchecked;
@override
Widget build(BuildContext context) {
return Checkbox(
state: \_state,
onChanged: (value) {
setState(() {
\_state = value;
});
},
trailing: const Text('Remember me'),
);
}

Tristate
CheckboxState \_state = CheckboxState.unchecked;
@override
Widget build(BuildContext context) {
return Checkbox(
state: \_state,
onChanged: (value) {
setState(() {
\_state = value;
});
},
trailing: const Text('Remember me'),
tristate: true,
);
}
