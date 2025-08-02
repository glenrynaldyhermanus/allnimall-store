int \_index = 0;
@override
Widget build(BuildContext context) {
return DotIndicator(
index: \_index,
length: 5,
onChanged: (index) {
setState(() {
\_index = index;
});
});
}
