import 'package:flutter/material.dart';
import 'package:juice_point/utils/constants.dart';

class MenuItemCard extends StatelessWidget {
  final BuildContext context;
  final String itemName;
  final int itemCost; // Changed to int
  final Function() onAdd;

  const MenuItemCard({
    super.key,
    required this.itemName,
    required this.itemCost,
    required this.onAdd,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        child: ListTile(
          title: Text(itemName),
          subtitle: Text("₹${itemCost.toStringAsFixed(2)}"),
          trailing: IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            color: green,
          ),
        ),
      ),
    );
  }
}
