// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CoupleLink {
//   final String id;
//   final String creatorId;
//   final DateTime createdAt;
//   final bool isActive;
//   final String? partnerId;
//
//   CoupleLink({
//     required this.id,
//     required this.creatorId,
//     required this.createdAt,
//     this.isActive = true,
//     this.partnerId,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'creatorId': creatorId,
//       'createdAt': createdAt,
//       'isActive': isActive,
//       'partnerId': partnerId,
//     };
//   }
//
//   factory CoupleLink.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return CoupleLink(
//       id: doc.id,
//       creatorId: data['creatorId'] ?? '',
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       isActive: data['isActive'] ?? true,
//       partnerId: data['partnerId'],
//     );
//   }
// }
