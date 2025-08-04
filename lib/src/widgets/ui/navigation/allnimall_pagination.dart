import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallPagination extends StatelessWidget {
  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const AllnimallPagination({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Pagination(
      page: page,
      totalPages: totalPages,
      onPageChanged: onPageChanged,
    );
  }
}

// Helper class untuk membuat pagination dengan mudah
class AllnimallPaginationBuilder {
  static AllnimallPagination basic({
    required int page,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
  }) {
    return AllnimallPagination(
      page: page,
      totalPages: totalPages,
      onPageChanged: onPageChanged,
    );
  }
}
