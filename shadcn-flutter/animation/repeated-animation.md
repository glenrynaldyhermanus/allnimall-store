RepeatedAnimationBuilder(
start: const Offset(-100, 0),
end: const Offset(100, 0),
duration: const Duration(seconds: 1),
builder: (context, value, child) {
return Transform.translate(
offset: value,
child: Container(
width: 100,
height: 100,
color: Colors.red,
),
);
},
)

Reverse
RepeatedAnimationBuilder(
start: const Offset(-100, 0),
end: const Offset(100, 0),
duration: const Duration(seconds: 1),
curve: Curves.easeInOutCubic,
mode: RepeatMode.reverse,
builder: (context, value, child) {
return Transform.translate(
offset: value,
child: Container(
width: 100,
height: 100,
color: Colors.red,
),
);
},
)

Ping Pong
bool play = true;
@override
Widget build(BuildContext context) {
return Column(
mainAxisSize: MainAxisSize.min,
children: [
RepeatedAnimationBuilder(
play: play,
start: const Offset(-100, 0),
end: const Offset(100, 0),
duration: const Duration(seconds: 1),
reverseDuration: const Duration(seconds: 5),
curve: Curves.linear,
reverseCurve: Curves.easeInOutCubic,
mode: RepeatMode.pingPongReverse,
builder: (context, value, child) {
return Transform.translate(
offset: value,
child: Container(
width: 100,
height: 100,
color: Colors.red,
),
);
},
),
const Gap(24),
PrimaryButton(
onPressed: () {
setState(() {
play = !play;
});
},
child: Text(play ? 'Stop' : 'Play'),
)
],
);
}
