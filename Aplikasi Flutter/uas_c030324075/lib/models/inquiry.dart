import 'category.dart';
import 'user.dart';

class Inquiry {
  final int id;
  final int userId;
  final int categoryId;
  final String nama;
  final String email;
  final String website;
  final String telp;
  final String pesan;
  final String status;
  final Category category;
  final User? user;
  final List<Reply>? replies;

  Inquiry({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.nama,
    required this.email,
    required this.website,
    required this.telp,
    required this.pesan,
    required this.status,
    required this.category,
    this.user,
    this.replies,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      nama: json['nama'],
      email: json['email'],
      website: json['website'],
      telp: json['telp'],
      pesan: json['pesan'],
      status: json['status'],
      category: Category.fromJson(json['category']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      replies: json['replies'] != null
          ? (json['replies'] as List).map((r) => Reply.fromJson(r)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'nama': nama,
      'email': email,
      'website': website,
      'telp': telp,
      'pesan': pesan,
      'status': status,
      'category': category.toJson(),
    };
  }
}

class Reply {
  final int id;
  final int inquiryId;
  final int userId;
  final String message;
  final String createdAt;
  final User user;

  Reply({
    required this.id,
    required this.inquiryId,
    required this.userId,
    required this.message,
    required this.createdAt,
    required this.user,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      inquiryId: json['inquiry_id'],
      userId: json['user_id'],
      message: json['message'],
      createdAt: json['created_at'] ?? '',
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inquiry_id': inquiryId,
      'user_id': userId,
      'message': message,
      'created_at': createdAt,
      'user': user.toJson(),
    };
  }
}
