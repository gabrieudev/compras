import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/shopping_list.dart';
import '../services/hive_service.dart';
import 'package:hive/hive.dart';

class ShoppingListScreen extends StatefulWidget {
  final ShoppingList? list;

  const ShoppingListScreen({this.list, super.key});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late DateTime _purchaseDate;
  late String _status;
  late double _totalAmount;

  final List<String> _statusOptions = ['A Comprar', 'Comprado'];

  @override
  void initState() {
    super.initState();
    _title = widget.list?.title ?? '';
    _purchaseDate = widget.list?.purchaseDate ?? DateTime.now();
    _status = widget.list?.status ?? 'A Comprar';
    _totalAmount = widget.list?.totalAmount ?? 0.0;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final list = ShoppingList(
        id: widget.list?.id ?? DateTime.now().toString(),
        title: _title,
        purchaseDate: _purchaseDate,
        status: _status,
        totalAmount: _totalAmount,
      );

      final hiveService = HiveService(Hive.box<ShoppingList>('shopping_lists'));
      if (widget.list != null) {
        hiveService.updateList(list);
      } else {
        hiveService.addList(list);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list == null ? 'Nova Lista' : 'Editar Lista'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: const InputDecoration(
                        labelText: 'Título*',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                      onSaved: (value) => _title = value!,
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      title: const Text('Data da Compra'),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_purchaseDate),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      leading: const Icon(
                        Icons.calendar_month,
                        color: Colors.blue,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _purchaseDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) setState(() => _purchaseDate = date);
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _status = value.toString()),
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        prefixIcon: Icon(Icons.check_circle_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: _totalAmount.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Valor Total (R\$)*',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Campo obrigatório';
                        if (double.tryParse(value) == null)
                          return 'Valor inválido';
                        return null;
                      },
                      onSaved: (value) => _totalAmount = double.parse(value!),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Salvar Lista',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
