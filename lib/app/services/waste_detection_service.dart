import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_coin/app/model/waste_detection_model.dart';

class WasteDetectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _detectionCollection = 'waste_detections';
  final String _userStatsCollection = 'user_waste_stats';

  Future<UserWasteStats> getUserWasteStats(String userId) async {
    try {
      final doc = await _firestore
          .collection(_userStatsCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserWasteStats.fromJson(doc.data()!);
      }

      return UserWasteStats.empty();
    } catch (e) {
      throw Exception('Gagal mengambil statistik sampah: $e');
    }
  }

  Future<List<WasteDetectionModel>> getUserWasteHistory(
    String userId, {
    int? limit,
  }) async {
    try {
      Query query = _firestore
          .collection(_detectionCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('detectedAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => WasteDetectionModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil riwayat deteksi: $e');
    }
  }

  Future<List<WasteDetectionModel>> getUserWasteByCategory(
    String userId,
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_detectionCollection)
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .orderBy('detectedAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => WasteDetectionModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data sampah berdasarkan kategori: $e');
    }
  }

  Future<Map<String, int>> getCategoryCountStats(String userId) async {
    try {
      final stats = await getUserWasteStats(userId);
      return stats.categoryCount;
    } catch (e) {
      try {
        final detections = await getUserWasteHistory(userId);
        final Map<String, int> categoryCount = {
          'organik': 0,
          'anorganik': 0,
          'residu': 0,
          'b3': 0,
          'elektronik': 0,
        };

        for (final detection in detections) {
          categoryCount[detection.category] =
              (categoryCount[detection.category] ?? 0) + 1;
        }

        return categoryCount;
      } catch (fallbackError) {
        throw Exception('Gagal mengambil statistik kategori: $fallbackError');
      }
    }
  }

  Future<List<WasteDetectionModel>> getRecentDetections(
    String userId, {
    int limit = 5,
  }) async {
    try {
      return await getUserWasteHistory(userId, limit: limit);
    } catch (e) {
      throw Exception('Gagal mengambil deteksi terbaru: $e');
    }
  }

  Future<bool> hasWasteData(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_detectionCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Stream<UserWasteStats> getUserWasteStatsStream(String userId) {
    return _firestore
        .collection(_userStatsCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            return UserWasteStats.fromJson(doc.data()!);
          }
          return UserWasteStats.empty();
        });
  }

  Stream<List<WasteDetectionModel>> getUserWasteHistoryStream(
    String userId, {
    int? limit,
  }) {
    Query query = _firestore
        .collection(_detectionCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('detectedAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => WasteDetectionModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }
}
