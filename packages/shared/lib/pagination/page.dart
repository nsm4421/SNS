typedef Cursor = String;

class Page<T> {
  final List<T> items;
  final Cursor? nextCursor;

  const Page({required this.items, this.nextCursor});

  bool get isEnd => nextCursor == null;
}
