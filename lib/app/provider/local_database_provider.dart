import 'package:eco_coin/app/data/local/local_database.dart';
import 'package:eco_coin/app/data/models/recycling_item.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:flutter/material.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabase _localDatabase;
  LocalDatabaseProvider(this._localDatabase);

  String _message = "";
  String get message => _message;

  bool _status = false;
  bool get status => _status;

  List<RecyclingItem>? _itemsList;
  List<RecyclingItem>? get itemsList => _itemsList;

  RecyclingItem? _item;
  RecyclingItem? get item => _item;

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
      _message = "All of your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your all data";
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
