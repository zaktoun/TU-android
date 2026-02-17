class Inventory {
  final int? id;
  final String itemCode;
  final String name;
  final String category;
  final String? description;
  final int quantity;
  final String unit;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final double? currentValue;
  final String? conditionStatus;
  final String? location;
  final String? responsiblePerson;
  final String? photo;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Inventory({
    this.id,
    required this.itemCode,
    required this.name,
    required this.category,
    this.description,
    this.quantity = 0,
    required this.unit,
    this.purchaseDate,
    this.purchasePrice,
    this.currentValue,
    this.conditionStatus = 'good',
    this.location,
    this.responsiblePerson,
    this.photo,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      itemCode: json['item_code'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      quantity: json['quantity'] ?? 0,
      unit: json['unit'],
      purchaseDate: json['purchase_date'] != null ? DateTime.parse(json['purchase_date']) : null,
      purchasePrice: json['purchase_price']?.toDouble(),
      currentValue: json['current_value']?.toDouble(),
      conditionStatus: json['condition_status'],
      location: json['location'],
      responsiblePerson: json['responsible_person'],
      photo: json['photo'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_code': itemCode,
      'name': name,
      'category': category,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'purchase_date': purchaseDate?.toIso8601String(),
      'purchase_price': purchasePrice,
      'current_value': currentValue,
      'condition_status': conditionStatus,
      'location': location,
      'responsible_person': responsiblePerson,
      'photo': photo,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Inventory copyWith({
    int? id,
    String? itemCode,
    String? name,
    String? category,
    String? description,
    int? quantity,
    String? unit,
    DateTime? purchaseDate,
    double? purchasePrice,
    double? currentValue,
    String? conditionStatus,
    String? location,
    String? responsiblePerson,
    String? photo,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Inventory(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentValue: currentValue ?? this.currentValue,
      conditionStatus: conditionStatus ?? this.conditionStatus,
      location: location ?? this.location,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      photo: photo ?? this.photo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayCondition {
    switch (conditionStatus) {
      case 'good':
        return 'Baik';
      case 'fair':
        return 'Cukup';
      case 'poor':
        return 'Buruk';
      case 'damaged':
        return 'Rusak';
      default:
        return 'Tidak Diketahui';
    }
  }

  String get formattedPurchasePrice {
    if (purchasePrice == null) return 'Rp 0';
    return 'Rp ${purchasePrice!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get formattedCurrentValue {
    if (currentValue == null) return 'Rp 0';
    return 'Rp ${currentValue!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  String toString() {
    return 'Inventory{id: $id, itemCode: $itemCode, name: $name, quantity: $quantity}';
  }
}