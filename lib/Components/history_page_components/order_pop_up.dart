import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Components/custom_text.dart';
import 'package:juice_point/Functions/fetch_order_details.dart';
import 'package:juice_point/Functions/formated_time_stamp.dart';
import 'package:juice_point/utils/constants.dart';

class OrderDetailsDialog extends StatefulWidget {
  final String orderNo;
  final BuildContext context;

  const OrderDetailsDialog(
      {super.key, required this.orderNo, required this.context});

  @override
  OrderDetailsDialogState createState() => OrderDetailsDialogState();
}

class OrderDetailsDialogState extends State<OrderDetailsDialog> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _fetchOrder;

  @override
  void initState() {
    super.initState();
    _fetchOrder = fetchOrderData(widget.orderNo);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Column(
        children: [
          CustomText(
            value: "Order Details",
            textAlign: TextAlign.center,
            color: primaryColor,
            size: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: primaryColor,
          )
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _fetchOrder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              Map<String, dynamic> data = snapshot.data!.data()!;
              return SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: CustomText(value: 'Detail')),
                    DataColumn(label: CustomText(value: 'Value')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(CustomText(value: 'Items')),
                      DataCell(
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              data['items'].length,
                              (index) => CustomText(
                                value:
                                    "${data['items'][index]['name']}: ${data['items'][index]['count']}",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(CustomText(value: 'Amount')),
                      DataCell(
                          CustomText(value: '₹ ${data['amount'].toString()}')),
                    ]),
                    DataRow(cells: [
                      const DataCell(CustomText(value: 'Mode')),
                      DataCell(CustomText(value: data['mode'].toString())),
                    ]),
                    DataRow(cells: [
                      const DataCell(CustomText(value: 'Time')),
                      DataCell(CustomText(
                          value:
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
          child: const CustomText(value: 'Close'),
        ),
      ],
    );
  }
}
