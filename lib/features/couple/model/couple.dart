import 'package:cloud_firestore/cloud_firestore.dart';

class Couple {
  final String id;
  final String code;
  final String user1Id;
  final String? user2Id;
  final DateTime createdAt;
  final DateTime? firstMetDate;

  Couple({
    required this.id,
    required this.code,
    required this.user1Id,
    this.user2Id,
    required this.createdAt,
    this.firstMetDate
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'createdAt': createdAt,
      'firstMetDate' : firstMetDate ?? '',
    };
  }

  factory Couple.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Couple(
      id: doc.id,
      code: data['code'] ?? '',
      user1Id: data['user1Id'] ?? '',
      user2Id: data['user2Id'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      firstMetDate: (data['firstMetDate'] as Timestamp).toDate(),
    );
  }

  bool get isConnected => user2Id != null;

  @override
  String toString() {
    return 'Couple{id: $id, code: $code, user1Id: $user1Id, user2Id: $user2Id, createdAt: $createdAt, firstMetDate: $firstMetDate}';
  }
}
