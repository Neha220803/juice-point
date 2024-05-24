// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);
  String formattedTime = DateFormat('h:mm a').format(timestamp);
  return '$formattedTime on $formattedDate';
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final CollectionReference _history =
      FirebaseFirestore.instance.collection('history');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "~ Order History ~",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Roboto Slab',
                fontWeight: FontWeight.w700,
                letterSpacing: 1.81,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _history.orderBy('time-stamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No orders available'));
                }

                List<QueryDocumentSnapshot> orders = snapshot.data!.docs;

                Map<String, List<QueryDocumentSnapshot>> groupedOrders = {};
                orders.forEach((order) {
                  DateTime orderTime =
                      (order['time-stamp'] as Timestamp).toDate();
                  String formattedDate =
                      "${orderTime.year}-${orderTime.month}-${orderTime.day}";
                  if (!groupedOrders.containsKey(formattedDate)) {
                    groupedOrders[formattedDate] = [];
                  }
                  groupedOrders[formattedDate]!.add(order);
                });

                return ListView.builder(
                  itemCount: groupedOrders.length,
                  itemBuilder: (context, index) {
                    String date = groupedOrders.keys.toList()[index];
                    List<QueryDocumentSnapshot> ordersOnDate =
                        groupedOrders[date]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ordersOnDate.length,
                          itemBuilder: (context, index) {
                            var order = ordersOnDate[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(
                                        0xffF5DAD2), // Set the background color to pink
                                    child: Text(
                                      "${order['order_no']}", // Display order number
                                      style: TextStyle(
                                          color: Colors.black), // Text color
                                    ),
                                  ),
                                  title: Text("Order No. " +
                                      order['order_no'].toString()),
                                  trailing:
                                      Text("₹" + order['amount'].toString()),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return OrderDetailsDialog(
                                                  orderNo: order['order_no']
                                                      .toString(),
                                                );
                                              },
                                            );
                                          } catch (error) {
                                            print(
                                                "Error fetching order details: $error");
                                            // Handle error
                                          }
                                        },
                                        child: Text(
                                          "View Details",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff75A47F),
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${formattedTimestamp(order['time-stamp'].toDate())}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsDialog extends StatefulWidget {
  final String orderNo;

  const OrderDetailsDialog({Key? key, required this.orderNo}) : super(key: key);

  @override
  _OrderDetailsDialogState createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _fetchOrder;

  @override
  void initState() {
    super.initState();
    _fetchOrder = _fetchOrderData(widget.orderNo);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchOrderData(
      String orderNo) async {
    int orderNum = int.parse(orderNo);
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('history')
        .where('order_no', isEqualTo: orderNum)
        .get();
    // Since order_no should be unique, we expect only one document in the snapshot
    // So we return the first document in the list
    return snapshot.docs.isNotEmpty
        ? snapshot.docs.first
        : throw Exception('No data found for order number: $orderNo');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Order Details"),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _fetchOrder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              Map<String, dynamic> data = snapshot.data!.data()!;
              return SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Detail')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Items')),
                      DataCell(
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              data['items'].length,
                              (index) => Text(
                                "${data['items'][index]['name']}: ${data['items'][index]['count']}",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Amount')),
                      DataCell(Text('₹ ${data['amount'].toString()}')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Mode')),
                      DataCell(Text(data['mode'].toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Time')),
                      DataCell(Text(
                          formattedTimestamp(data['time-stamp'].toDate()))),
                    ]),
                  ],
                ),
              );
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
