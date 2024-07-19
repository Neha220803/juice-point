// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Functions/formated_time_stamp.dart';
import 'package:juice_point/utils/constants.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  OrderHistoryPageState createState() => OrderHistoryPageState();
}

class OrderHistoryPageState extends State<OrderHistoryPage> {
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
                color: black,
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
                for (var order in orders) {
                  DateTime orderTime =
                      (order['time-stamp'] as Timestamp).toDate();
                  String formattedDate =
                      "${orderTime.year}-${orderTime.month}-${orderTime.day}";
                  if (!groupedOrders.containsKey(formattedDate)) {
                    groupedOrders[formattedDate] = [];
                  }
                  groupedOrders[formattedDate]!.add(order);
                }

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
                              color: grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Divider(
                            color: grey,
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
                                padding: defaultPadding,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: secondaryColor,
                                    child: Text(
                                      "${order['order_no']}",
                                      style: TextStyle(color: black),
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Order No. ${order['order_no']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  trailing: Text("₹${order['amount']}"),
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
                                        formattedTimestamp(
                                            order['time-stamp'].toDate()),
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

  const OrderDetailsDialog({super.key, required this.orderNo});

  @override
  OrderDetailsDialogState createState() => OrderDetailsDialogState();
}

class OrderDetailsDialogState extends State<OrderDetailsDialog> {
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
      title: Column(
        children: [
          Text(
            "Order Details",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff75A47F),
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: Color(0xff75A47F),
          )
        ],
      ),
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
