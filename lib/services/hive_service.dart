import 'dart:async';

import 'package:hive/hive.dart';
import '../models/shopping_list.dart';
import 'package:flutter/foundation.dart';

class HiveService {
  final Box<ShoppingList> shoppingListBox;
  final ValueNotifier<double> totalSpentNotifier = ValueNotifier(0.0);
  late StreamSubscription _subscription;

  HiveService(this.shoppingListBox) {
    _updateTotal();
    _subscription = shoppingListBox.watch().listen((_) => _updateTotal());
    // Observa mudanças no box para atualizar o total automaticamente
    shoppingListBox.watch().listen((_) => _updateTotal());
  }

  void _updateTotal() {
    totalSpentNotifier.value = shoppingListBox.values
        .where((list) => list.status == 'Comprado')
        .fold(0.0, (sum, list) => sum + list.totalAmount);
  }

  List<ShoppingList> getLists() => shoppingListBox.values.toList();

  void addList(ShoppingList list) {
    shoppingListBox.put(list.id, list);
  }

  void updateList(ShoppingList list) {
    shoppingListBox.put(list.id, list);
  }

  void deleteList(String id) {
    shoppingListBox.delete(id);
  }

  void dispose() {
    _subscription.cancel();
    totalSpentNotifier.dispose();
  }
}
