class Note {
  final int? id;
  final String title;
  final String description;
  final String date; // To match your UI showing "2021-04-22"

  Note({this.id, required this.title, required this.description, required this.date});

  // Convert a Note into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }

  // Convert a Map into a Note.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
    );
  }
}