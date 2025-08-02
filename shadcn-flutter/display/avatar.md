Avatar(
backgroundColor: Colors.red,
initials: Avatar.getInitials('sunarya-thito'),
provider: const NetworkImage(
'https://avatars.githubusercontent.com/u/64018564?v=4'),
)

Username Initials
Avatar(
initials: Avatar.getInitials('sunarya-thito'),
size: 64,
)

With Badge
Avatar(
initials: Avatar.getInitials('sunarya-thito'),
size: 64,
badge: const AvatarBadge(
size: 20,
color: Colors.green,
),
)
