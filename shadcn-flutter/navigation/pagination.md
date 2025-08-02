int page = 1;
@override
Widget build(BuildContext context) {
return Pagination(
page: page,
totalPages: 20,
onPageChanged: (value) {
setState(() {
page = value;
});
},
maxPages: 3,
);
}
