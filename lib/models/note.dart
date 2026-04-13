class Note {
  final int? id;
  final String title;
  final String description;
  final String date;
  final int orderIndex;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'orderIndex': orderIndex,
    };
  }

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