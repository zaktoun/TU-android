class Student {
  final int? id;
  final String nis;
  final String? nisn;
  final String name;
  final String? placeOfBirth;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? address;
  final String? phone;
  final String? email;
  final int? classId;
  final String? parentName;
  final String? parentPhone;
  final String? parentAddress;
  final String? photo;
  final DateTime? registrationDate;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Student({
    this.id,
    required this.nis,
    this.nisn,
    required this.name,
    this.placeOfBirth,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.address,
    this.phone,
    this.email,
    this.classId,
    this.parentName,
    this.parentPhone,
    this.parentAddress,
    this.photo,
    this.registrationDate,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nis: json['nis'],
      nisn: json['nisn'],
      name: json['name'],
      placeOfBirth: json['place_of_birth'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      gender: json['gender'],
      religion: json['religion'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      classId: json['class_id'],
      parentName: json['parent_name'],
      parentPhone: json['parent_phone'],
      parentAddress: json['parent_address'],
      photo: json['photo'],
      registrationDate: json['registration_date'] != null ? DateTime.parse(json['registration_date']) : null,
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nis': nis,
      'nisn': nisn,
      'name': name,
      'place_of_birth': placeOfBirth,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'religion': religion,
      'address': address,
      'phone': phone,
      'email': email,
      'class_id': classId,
      'parent_name': parentName,
      'parent_phone': parentPhone,
      'parent_address': parentAddress,
      'photo': photo,
      'registration_date': registrationDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Student copyWith({
    int? id,
    String? nis,
    String? nisn,
    String? name,
    String? placeOfBirth,
    DateTime? dateOfBirth,
    String? gender,
    String? religion,
    String? address,
    String? phone,
    String? email,
    int? classId,
    String? parentName,
    String? parentPhone,
    String? parentAddress,
    String? photo,
    DateTime? registrationDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      nis: nis ?? this.nis,
      nisn: nisn ?? this.nisn,
      name: name ?? this.name,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      classId: classId ?? this.classId,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      parentAddress: parentAddress ?? this.parentAddress,
      photo: photo ?? this.photo,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => name;
  String get displayGender => gender == 'L' ? 'Laki-laki' : 'Perempuan';
  String get displayStatus {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'inactive':
        return 'Tidak Aktif';
      case 'graduated':
        return 'Lulus';
      default:
        return 'Tidak Diketahui';
    }
  }

  @override
  String toString() {
    return 'Student{id: $id, nis: $nis, name: $name, classId: $classId}';
  }
}