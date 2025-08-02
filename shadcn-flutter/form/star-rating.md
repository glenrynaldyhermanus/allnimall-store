double value = 1.5;
@override
Widget build(BuildContext context) {
return StarRating(
starSize: 32,
value: value,
onChanged: (value) {
setState(() {
this.value = value;
});
},
);
}
