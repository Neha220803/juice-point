// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "~ Menu ~",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.81,
                ),
              ),
            ),
            Expanded(
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
                        // color: Colors.pink,
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
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            "https://firebasestorage.googleapis.com/v0/b/juice-point-4d411.appspot.com/o/avacado.png?alt=media&token=8146eb62-4cbc-4cd4-9320-1655ebe778de"),
                                        backgroundColor: Colors.white,
                                      ),
                                      title: Text(data['name']),
                                      trailing:
                                          Text("₹" + data['cost'].toString()),
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
      ),
    );
  }
}
