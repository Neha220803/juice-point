import 'package:cloud_firestore/cloud_firestore.dart';

int curNum = 0;
int totalAmount = 0;
final CollectionReference _menu = FirebaseFirestore.instance.collection('menu');
final CollectionReference _history =
    FirebaseFirestore.instance.collection('history');

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
  // print("Total amount calculated: $totalAmount");
  return totalAmount;
}

Future<void> incOrderNo() async {
  QuerySnapshot snapshot = await _history.get();
  curNum = snapshot.docs.length;
  curNum++;
  // print("Current order number: $curNum");
}

Future<int> calculateItemCost(String itemName) async {
  QuerySnapshot querySnapshot =
      await _menu.where('name', isEqualTo: itemName).limit(1).get();
  if (querySnapshot.docs.isNotEmpty) {
    var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
    var cost = data['cost'];
    return (cost is int) ? cost : (cost as double).toInt();
  }
  return 0;
}
