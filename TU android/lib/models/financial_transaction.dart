class FinancialTransaction {
  final int? id;
  final String transactionCode;
  final int? studentId;
  final String type;
  final double amount;
  final String? description;
  final String? paymentMethod;
  final DateTime paymentDate;
  final String? status;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FinancialTransaction({
    this.id,
    required this.transactionCode,
    this.studentId,
    required this.type,
    required this.amount,
    this.description,
    this.paymentMethod,
    required this.paymentDate,
    this.status = 'paid',
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) {
    return FinancialTransaction(
      id: json['id'],
      transactionCode: json['transaction_code'],
      studentId: json['student_id'],
      type: json['type'],
      amount: json['amount']?.toDouble() ?? 0.0,
      description: json['description'],
      paymentMethod: json['payment_method'],
      paymentDate: DateTime.parse(json['payment_date']),
      status: json['status'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_code': transactionCode,
      'student_id': studentId,
      'type': type,
      'amount': amount,
      'description': description,
      'payment_method': paymentMethod,
      'payment_date': paymentDate.toIso8601String(),
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  FinancialTransaction copyWith({
    int? id,
    String? transactionCode,
    int? studentId,
    String? type,
    double? amount,
    String? description,
    String? paymentMethod,
    DateTime? paymentDate,
    String? status,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinancialTransaction(
      id: id ?? this.id,
      transactionCode: transactionCode ?? this.transactionCode,
      studentId: studentId ?? this.studentId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayType {
    switch (type) {
      case 'spp':
        return 'SPP';
      case 'iuran':
        return 'Iuran';
      case 'zakat':
        return 'Zakat';
      case 'infak':
        return 'Infak';
      case 'sedekah':
        return 'Sedekah';
      case 'tabungan':
        return 'Tabungan';
      case 'lainnya':
        return 'Lainnya';
      default:
        return type;
    }
  }

  String get displayPaymentMethod {
    switch (paymentMethod) {
      case 'cash':
        return 'Tunai';
      case 'transfer':
        return 'Transfer';
      case 'digital':
        return 'Digital';
      default:
        return 'Tunai';
    }
  }

  String get displayStatus {
    switch (status) {
      case 'paid':
        return 'Lunas';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Tidak Diketahui';
    }
  }

  String get formattedAmount {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  String toString() {
    return 'FinancialTransaction{id: $id, transactionCode: $transactionCode, type: $type, amount: $amount}';
  }
}