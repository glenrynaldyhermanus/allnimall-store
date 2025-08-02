class AppUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? pictureUrl;
  final String? roleId;
  final String? storeId;
  final bool isActive;
  final String? staffType;
  final DateTime? hireDate;
  final double? salary;
  final String? emergencyContact;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.pictureUrl,
    this.roleId,
    this.storeId,
    this.isActive = true,
    this.staffType,
    this.hireDate,
    this.salary,
    this.emergencyContact,
    required this.createdAt,
    this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      pictureUrl: json['picture_url'],
      roleId: json['role_id'],
      storeId: json['store_id'],
      isActive: json['is_active'] ?? true,
      staffType: json['staff_type'],
      hireDate: json['hire_date'] != null 
          ? DateTime.parse(json['hire_date']) 
          : null,
      salary: json['salary']?.toDouble(),
      emergencyContact: json['emergency_contact'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'picture_url': pictureUrl,
      'role_id': roleId,
      'store_id': storeId,
      'is_active': isActive,
      'staff_type': staffType,
      'hire_date': hireDate?.toIso8601String(),
      'salary': salary,
      'emergency_contact': emergencyContact,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 