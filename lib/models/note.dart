class Note {
  final int? id;
  final String title;
  final String description;
  final String date; // To match your UI showing "2021-04-22"
  final int orderIndex;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.orderIndex,
  });

  // Convert a Note into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'orderIndex': orderIndex,
    };
  }

  // Convert a Map into a Note.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      orderIndex: map['orderIndex'] ?? 0,
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    int? orderIndex,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}