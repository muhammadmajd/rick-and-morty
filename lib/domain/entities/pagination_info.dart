
class PaginationInfo {
  final int count;
  final int pages;
  final int? next;
  final int? prev;

  PaginationInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });
}