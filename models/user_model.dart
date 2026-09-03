class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? gender; // "L" / "P" or "Laki-laki" / "Perempuan"
  final String? profilePhoto;
  final dynamic batchId;
  final dynamic trainingId;
  final String? batchTitle;
  final String? trainingTitle;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.profilePhoto,
    this.batchId,
    this.trainingId,
    this.batchTitle,
    this.trainingTitle,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to parse JSON from API response.
  /// Handles varied response envelopes (e.g., nested `data` or direct user object).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // If the object is wrapped inside a 'data' or 'user' key, extract the inner object
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
      if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
        data = data['user'] as Map<String, dynamic>;
      }
    } else if (json.containsKey('user') && json['user'] is Map<String, dynamic>) {
      data = json['user'] as Map<String, dynamic>;
    }

    int? parseId(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is String) return int.tryParse(val);
      return null;
    }

    // Extract Batch info
    dynamic bId = data['batch_id'] ?? data['batchId'];
    String? bTitle = data['batch_ke']?.toString();
    if (data['batch'] != null && data['batch'] is Map<String, dynamic>) {
      final batchMap = data['batch'] as Map<String, dynamic>;
      bId ??= batchMap['id'];
      if (batchMap['batch_ke'] != null) {
        bTitle = 'Batch ${batchMap['batch_ke']}';
      }
    }

    // Extract Training info
    dynamic tId = data['training_id'] ?? data['trainingId'];
    String? tTitle = data['training_title']?.toString();
    if (data['training'] != null && data['training'] is Map<String, dynamic>) {
      final trainingMap = data['training'] as Map<String, dynamic>;
      tId ??= trainingMap['id'];
      if (trainingMap['title'] != null) {
        tTitle = trainingMap['title'].toString();
      }
    }

    return UserModel(
      id: parseId(data['id']),
      name: data['name']?.toString(),
      email: data['email']?.toString(),
      gender: data['jenis_kelamin']?.toString() ?? data['gender']?.toString(),
      profilePhoto: data['profile_photo']?.toString() ??
          data['profilePhoto']?.toString() ??
          data['profile_photo_url']?.toString(),
      batchId: bId,
      trainingId: tId,
      batchTitle: bTitle,
      trainingTitle: tTitle,
      emailVerifiedAt: data['email_verified_at']?.toString(),
      createdAt: data['created_at']?.toString(),
      updatedAt: data['updated_at']?.toString(),
    );
  }

  /// Convert model to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'jenis_kelamin': gender,
      'profile_photo': profilePhoto,
      'batch_id': batchId,
      'training_id': trainingId,
      'batch_title': batchTitle,
      'training_title': trainingTitle,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Helper to display friendly gender description in Indonesian
  String get genderDisplay {
    if (gender == null || gender!.isEmpty) return '-';
    final g = gender!.toUpperCase();
    if (g == 'L' || g == 'LAKI-LAKI' || g == 'MALE') return 'Laki-laki';
    if (g == 'P' || g == 'PEREMPUAN' || g == 'FEMALE') return 'Perempuan';
    return gender!;
  }

  /// Helper to get formatted Batch display
  String get batchDisplay {
    if (batchTitle != null && batchTitle!.isNotEmpty) {
      return batchTitle!;
    }
    if (batchId != null) {
      return 'Batch $batchId';
    }
    return '-';
  }

  /// Helper to get formatted Training display
  String get trainingDisplay {
    if (trainingTitle != null && trainingTitle!.isNotEmpty) {
      return trainingTitle!;
    }
    if (trainingId != null) {
      return 'Training $trainingId';
    }
    return '-';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? gender,
    String? profilePhoto,
    dynamic batchId,
    dynamic trainingId,
    String? batchTitle,
    String? trainingTitle,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      batchId: batchId ?? this.batchId,
      trainingId: trainingId ?? this.trainingId,
      batchTitle: batchTitle ?? this.batchTitle,
      trainingTitle: trainingTitle ?? this.trainingTitle,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, gender: $gender, photo: $profilePhoto, batch: $batchDisplay, training: $trainingDisplay)';
  }
}
