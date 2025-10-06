class Pageable<T> {
  final List<T> items;
  final String? nextCursor;
  final int? total;

  const Pageable({required this.items, this.nextCursor, this.total});

  factory Pageable.from(List<T> items) {
    return Pageable<T>(items: items);
  }

  Pageable<T> copyWithNextCursor(String? nextCursor) {
    return Pageable<T>(items: items, nextCursor: nextCursor, total: total);
  }
}

extension PageableExtension<T> on Pageable<T> {
  Pageable<S> convert<S>(S Function(T) convert) {
    return Pageable(
      items: items.map(convert).toList(),
      nextCursor: nextCursor,
      total: total,
    );
  }
}
