import 'package:entity_book/entity_book.dart';

Book dummyBook({required int id}) {
  return Book(
    id: id,
    title: 'The Purpler Bear',
    authors: [Person(name: 'Janie Tesch-Cassady')],
    formats: const Format(
      image:
          'https://www.millcitypress.net/wp-content/uploads/2016/06/childrens-cover.jpg',
    ),
    downloadCount: 10,
  );
}
