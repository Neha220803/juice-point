// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);
  String formattedTime = DateFormat('h:mm a').format(timestamp);
  return '$formattedTime on $formattedDate';
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
                stream: _history.snapshots(),
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
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var data =
                          documents[index].data() as Map<String, dynamic>;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(
                                  0xffF5DAD2), // Set the background color to pink
                              child: Text(
                                "${data['order_no']}", // Display order number
                                style: TextStyle(
                                    color: Colors.black), // Text color
                              ),
                            ),
                            title: Text(
                                "Order No. " + data['order_no'].toString()),
                            trailing: Text("₹" + data['amount'].toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Items: " + data['items'].toString()),
                                Text(
                                  '${formattedTimestamp(data['time-stamp'].toDate())}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
