// Constant
const resultsKey = 'results';
const countKey = 'count';
const nextKey = 'next';
const previousKey = 'previous';

class GoatResponseArrayModel<T> {
  late int count;
  late String? next;
  late String? previous;
  late List<T> results;

  GoatResponseArrayModel({
    this.count = 0,
    this.next,
    this.previous,
    this.results = const [],
  });

  GoatResponseArrayModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) payloadTransformer,
  ) {
    final payload = json[resultsKey] is List ? json[resultsKey] : null;
    results = <T>[];
    if (payload != null) {
      for (var element in payload) {
        if (element is T) {
          results.add(element);
        } else {
          results.add(payloadTransformer(element));
        }
      }
    }
    count = (json[countKey] as int?) ?? 0;
    next = json[nextKey] as String?;
    previous = json[previousKey] as String?;
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T) payloadTransformer, {
    String? payloadName,
  }) {
    final data = <String, dynamic>{};

    if (results.isNotEmpty) {
      data[resultsKey] = results.map(payloadTransformer).toList();
    }
    data[countKey] = count;
    data[nextKey] = next;
    data[previousKey] = previous;

    return data;
  }

  GoatResponseArrayModel<T> appendResult(GoatResponseArrayModel<T> newResults) {
    return GoatResponseArrayModel(
      count: newResults.count,
      next: newResults.next,
      previous: newResults.previous,
      results: results..addAll(newResults.results),
    );
  }
}
