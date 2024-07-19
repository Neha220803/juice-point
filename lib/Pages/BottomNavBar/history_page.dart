// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Widgets/custom_text.dart';
import 'package:juice_point/Components/history_page_components/order_pop_up.dart';
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
            child: CustomText(
              value: "~ Order History ~",
              size: 26,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.81,
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
                          child: CustomText(
                            value: date,
                            size: 16,
                            color: grey,
                            fontWeight: FontWeight.bold,
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
                                      child: CustomText(
                                        value: "${order['order_no']}",
                                      )),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: CustomText(
                                      value: "Order No. ${order['order_no']}",
                                      fontWeight: FontWeight.bold,
                                      size: 18,
                                    ),
                                  ),
                                  trailing:
                                      CustomText(value: "₹${order['amount']}"),
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
                                                  context: context,
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
                                        child: CustomText(
                                          value: "View Details",
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          size: 17,
                                        ),
                                      ),
                                      CustomText(
                                        value: formattedTimestamp(
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