Horizontal
final CarouselController controller = CarouselController();
@override
Widget build(BuildContext context) {
return SizedBox(
width: 800,
child: Row(
children: [
OutlineButton(
shape: ButtonShape.circle,
onPressed: () {
controller.animatePrevious(const Duration(milliseconds: 500));
},
child: const Icon(Icons.arrow_back)),
const Gap(24),
Expanded(
child: SizedBox(
height: 200,
child: Carousel(
// frameTransform: Carousel.fadingTransform,
transition: const CarouselTransition.sliding(gap: 24),
controller: controller,
sizeConstraint: const CarouselFixedConstraint(200),
autoplaySpeed: const Duration(seconds: 2),
itemCount: 5,
itemBuilder: (context, index) {
return NumberedContainer(index: index);
},
duration: const Duration(seconds: 1),
),
),
),
const Gap(24),
OutlineButton(
shape: ButtonShape.circle,
onPressed: () {
controller.animateNext(const Duration(milliseconds: 500));
},
child: const Icon(Icons.arrow_forward)),
],
),
);
}

Vertical
final CarouselController controller = CarouselController();
@override
Widget build(BuildContext context) {
return SizedBox(
height: 500,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
OutlineButton(
shape: ButtonShape.circle,
onPressed: () {
controller.animatePrevious(const Duration(milliseconds: 500));
},
child: const Icon(Icons.arrow_upward)),
const Gap(24),
Expanded(
child: SizedBox(
width: 200,
child: Carousel(
transition: const CarouselTransition.sliding(gap: 24),
alignment: CarouselAlignment.center,
controller: controller,
direction: Axis.vertical,
sizeConstraint: const CarouselFixedConstraint(200),
itemBuilder: (context, index) {
return NumberedContainer(index: index);
},
),
),
),
const Gap(24),
OutlineButton(
shape: ButtonShape.circle,
onPressed: () {
controller.animateNext(const Duration(milliseconds: 500));
},
child: const Icon(Icons.arrow_downward)),
],
),
);
}

Fading
final CarouselController controller = CarouselController();
@override
Widget build(BuildContext context) {
return SizedBox(
width: 800,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
SizedBox(
height: 200,
child: Carousel(
transition: const CarouselTransition.fading(),
controller: controller,
draggable: false,
autoplaySpeed: const Duration(seconds: 1),
itemCount: 5,
itemBuilder: (context, index) {
return NumberedContainer(index: index);
},
duration: const Duration(seconds: 1),
),
),
const Gap(8),
Row(
mainAxisSize: MainAxisSize.min,
children: [
CarouselDotIndicator(itemCount: 5, controller: controller),
const Spacer(),
OutlineButton(
shape: ButtonShape.circle,
onPressed: () {
controller
.animatePrevious(const Duration(milliseconds: 500));
},
child: const Icon(Icons.arrow_back)),
const Gap(8),
OutlineButton(
shape: ButtonShape.circle,
onPressed: () {
controller.animateNext(const Duration(milliseconds: 500));
},
child: const Icon(Icons.arrow_forward)),
],
),
],
),
);
}

Continous Sliding
final CarouselController controller = CarouselController();
@override
Widget build(BuildContext context) {
return SizedBox(
width: 800,
height: 200,
child: Carousel(
transition: const CarouselTransition.sliding(gap: 24),
controller: controller,
draggable: false,
autoplaySpeed: const Duration(seconds: 2),
curve: Curves.linear,
itemCount: 5,
sizeConstraint: const CarouselSizeConstraint.fixed(200),
itemBuilder: (context, index) {
return NumberedContainer(index: index);
},
duration: Duration.zero,
),
);
}
