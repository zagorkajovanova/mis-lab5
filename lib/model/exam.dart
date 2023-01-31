import 'location.dart';

class Exam {
  final String id;
  final String name;
  final DateTime date;
  final Location location;

  Exam({
    required this.id,
    required this.name,
    required this.date,
    required this.location
  });
}
