import 'package:eco_coin/app/data/local/local_database.dart';
import 'package:eco_coin/app/data/models/recycling_item.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:flutter/material.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabase _localDatabase;
  LocalDatabaseProvider(this._localDatabase) {
    // _initializeData();
  }

  // Future<void> _initializeData() async {
  //   await loadAllWasteRecycling();
  // }

  String _message = "";
  String get message => _message;

  bool _status = false;
  bool get status => _status;

  List<RecyclingItem>? _itemsList;
  List<RecyclingItem>? get itemsList => _itemsList;

  RecyclingItem? _item;
  RecyclingItem? get item => _item;

  int get totalPoints {
    if (_itemsList == null || _itemsList!.isEmpty) return 0;
    return _itemsList!.fold(0, (sum, item) => sum + item.ecoPoints);
  }

  int get totalItems {
    return _itemsList?.length ?? 0;
  }

  final Map<String, int> _categoryStats = {
    'Sampah Anorganik': 0,
    'Sampah B3': 0,
    'Sampah Elektronik': 0,
    'Sampah Organik': 0,
    'Sampah Residu': 0,
  };

  Map<String, int> get categoryStats => _categoryStats;

  Future<void> doWasteRecycling(RecyclingItem value) async {
    try {
      final result = await _localDatabase.insertItem(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
        printX(_message);
        _status = false;
        notifyListeners();
      } else {
        _message = "Your data is saved";
        _status = true;
        printY(_message);

        await loadAllWasteRecycling();
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      printX(_message);
      _status = false;
      notifyListeners();
    }
  }

  Future<void> loadAllWasteRecycling() async {
    try {
      _itemsList = await _localDatabase.getAllItems();
      doTotalCategoryStats();
      _message = "All of your data is loaded";
      printY('$message: $_itemsList');
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your all data";
      printX(_message);
      notifyListeners();
    }
  }

  Future<void> loadWasteRecyclingById(int id) async {
    try {
      _item = await _localDatabase.getItemById(id);
      _message = "Your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your data";
      notifyListeners();
    }
  }

  void doTotalCategoryStats() {
    if (_itemsList == null) {
      printInfo('Data not loaded yet.');
      return;
    }

    _categoryStats.updateAll((key, value) => 0);

    for (final item in _itemsList!) {
      final normalizedCategory = _normalizeCategoryName(item.categoryName);

      printInfo(
        'Processing item: ${item.categoryName} -> normalized: $normalizedCategory',
      );

      if (_categoryStats.containsKey(normalizedCategory)) {
        _categoryStats[normalizedCategory] =
            (_categoryStats[normalizedCategory] ?? 0) + 1;
        printInfo(
          'Updated $normalizedCategory to ${_categoryStats[normalizedCategory]}',
        );
      } else {
        printX('Category not found in stats: $normalizedCategory');
        printInfo('Available categories: ${_categoryStats.keys.toList()}');
      }
    }

    printInfo('Final Category Stats: $_categoryStats');
  }

  String _normalizeCategoryName(String categoryName) {
    final lower = categoryName.toLowerCase().trim();

    // Mapping dari berbagai format ke kategori yang sesuai
    if (lower.contains('elektronik') || lower.contains('electronic')) {
      return 'Sampah Elektronik';
    } else if (lower.contains('organik') || lower.contains('organic')) {
      return 'Sampah Organik';
    } else if (lower.contains('anorganik') ||
        lower.contains('plastik') ||
        lower.contains('plastic') ||
        lower.contains('logam') ||
        lower.contains('metal') ||
        lower.contains('kaca') ||
        lower.contains('glass')) {
      return 'Sampah Anorganik';
    } else if (lower.contains('b3') ||
        lower.contains('berbahaya') ||
        lower.contains('hazard')) {
      return 'Sampah B3';
    } else if (lower.contains('residu') ||
        lower.contains('residue') ||
        lower.contains('kertas') ||
        lower.contains('paper')) {
      return 'Sampah Residu';
    } else {
      if (_categoryStats.containsKey(categoryName)) {
        return categoryName;
      }

      printX('Unknown category: $categoryName, defaulting to Sampah Anorganik');
      return 'Sampah Anorganik';
    }
  }

  Future<void> removeWasteRecyclingById(int id) async {
    try {
      await _localDatabase.removeItem(id);

      _message = "Your data is removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }

  Future<void> close() async {
    await _localDatabase.close();
  }
}
