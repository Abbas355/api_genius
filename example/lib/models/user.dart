class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? addressLine1;
  final String? city;
  final String? zip;
  final String? state;
  final String? token; // For login response

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.addressLine1,
    this.city,
    this.zip,
    this.state,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      addressLine1: json['address_line_1'],
      city: json['city'],
      zip: json['zip'],
      state: json['state'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (addressLine1 != null) data['address_line_1'] = addressLine1;
    if (city != null) data['city'] = city;
    if (zip != null) data['zip'] = zip;
    if (state != null) data['state'] = state;
    if (token != null) data['token'] = token;
    return data;
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, token: ${token != null ? "******" : null})';
  }
}