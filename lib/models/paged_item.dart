import 'package:linkify/main.export.dart';

class PagedItem<T> {
  PagedItem({
    required this.page,
    required this.parPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  final int page;
  final int parPage;
  final int total;
  final int totalPages;
  final List<T> data;

  factory PagedItem.fromMap(Map<String, dynamic> map, FromMapT<T> mapper) {
    return PagedItem<T>(
      page: map.parseInt('page', 1),
      parPage: map.parseInt('per_page', 10),
      total: map.parseInt('total'),
      totalPages: map.parseInt('total_pages'),
      data: switch (map['data']) {
        final List data => List<T>.from(data.map((m) => mapper(m))),
        _ => <T>[],
      },
    );
  }

  PagedItem<T> joinWithNew(PagedItem<T> newData) {
    final list = data.toList();
    list.addAll(newData.data);
    return PagedItem<T>(
      page: newData.page,
      parPage: newData.parPage,
      total: newData.total,
      totalPages: newData.totalPages,
      data: list,
    );
  }

  static PagedItem<T> empty<T>() => PagedItem<T>(page: 0, parPage: 0, total: 0, totalPages: 0, data: []);

  PagedItem<T> copyWith({int? page, int? parPage, int? total, int? totalPages, List<T>? data}) {
    return PagedItem<T>(
      page: page ?? this.page,
      parPage: parPage ?? this.parPage,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      data: data ?? this.data,
    );
  }
}
