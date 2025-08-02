List<AvatarWidget> getAvatars() {
return [
Avatar(
initials: Avatar.getInitials('sunarya-thito'),
backgroundColor: Colors.red,
),
Avatar(
initials: Avatar.getInitials('sunarya-thito'),
backgroundColor: Colors.green,
),
Avatar(
initials: Avatar.getInitials('sunarya-thito'),
backgroundColor: Colors.blue,
),
Avatar(
initials: Avatar.getInitials('sunarya-thito'),
backgroundColor: Colors.yellow,
),
];
}

@override
Widget build(BuildContext context) {
return Wrap(
spacing: 16,
runSpacing: 16,
children: [
AvatarGroup.toLeft(children: getAvatars()),
AvatarGroup.toRight(children: getAvatars()),
AvatarGroup.toTop(children: getAvatars()),
AvatarGroup.toBottom(children: getAvatars()),
],
);
}
