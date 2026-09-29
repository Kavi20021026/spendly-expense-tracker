import 'package:cloud_firestore/cloud_firestore.dart';

/// AppUser represents an authenticated user in Spendly.
class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  /// Factory constructor for building [AppUser] from Firestore document data
  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    DateTime parseDate(dynamic field) {
      if (field is Timestamp) {
        return field.toDate();
      } else if (field is String) {
        return DateTime.tryParse(field) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return AppUser(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'User',
      createdAt: parseDate(data['createdAt']),
    );
  }

  /// Converts [AppUser] instance to a Map for Firestore persistence
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
