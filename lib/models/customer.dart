class Customer {
  String? id;
  String? email;
  String? name;
  String? username;
  String? profileUrl;

  Customer({
    this.id,
    this.email,
    this.name,
    this.username,
    this.profileUrl,
  });

  static Customer fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      profileUrl: json['profile_url']
    );
  }
}