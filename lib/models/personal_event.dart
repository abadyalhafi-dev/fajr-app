import 'dart:convert';

/// A personal reminder/event the user adds to the calendar.
class PersonalEvent {
  final String id;
  final DateTime date;
  final String title;
  final String? note;

  PersonalEvent({
    required this.id,
    required this.date,
    required this.title,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        // store date as yyyy-MM-dd (no time component needed)
        'date': '${date.year}-${date.month}-${date.day}',
        'title': title,
        'note': note,
      };

  factory PersonalEvent.fromMap(Map<String, dynamic> map) {
    final parts = (map['date'] as String).split('-');
    return PersonalEvent(
      id: map['id'] as String,
      date: DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
      title: map['title'] as String,
      note: map['note'] as String?,
    );
  }

  static String encodeList(List<PersonalEvent> events) =>
      jsonEncode(events.map((e) => e.toMap()).toList());

  static List<PersonalEvent> decodeList(String source) {
    final list = jsonDecode(source) as List<dynamic>;
    return list
        .map((e) => PersonalEvent.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
