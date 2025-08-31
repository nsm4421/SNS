typedef Cursor = String;

class Page<T> {
  final List<T> items;
  final Cursor? nextCursor;

  const Page({required this.items, this.nextCursor});

  bool get isEnd => nextCursor == null;
}

extension PageExtension<T> on Page<T> {
  Page<S> convert<S>(S Function(T) cb) {
    return Page<S>(items: items.map(cb).toList(), nextCursor: nextCursor);
  }
}
