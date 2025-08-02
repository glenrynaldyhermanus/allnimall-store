Headline 1
const Text('Headline 1').h1

Headline 2
const Text('Headline 2').h2

Headline 3
const Text('Headline 3').h3

Headline 4
const Text('Headline 4').h4

Paragraph
const Text('Paragraph').p

Blockquote
const Text('Blockquote').blockQuote

List
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text('List item 1').li,
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text('Nested list:'),
const Text('Nested list item 1').li,
const Text('Nested list item 2').li,
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text('Nested list:'),
const Text('Nested list item 1').li,
const Text('Nested list item 2').li,
],
).li,
],
).li,
const Text('List item 3').li,
],
)

Inline Code
const Text('flutter pub add shadcn_flutter').inlineCode

Lead
const Text('Lead').lead

Large Text
const Text('Large text').textLarge

Small Text
const Text('Small text').textSmall

Muted Text
const Text('Muted text').muted

Sans
const Text('Lorem ipsum dolor sit amet').sans

Mono
const Text('Lorem ipsum dolor sit amet').mono

Extra Small
const Text('Lorem ipsum dolor sit amet').xSmall

Small
const Text('Lorem ipsum dolor sit amet').small

Base
const Text('Lorem ipsum dolor sit amet').base

Large
const Text('Lorem ipsum dolor sit amet').large

Extra Large
const Text('Lorem ipsum dolor sit amet').xLarge

Extra 2x Large
const Text('Lorem ipsum dolor sit amet').x2Large

Extra 3x Large
const Text('Lorem ipsum dolor sit amet').x3Large

Extra 4x Large
const Text('Lorem ipsum dolor sit amet').x4Large

Extra 5x Large
const Text('Lorem ipsum dolor sit amet').x5Large

Extra 6x Large
const Text('Lorem ipsum dolor sit amet').x6Large

Extra 7x Large
const Text('Lorem ipsum dolor sit amet').x7Large

Extra 8x Large
const Text('Lorem ipsum dolor sit amet').x8Large

Extra 9x Large
const Text('Lorem ipsum dolor sit amet').x9Large

Thin
const Text('Lorem ipsum dolor sit amet').thin

Extra Light
const Text('Lorem ipsum dolor sit amet').extraLight

Light
const Text('Lorem ipsum dolor sit amet').light

Normal
const Text('Lorem ipsum dolor sit amet').normal

Medium
const Text('Lorem ipsum dolor sit amet').medium

Semi Bold
const Text('Lorem ipsum dolor sit amet').semiBold

Bold
const Text('Lorem ipsum dolor sit amet').bold

Extra Bold
const Text('Lorem ipsum dolor sit amet').extraBold

Black
const Text('Lorem ipsum dolor sit amet').black

Italic
const Text('Lorem ipsum dolor sit amet').italic
