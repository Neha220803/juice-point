// ignore_for_file: prefer_const_constructors, prefer_for_elements_to_map_fromiterable, prefer_const_literals_to_create_immutables, avoid_print, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key});

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
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          var documents = snapshot.data!.docs;
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
                      Text(
                        "New Order",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontFamily: 'Roboto Slab',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.81,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          backgroundColor: Color(0xffF5DAD2),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(120, 50),
                        ),
                        onPressed: () {
                          if (itemCounts.isEmpty) {
                            // Show a snack bar if no items are selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please selecte atleast one item'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Show the bill pop-up dialog if items are selected
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BillPopUp(itemCounts: itemCounts);
                              },
                            );
                          }
                        },
                        child: Text("View Bill"),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        print("List after Deleted: " + itemCounts.toString());
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
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No data available'));
                      }
                      var documents = snapshot.data!.docs;
                      // Group documents by category
                      var groupedMenu =
                          Map<String, List<DocumentSnapshot>>.fromIterable(
                        documents,
                        key: (doc) =>
                            (doc.data() as Map<String, dynamic>)['category']
                                .toString(),
                        value: (doc) => documents
                            .where((d) =>
                                (d.data() as Map<String, dynamic>)['category']
                                    .toString() ==
                                (doc.data() as Map<String, dynamic>)['category']
                                    .toString())
                            .toList(),
                      );
                      return ListView.builder(
                        itemCount: groupedMenu.length,
                        itemBuilder: (context, index) {
                          var category = groupedMenu.keys.toList()[index];
                          var categoryItems = groupedMenu[category]!;
                          return MenuCategoryExpansionTile(
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

class SelectedItemsList extends StatelessWidget {
  final Map<String, int> itemCounts;
  final Function(String) onItemIncrement;
  final Function(String) onItemDecrement;
  final Function(String) onItemRemove;

  const SelectedItemsList({
    Key? key,
    required this.itemCounts,
    required this.onItemIncrement,
    required this.onItemDecrement,
    required this.onItemRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            children: itemCounts.entries
                .where((entry) => entry.value >= 1)
                .map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onItemDecrement(entry.key),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    Text(entry.value.toString()),
                    IconButton(
                      onPressed: () => onItemIncrement(entry.key),
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String itemName;
  final int itemCost; // Changed to int
  final Function() onAdd;

  const MenuItemCard({
    Key? key,
    required this.itemName,
    required this.itemCost,
    required this.onAdd,
  }) : super(key: key);

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
            icon: Icon(Icons.add),
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

class MenuCategoryExpansionTile extends StatelessWidget {
  final String category;
  final List<DocumentSnapshot> categoryItems;
  final Function(String) onItemAdd;

  const MenuCategoryExpansionTile({
    Key? key,
    required this.category,
    required this.categoryItems,
    required this.onItemAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ExpansionTile(
        title: Text(category),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              var data = categoryItems[index].data() as Map<String, dynamic>;
              var itemName = data['name'].toString();
              var itemCost = data['cost'] as int;
              return MenuItemCard(
                itemName: itemName,
                itemCost: itemCost as int,
                onAdd: () => onItemAdd(itemName),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BillPopUp extends StatefulWidget {
  final Map<String, int> itemCounts;
  const BillPopUp({Key? key, required this.itemCounts}) : super(key: key);

  @override
  State<BillPopUp> createState() => _BillPopUpState();
}

class _BillPopUpState extends State<BillPopUp> {
  String? _selectedItem2;
  final CollectionReference _history =
      FirebaseFirestore.instance.collection('history');
  int curNum = 0;
  int totalAmount = 0;
  final CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');
  List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _updateTotalAmount();
  }

  Future<void> incOrderNo() async {
    QuerySnapshot snapshot = await _history.get();
    curNum = snapshot.docs.length;
    curNum++;
    print("Current order number: $curNum");
  }

  Future<int> calculateTotal(Map<String, int> itemCounts) async {
    int totalAmount = 0;
    for (String item in itemCounts.keys) {
      QuerySnapshot querySnapshot =
          await _menu.where('name', isEqualTo: item).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        var cost = data['cost'];
        totalAmount += (cost is int)
            ? cost * itemCounts[item]!
            : (cost as double).toInt() * itemCounts[item]!.toInt();
      }
    }
    print("Total amount calculated: $totalAmount");
    return totalAmount;
  }

  Future<int> _updateTotalAmount() async {
    totalAmount = await calculateTotal(widget.itemCounts);
    if (mounted) {
      setState(() {
        totalAmount = totalAmount;
      });
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Order Details"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Divider(),
            DataTable(
              columns: [
                DataColumn(
                  label: Text("Item"),
                ),
                DataColumn(
                    label: Text(
                  "No.",
                )),
                DataColumn(label: Text("Cost")),
              ],
              rows: widget.itemCounts.entries.map((entry) {
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                        // width: 80, // Adjust width as needed
                        child: Text(
                          entry.key,
                          textAlign: TextAlign.center,
                          maxLines: null, // Allow multiple lines
                        ),
                      ),
                    ),
                    DataCell(Text(entry.value.toString())),
                    // DataCell(FutureBuilder<int>(
                    //   future: _calculateItemCost(entry.key),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return CircularProgressIndicator();
                    //     } else if (snapshot.hasError) {
                    //       return Text("Error");
                    //     } else {
                    //       return Text(snapshot.data.toString());
                    //     }
                    //   },
                    // )),
                    DataCell(FutureBuilder<int>(
                      future: _calculateItemCost(entry.key),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error");
                        } else {
                          //Text('No*Cost ${snapshot.data.toString()}')
                          return Text(
                              textAlign: TextAlign.center,
                              '₹ ${widget.itemCounts[entry.key]! * snapshot.data!.toInt() ?? 0}\n(${entry.value.toString()}×${snapshot.data.toString()})');
                        }
                      },
                    )),
                  ],
                );
              }).toList(),
            ),
            Divider(),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xff75A47F), width: 2.5),
                // Example border color
              ),
              child: DropdownButton<String>(
                hint: Text('Select a Payment Method'),
                value: _selectedItem2,
                onChanged: (String? newValue) async {
                  print("Selected payment method: $newValue");
                  int neww = await _updateTotalAmount();
                  setState(() {
                    _selectedItem2 = newValue;
                    totalAmount = neww;
                  });
                },
                items: <String>['G-Pay', 'Cash']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),
            Divider(),
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20, // Adjust font size as needed
                fontWeight: FontWeight.bold, // Make it bold
                color: Colors.black, // Set text color
              ),
            ),
            Text(
              "Total Items: ${widget.itemCounts.values.reduce((sum, element) => sum + element)}",
              style: TextStyle(
                fontSize: 16, // Adjust font size as needed
                color: Colors.black87, // Set text color
              ),
            ),
            Text(
              "Total Amount to Pay: $totalAmount",
              style: TextStyle(
                fontSize: 16, // Adjust font size as needed
                color: Colors.black87, // Set text color
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                backgroundColor: Color(0xffF5DAD2),
                foregroundColor: Colors.black,
                fixedSize: const Size(340, 50),
              ),
              onPressed: () async {
                print("Submitting order...");
                // if (_selectedItems.isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text('No items selected'),
                //     ),
                //   );
                // }
                // else {

                print("Submitting order...");
                var now = DateTime.now();
                await incOrderNo();

                // Create a list to store the items and their counts
                List<Map<String, dynamic>> itemsList = [];
                widget.itemCounts.forEach((itemName, itemCount) {
                  itemsList.add({
                    'name': itemName,
                    'count': itemCount,
                  });
                });

                // Add order details to the history collection
                await _history.add({
                  'amount': totalAmount,
                  'mode': _selectedItem2,
                  'order_no': curNum,
                  'time-stamp': now,
                  'items': itemsList, // Add the list of items and their counts
                });

                // Close the dialog
                if (mounted) {
                  Navigator.pop(context);
                }
                print("Order submitted successfully.");
              },
              child: Text('Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _calculateItemCost(String itemName) async {
    QuerySnapshot querySnapshot =
        await _menu.where('name', isEqualTo: itemName).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      var cost = data['cost'];
      return (cost is int) ? cost : (cost as double).toInt();
    }
    return 0;
  }
}
