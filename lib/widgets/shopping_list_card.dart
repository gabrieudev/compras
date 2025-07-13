import 'package:flutter/material.dart';
import '../models/shopping_list.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ShoppingListCard({
    super.key,
    required this.list,
    required this.onDelete,
    required this.onTap,
  });

  Color _getStatusColor() {
    return list.status == 'Comprado' ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(list.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data: ${list.purchaseDate.day}/${list.purchaseDate.month}/${list.purchaseDate.year}',
            ),
            Row(
              children: [
                Text('Status: '),
                Text(
                  list.status,
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text('Valor: R\$${list.totalAmount.toStringAsFixed(2)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
