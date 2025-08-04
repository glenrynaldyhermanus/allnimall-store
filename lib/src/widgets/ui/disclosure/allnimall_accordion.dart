import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallAccordion extends StatelessWidget {
  final List<AllnimallAccordionItem> items;

  const AllnimallAccordion({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Accordion(
      items: items.map((item) => item.toAccordionItem()).toList(),
    );
  }
}

class AllnimallAccordionItem {
  final Widget trigger;
  final Widget content;

  const AllnimallAccordionItem({
    required this.trigger,
    required this.content,
  });

  AccordionItem toAccordionItem() {
    return AccordionItem(
      trigger: AllnimallAccordionTrigger(child: trigger),
      content: AllnimallAccordionContent(child: content),
    );
  }
}

class AllnimallAccordionTrigger extends StatelessWidget {
  final Widget child;

  const AllnimallAccordionTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AccordionTrigger(
      child: child,
    );
  }
}

class AllnimallAccordionContent extends StatelessWidget {
  final Widget child;

  const AllnimallAccordionContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child.withPadding(top: 16);
  }
}

// Helper class untuk membuat accordion dengan mudah
class AllnimallAccordionBuilder {
  static AllnimallAccordion fromItems({
    required List<AllnimallAccordionItem> items,
  }) {
    return AllnimallAccordion(items: items);
  }
}
