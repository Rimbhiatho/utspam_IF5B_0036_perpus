class PeminjamanModel {
  final int? id;
  final int userId;
  final int bookId;
  final int borrowDate;
  final int dueDate;
  final int? returnDate;
  final String status;
  final int biaya;

  PeminjamanModel({
    this.id,
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.status = 'borrowed',
    this.biaya = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'returnDate': returnDate,
      'status': status,
      'biaya': biaya,
    };
  }

  factory PeminjamanModel.fromMap(Map<String, dynamic> map) {
    return PeminjamanModel(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      bookId: map['bookId'] as int,
      borrowDate: map['borrowDate'] as int,
      dueDate: map['dueDate'] as int,
      returnDate: map['returnDate'] as int?,
      status: map['status'] as String? ?? 'borrowed',
      biaya: map['biaya'] as int? ?? 0,
    );
  }
}
