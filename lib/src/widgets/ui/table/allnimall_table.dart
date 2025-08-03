import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallTable extends StatelessWidget {
  final List<TableRow> rows;
  final List<TableCell> headers;
  final bool showHeader;
  final bool resizable;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const AllnimallTable({
    super.key,
    required this.rows,
    this.headers = const [],
    this.showHeader = true,
    this.resizable = true,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 600,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 200,
        maxHeight: maxHeight ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.card,
        borderRadius: borderRadius ?? theme.borderRadiusLg,
        border: Border.all(
          color: borderColor ?? theme.colorScheme.border,
          width: 1,
        ),
      ),
      child: resizable ? _buildResizableTable() : _buildBasicTable(),
    );
  }

  Widget _buildResizableTable() {
    return ResizableTable(
      controller: ResizableTableController(
        defaultColumnWidth: 150,
        defaultRowHeight: 40,
        defaultHeightConstraint: const ConstrainedTableSize(min: 40),
        defaultWidthConstraint: const ConstrainedTableSize(min: 80),
      ),
      rows: [
        if (showHeader && headers.isNotEmpty) TableHeader(cells: headers),
        ...rows,
      ],
    );
  }

  Widget _buildBasicTable() {
    return Table(
      rows: [
        if (showHeader && headers.isNotEmpty) TableRow(cells: headers),
        ...rows,
      ],
    );
  }
}

// Helper class untuk membuat table cell dengan styling yang konsisten
class AllnimallTableCell {
  final Widget child;
  final bool isHeader;
  final Alignment? alignment;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const AllnimallTableCell({
    required this.child,
    this.isHeader = false,
    this.alignment,
    this.padding,
    this.backgroundColor,
    this.textStyle,
  });

  TableCell build(BuildContext context) {
    final theme = Theme.of(context);

    return TableCell(
      child: Container(
        padding: padding ?? const EdgeInsets.all(12),
        alignment: alignment ?? Alignment.centerLeft,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.border,
              width: 0.5,
            ),
          ),
        ),
        child: isHeader
            ? DefaultTextStyle(
                style: (textStyle ??
                        const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))
                    .copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
                child: child,
              )
            : DefaultTextStyle(
                style: (textStyle ?? const TextStyle(fontSize: 14)).copyWith(
                  color: theme.colorScheme.foreground,
                ),
                child: child,
              ),
      ),
    );
  }
}

// Helper class untuk membuat action buttons dalam table
class AllnimallTableActions extends StatelessWidget {
  final List<Widget> actions;
  final EdgeInsets? padding;

  const AllnimallTableActions({
    super.key,
    required this.actions,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions
            .map((action) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: action,
                ))
            .toList(),
      ),
    );
  }
}
