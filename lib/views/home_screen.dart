import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list.dart';
import '../services/hive_service.dart';
import '../widgets/shopping_list_card.dart';
import 'shopping_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HiveService hiveService;

  @override
  void initState() {
    super.initState();
    hiveService = HiveService(Hive.box<ShoppingList>('shopping_lists'));
  }

  @override
  void dispose() {
    hiveService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Minhas Listas'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder<double>(
                valueListenable: hiveService.totalSpentNotifier,
                builder: (context, total, _) => Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Total Gasto: R\$${total.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<ShoppingList>(
                  'shopping_lists',
                ).listenable(),
                builder: (context, Box<ShoppingList> box, _) {
                  final lists = box.values.toList();
                  if (lists.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma lista criada ainda.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: lists.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => ShoppingListCard(
                      list: lists[index],
                      onDelete: () => hiveService.deleteList(lists[index].id),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ShoppingListScreen(list: lists[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Criar nova lista',
        child: FloatingActionButton(
          backgroundColor: theme.primaryColor,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ShoppingListScreen()),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
