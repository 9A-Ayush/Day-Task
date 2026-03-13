class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['user_metadata']?['full_name'],
      avatarUrl: json['user_metadata']?['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }

  String get displayName => fullName ?? email.split('@')[0];
  
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final names = fullName!.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
