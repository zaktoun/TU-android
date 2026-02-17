class Staff {
  final int? id;
  final String nik;
  final String name;
  final String position;
  final String? placeOfBirth;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? address;
  final String? phone;
  final String? email;
  final String? employmentStatus;
  final String? photo;
  final DateTime? hireDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Staff({
    this.id,
    required this.nik,
    required this.name,
    required this.position,
    this.placeOfBirth,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.address,
    this.phone,
    this.email,
    this.employmentStatus = 'active',
    this.photo,
    this.hireDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      nik: json['nik'],
      name: json['name'],
      position: json['position'],
      placeOfBirth: json['place_of_birth'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      gender: json['gender'],
      religion: json['religion'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      employmentStatus: json['employment_status'],
      photo: json['photo'],
      hireDate: json['hire_date'] != null ? DateTime.parse(json['hire_date']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'name': name,
      'position': position,
      'place_of_birth': placeOfBirth,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'religion': religion,
      'address': address,
      'phone': phone,
      'email': email,
      'employment_status': employmentStatus,
      'photo': photo,
      'hire_date': hireDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Staff copyWith({
    int? id,
    String? nik,
    String? name,
    String? position,
    String? placeOfBirth,
    DateTime? dateOfBirth,
    String? gender,
    String? religion,
    String? address,
    String? phone,
    String? email,
    String? employmentStatus,
    String? photo,
    DateTime? hireDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Staff(
      id: id ?? this.id,
      nik: nik ?? this.nik,
      name: name ?? this.name,
      position: position ?? this.position,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      photo: photo ?? this.photo,
      hireDate: hireDate ?? this.hireDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => name;
  String get displayGender => gender == 'L' ? 'Laki-laki' : 'Perempuan';
  String get displayStatus {
    switch (employmentStatus) {
      case 'active':
        return 'Aktif';
      case 'inactive':
        return 'Tidak Aktif';
      default:
        return 'Tidak Diketahui';
    }
  }

  @override
  String toString() {
    return 'Staff{id: $id, nik: $nik, name: $name, position: $position}';
  }
}