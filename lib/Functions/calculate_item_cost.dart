import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> calculateItemCost(String itemName) async {
  final CollectionReference menu =
      FirebaseFirestore.instance.collection('menu');
  QuerySnapshot querySnapshot =
      await menu.where('name', isEqualTo: itemName).limit(1).get();
  if (querySnapshot.docs.isNotEmpty) {
    var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
    var cost = data['cost'];
    return (cost is int) ? cost : (cost as double).toInt();
  }
  return 0;
}
