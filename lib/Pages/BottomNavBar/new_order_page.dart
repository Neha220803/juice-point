// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Widgets/custom_text.dart';
import 'package:juice_point/Components/new_order_page_components/bill_pop_up.dart';
import 'package:juice_point/Components/new_order_page_components/menu_category_tile.dart';
import 'package:juice_point/Components/new_order_page_components/select_items_list.dart';
import 'package:juice_point/Widgets/custome_button.dart';
import 'package:juice_point/utils/constants.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');
  Map<String, int> itemCounts = {}; // Map to store item counts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _menu.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          //var documents = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        value: "New Order",
                        size: 26,
                        fontFamily: 'Roboto Slab',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.81,
                      ),
                      const SizedBox(),
                      CustomButton(
                        text: "View Bill",
                        color: secondaryColor,
           
                        fixedSize: const Size(120, 50),
                        callback: () {
                          if (itemCounts.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please selecte atleast one item'),
                                backgroundColor: red,
                              ),
                            );
                          } else {
                            // Show the bill pop-up dialog if items are selected
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BillPopUp(
                                    itemCounts: itemCounts, context: context);
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: CustomText(value: "Selected Items:"),
                ),
                SelectedItemsList(
                  context: context,
                  itemCounts: itemCounts,
                  onItemIncrement: (itemName) {
                    setState(() {
                      // Increment item count
                      itemCounts[itemName] = (itemCounts[itemName] ?? 0) + 1;
                    });
                  },
                  onItemDecrement: (itemName) {
                    setState(() {
                      // Decrement item count
                      itemCounts[itemName] = (itemCounts[itemName] ?? 0) - 1;
                      // Delete the item if count becomes zero
                      if (itemCounts[itemName] == 0) {
                        itemCounts.remove(itemName);
                        // print("List after Deleted: $itemCounts");
                      }
                    });
                  },
                  onItemRemove: (itemName) {
                    setState(() {
                      itemCounts.remove(itemName);
                    });
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: CustomText(value: "Menu Items"),
                ),
                Expanded(
                  flex: 3,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _menu.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }
                      var documents = snapshot.data!.docs;
                      // Group documents by category
                      var groupedMenu = {
                        for (var doc in documents)
                          (doc.data() as Map<String, dynamic>)['category']
                                  .toString():
                              documents
                                  .where((d) =>
                                      (d.data() as Map<String, dynamic>)[
                                              'category']
                                          .toString() ==
                                      (doc.data() as Map<String, dynamic>)[
                                              'category']
                                          .toString())
                                  .toList()
                      };
                      return ListView.builder(
                        itemCount: groupedMenu.length,
                        itemBuilder: (context, index) {
                          var category = groupedMenu.keys.toList()[index];
                          var categoryItems = groupedMenu[category]!;
                          return MenuCategoryExpansionTile(
                            context: context,
                            category: category,
                            categoryItems: categoryItems,
                            onItemAdd: (itemName) {
                              setState(() {
                                // Add item to the selected items list
                                itemCounts[itemName] =
                                    (itemCounts[itemName] ?? 0) + 1;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
