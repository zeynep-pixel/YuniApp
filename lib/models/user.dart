class UserModel {
  final String id;
  final String name;
  final String profileImage;

  UserModel({required this.id, required this.name, required this.profileImage});

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] ?? 'Bilinmeyen',
      profileImage: data['profileImage'] ?? '',
    );
  }
}
