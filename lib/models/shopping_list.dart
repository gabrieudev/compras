import 'package:hive/hive.dart';

part 'shopping_list.g.dart';

@HiveType(typeId: 0)
class ShoppingList extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime purchaseDate;

  @HiveField(3)
  String status;

  @HiveField(4)
  double totalAmount;

  ShoppingList({
    required this.id,
    required this.title,
    required this.purchaseDate,
    this.status = 'A Comprar',
    this.totalAmount = 0.0,
  });
}
