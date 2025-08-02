import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallSelect<T> extends StatelessWidget {
  final T? value;
  final void Function(T?)? onChanged;
  final Widget? placeholder;
  final Widget Function(BuildContext, T) itemBuilder;
  final List<T> items;
  final String? searchPlaceholder;
  final BoxConstraints? constraints;
  final bool enabled;

  const AllnimallSelect({
    super.key,
    this.value,
    this.onChanged,
    this.placeholder,
    required this.itemBuilder,
    required this.items,
    this.searchPlaceholder,
    this.constraints = const BoxConstraints(minHeight: 44, maxHeight: 44),
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildItem(BuildContext context, T item) {
      return itemBuilder(context, item);
    }

    return Select<T>(
      value: value,
      onChanged: enabled ? onChanged : null,
      placeholder: placeholder,
      constraints: constraints,
      itemBuilder: (context, item) => buildItem(context, item),
      popup: SelectPopup.builder(
        searchPlaceholder:
            searchPlaceholder != null ? Text(searchPlaceholder!) : null,
        builder: (context, searchQuery) {
          final filteredItems = searchQuery == null
              ? items
              : items.where((item) {
                  final itemText =
                      buildItem(context, item).toString().toLowerCase();
                  return itemText.contains(searchQuery.toLowerCase());
                }).toList();

          return SelectItemList(
            children: [
              for (final item in filteredItems)
                SelectItemButton(
                  value: item,
                  child: buildItem(context, item),
                ),
            ],
          );
        },
      ),
    );
  }
}
