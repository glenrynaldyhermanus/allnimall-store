bool value = false;

@override
Widget build(BuildContext context) {
return Switch(
value: value,
onChanged: (value) {
setState(() {
this.value = value;
});
},
);
}
