import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot<Map<String, dynamic>>> fetchOrderData(
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
