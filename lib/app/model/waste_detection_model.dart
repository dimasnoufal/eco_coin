class WasteDetectionModel {
  final String id;
  final String userId;
  final String category;
  final String localImagePath;
  final int ecoCoinsEarned;
  final DateTime detectedAt;
  final String? description;
  final double? confidence;

  WasteDetectionModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.localImagePath,
    required this.ecoCoinsEarned,
    required this.detectedAt,
    this.description,
    this.confidence,
  });

  factory WasteDetectionModel.fromJson(Map<String, dynamic> json) {
    return WasteDetectionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      category: json['category'] ?? '',
      localImagePath: json['localImagePath'] ?? '',
      ecoCoinsEarned: json['ecoCoinsEarned'] ?? 0,
      detectedAt: DateTime.parse(json['detectedAt']),
      description: json['description'],
      confidence: json['confidence']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'localImagePath': localImagePath,
      'ecoCoinsEarned': ecoCoinsEarned,
      'detectedAt': detectedAt.toIso8601String(),
      'description': description,
      'confidence': confidence,
    };
  }

  WasteDetectionModel copyWith({
    String? id,
    String? userId,
    String? category,
    String? localImagePath,
    int? ecoCoinsEarned,
    DateTime? detectedAt,
    String? description,
    double? confidence,
  }) {
    return WasteDetectionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      localImagePath: localImagePath ?? this.localImagePath,
      ecoCoinsEarned: ecoCoinsEarned ?? this.ecoCoinsEarned,
      detectedAt: detectedAt ?? this.detectedAt,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
    );
  }
}

class UserWasteStats {
  final int totalEcoCoins;
  final int totalRecycledWaste;
  final Map<String, int> categoryCount;
  final Map<String, int> categoryEcoCoins;

  UserWasteStats({
    required this.totalEcoCoins,
    required this.totalRecycledWaste,
    required this.categoryCount,
    required this.categoryEcoCoins,
  });

  factory UserWasteStats.empty() {
    return UserWasteStats(
      totalEcoCoins: 0,
      totalRecycledWaste: 0,
      categoryCount: {
        'organik': 0,
        'anorganik': 0,
        'residu': 0,
        'b3': 0,
        'elektronik': 0,
      },
      categoryEcoCoins: {
        'organik': 0,
        'anorganik': 0,
        'residu': 0,
        'b3': 0,
        'elektronik': 0,
      },
    );
  }

  factory UserWasteStats.fromJson(Map<String, dynamic> json) {
    return UserWasteStats(
      totalEcoCoins: json['totalEcoCoins'] ?? 0,
      totalRecycledWaste: json['totalRecycledWaste'] ?? 0,
      categoryCount: Map<String, int>.from(json['categoryCount'] ?? {}),
      categoryEcoCoins: Map<String, int>.from(json['categoryEcoCoins'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEcoCoins': totalEcoCoins,
      'totalRecycledWaste': totalRecycledWaste,
      'categoryCount': categoryCount,
      'categoryEcoCoins': categoryEcoCoins,
    };
  }
}

class WasteRewards {
  static const Map<String, int> ecoCoinRewards = {
    'organik': 5,
    'anorganik': 15,
    'residu': 30,
    'b3': 40,
    'elektronik': 50,
  };

  static const Map<String, String> categoryDescriptions = {
    'organik': 'Sampah organik dapat didaur ulang menjadi kompos',
    'anorganik': 'Sampah anorganik dapat didaur ulang menjadi produk baru',
    'residu': 'Limbah residu perlu penanganan khusus',
    'b3': 'Bahan Berbahaya dan Beracun memerlukan penanganan khusus',
    'elektronik': 'Limbah elektronik dapat didaur ulang',
  };

  static int getEcoCoinReward(String category) {
    return ecoCoinRewards[category] ?? 0;
  }

  static String getCategoryDescription(String category) {
    return categoryDescriptions[category] ?? 'Kategori tidak dikenal';
  }
}
