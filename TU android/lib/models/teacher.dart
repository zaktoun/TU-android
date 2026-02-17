class Teacher {
  final int? id;
  final String nip;
  final String name;
  final String? placeOfBirth;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? address;
  final String? phone;
  final String? email;
  final String? specialization;
  final String? employmentStatus;
  final String? photo;
  final DateTime? hireDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Teacher({
    this.id,
    required this.nip,
    required this.name,
    this.placeOfBirth,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.address,
    this.phone,
    this.email,
    this.specialization,
    this.employmentStatus = 'active',
    this.photo,
    this.hireDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      nip: json['nip'],
      name: json['name'],
      placeOfBirth: json['place_of_birth'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      gender: json['gender'],
      religion: json['religion'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      specialization: json['specialization'],
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
      'nip': nip,
      'name': name,
      'place_of_birth': placeOfBirth,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'religion': religion,
      'address': address,
      'phone': phone,
      'email': email,
      'specialization': specialization,
      'employment_status': employmentStatus,
      'photo': photo,
      'hire_date': hireDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Teacher copyWith({
    int? id,
    String? nip,
    String? name,
    String? placeOfBirth,
    DateTime? dateOfBirth,
    String? gender,
    String? religion,
    String? address,
    String? phone,
    String? email,
    String? specialization,
    String? employmentStatus,
    String? photo,
    DateTime? hireDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      name: name ?? this.name,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      specialization: specialization ?? this.specialization,
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
    return 'Teacher{id: $id, nip: $nip, name: $name, specialization: $specialization}';
  }
}