class Contact {
  final int? id;
  final String name;
  final String phone;
  final String? email;
  final String? organization;
  bool isFavorite;

  Contact(
      {this.id,
      required this.name,
      required this.phone,
      this.email,
      this.organization,
      required this.isFavorite});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'organization': organization,
      'isFavorite': isFavorite,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      organization: map['organization'],
      isFavorite: map['isFavorite'],
    );
  }

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? organization,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      organization: organization ?? this.organization,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
