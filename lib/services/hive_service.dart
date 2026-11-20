import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell_model.dart';

class HiveService {
  static const String boxName = 'favorite_spells_box';

  static Box get box => Hive.box(boxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static bool isFavorite(int index) {
    return box.containsKey(index);
  }

  static Future<void> addFavorite(Spell spell) async {
    await box.put(spell.index, spell.toJson());
  }

  static Future<void> removeFavorite(int index) async {
    await box.delete(index);
  }

  static List<Spell> getFavorites() {
    final List<Spell> spells = [];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        if (data is Map) {
          spells.add(Spell.fromJson(Map<String, dynamic>.from(data)));
        }
      }
    }
    return spells;
  }

  static ValueListenable<Box> listenable() {
    return box.listenable();
  }
}
