import 'package:cloud_firestore/cloud_firestore.dart';

class Couple {
  final String id;
  final String code;
  final String user1Id;
  final String? user2Id;
  final DateTime createdAt;

  Couple({
    required this.id,
    required this.code,
    required this.user1Id,
    this.user2Id,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'createdAt': createdAt,
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
    );
  }

  bool get isConnected => user2Id != null;
}
