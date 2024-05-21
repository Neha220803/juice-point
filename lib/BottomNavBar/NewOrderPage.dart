// ignore_for_file: prefer_const_constructors, prefer_for_elements_to_map_fromiterable, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                                      Text('Please electe atleast one item'),
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
                          child: Text("View Bill"))
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Selected Items:"),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView(
                        children: itemCounts.entries
                            .where((entry) =>
                                entry.value >=
                                1) // Filter out entries with count less than 1
                            .map((entry) {
                          return ListTile(
                            title: Text(entry.key),
                            trailing: Text(entry.value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
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
                                    var data = categoryItems[index].data()
                                        as Map<String, dynamic>;
                                    var itemName = data['name'].toString();
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(itemName),
                                                subtitle: Text("₹" +
                                                    data['cost'].toString()),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // Decrement item count
                                                      if (itemCounts
                                                          .containsKey(
                                                              itemName)) {
                                                        itemCounts[itemName] =
                                                            (itemCounts[itemName] ??
                                                                    0) -
                                                                1;
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  (itemCounts[itemName] ?? 0)
                                                      .toString(),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // Increment item count
                                                      itemCounts[itemName] =
                                                          (itemCounts[itemName] ??
                                                                  0) +
                                                              1;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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

class BillPopUp extends StatefulWidget {
  final Map<String, int> itemCounts;
  const BillPopUp({Key? key, required this.itemCounts}) : super(key: key);

  @override
  State<BillPopUp> createState() => _BillPopUpState();
}

class _BillPopUpState extends State<BillPopUp> {
  //  final Map<String, int> itemCounts;
  String? _selectedItem2;
  final CollectionReference _history =
      FirebaseFirestore.instance.collection('history');
  int curNum = 0;
  int totalAmount = 0;
  int total = 0;
  final CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');
  List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _updateTotalAmount();
    _fetchMenuItems();
  }

  void _incrementTotalAmount(int amount) {
    totalAmount += amount;
  }

  Future<void> incOrderNo() async {
    QuerySnapshot snapshot = await _history.get();
    curNum = snapshot.docs.length;
    curNum++;
    print("Current order number: $curNum");
  }

  Future<List<Map<String, dynamic>>> _fetchMenuItems() async {
    QuerySnapshot snapshot = await _menu.get();
    print("Menu items fetched: ${snapshot.docs.length}");
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<int> calculateTotal(List<String> selectedItems) async {
    int totalAmount = 0;
    print(selectedItems);
    for (String selectedItem in selectedItems) {
      print("Fetching cost for item: $selectedItem");
      // Query Firestore to get the price of the selected item
      QuerySnapshot querySnapshot =
          await _menu.where('name', isEqualTo: selectedItem).limit(1).get();
      print(
          "Query snapshot for $selectedItem: ${querySnapshot.docs.length} documents found");
      if (querySnapshot.docs.isNotEmpty) {
        var cost = querySnapshot.docs.first['cost'];
        print("Cost of $selectedItem: $cost");
        totalAmount += (cost is int) ? cost : (cost as double).toInt();
      } else {
        print("Item $selectedItem not found in menu.");
      }
    }
    print("Total amount calculated: $totalAmount");
    return totalAmount;
  }

  Future<int> _updateTotalAmount() async {
    _selectedItems = widget.itemCounts.keys.toList();
    total = await calculateTotal(_selectedItems); // Calculate the total amount
    if (mounted) {
      setState(() {
        totalAmount = total; // Update totalAmount with the calculated total
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
            // Table to display order details
            DataTable(
              columns: [
                DataColumn(label: Text("Item")),
                DataColumn(label: Text("Quantity")),
              ],
              rows: widget.itemCounts.entries.map((entry) {
                return DataRow(
                  cells: [
                    DataCell(Text(entry.key)),
                    DataCell(Text(entry.value.toString())),
                  ],
                );
              }).toList(),
            ),
            Text(
                "Total Items: ${widget.itemCounts.values.reduce((sum, element) => sum + element)}"),
            Text("Total Amount to Pay: $totalAmount"),
            // Total number of items

            SizedBox(height: 10),
            // Dropdown box for payment option
            DropdownButton<String>(
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
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                backgroundColor: Color(0xffF5DAD2),
                foregroundColor: Colors.black,
                fixedSize: const Size(350, 50),
              ),
              onPressed: () async {
                print("Submitting order...");
                if (_selectedItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No items selected'),
                    ),
                  );
                } else {
                  int neww = await _updateTotalAmount();
                  _incrementTotalAmount(
                      neww); // Ensure the total amount is updated
                  var now = DateTime.now();
                  await incOrderNo();
                  await _history.add({
                    'amount': totalAmount,
                    'mode': _selectedItem2,
                    'order_no': curNum,
                    'time-stamp': now,
                    'items': _selectedItems,
                  });
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  print("Order submitted successfully.");
                }
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
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
