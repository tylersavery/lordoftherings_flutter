class ResponseListModel<T> {
  final int page;
  final int pages;
  final List<T> docs;

  ResponseListModel({
    required this.page,
    required this.pages,
    required this.docs,
  });
}
