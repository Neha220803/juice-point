// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Components/new_order/bill_pop_up.dart';
import 'package:juice_point/Components/new_order/menu_category_tile.dart';
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
                      const Text(
                        "New Order",
                        style: TextStyle(
                          color: black,
                          fontSize: 26,
                          fontFamily: 'Roboto Slab',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.81,
                        ),
                      ),
                      const SizedBox(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          backgroundColor: secondaryColor,
                          foregroundColor: black,
                          fixedSize: const Size(120, 50),
                        ),
                        onPressed: () {
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
                        child: const Text("View Bill"),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Selected Items:"),
                ),
                SelectedItemsList(
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
                        print("List after Deleted: $itemCounts");
                      }
                    });
                  },
                  onItemRemove: (itemName) {
                    setState(() {
                      // Remove item from the selected items list
                      itemCounts.remove(itemName);
                    });
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Menu Items"),
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

class SelectedItemsList extends StatefulWidget {
  final Map<String, int> itemCounts;
  final Function(String) onItemIncrement;
  final Function(String) onItemDecrement;
  final Function(String) onItemRemove;

  const SelectedItemsList({
    super.key,
    required this.itemCounts,
    required this.onItemIncrement,
    required this.onItemDecrement,
    required this.onItemRemove,
  });

  @override
  SelectedItemsListState createState() => SelectedItemsListState();
}

class SelectedItemsListState extends State<SelectedItemsList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: widget.itemCounts.entries
                    .where((entry) => entry.value >= 1)
                    .map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => widget.onItemDecrement(entry.key),
                          icon: const Icon(
                            Icons.delete,
                            color: red,
                          ),
                        ),
                        Text(entry.value.toString()),
                        IconButton(
                          onPressed: () => widget.onItemIncrement(entry.key),
                          icon: const Icon(
                            Icons.add,
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
