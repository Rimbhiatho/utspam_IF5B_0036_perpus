class RiwayatModel {
  final int? id;
  final int userId;
  final int bookId;
  final String action;
  final int timestamp;
  final String? note;

  RiwayatModel({
    this.id,
    required this.userId,
    required this.bookId,
    required this.action,
    int? timestamp,
    this.note,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'action': action,
      'timestamp': timestamp,
      'note': note,
    };
  }

  factory RiwayatModel.fromMap(Map<String, dynamic> map) {
    return RiwayatModel(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      bookId: map['bookId'] as int,
      action: map['action'] as String,
      timestamp: map['timestamp'] as int?,
      note: map['note'] as String?,
    );
  }
}
