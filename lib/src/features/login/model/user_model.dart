class UserModel {
  final String id;
  final String name;
  final String email;
  final String designation;
  final String baseLocation;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.designation,
    required this.baseLocation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      designation: json['designation'],
      baseLocation: json['base_location'],
    );
  }
}
