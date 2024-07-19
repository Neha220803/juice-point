import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Components/new_order/menu_item_card.dart';

class MenuCategoryExpansionTile extends StatelessWidget {
  final BuildContext context;
  final String category;
  final List<DocumentSnapshot> categoryItems;
  final Function(String) onItemAdd;

  const MenuCategoryExpansionTile({
    super.key,
    required this.category,
    required this.categoryItems,
    required this.onItemAdd,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ExpansionTile(
        title: Text(category),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              var data = categoryItems[index].data() as Map<String, dynamic>;
              var itemName = data['name'].toString();
              var itemCost = data['cost'] as int;
              return MenuItemCard(
                context: context,
                itemName: itemName,
                itemCost: itemCost,
                onAdd: () => onItemAdd(itemName),
              );
            },
          ),
        ],
      ),
    );
  }
}
