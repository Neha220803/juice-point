import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataBaseController extends GetxController{
  var menuItems = <DocumentSnapshot>[].obs;
  var historyItems = <DocumentSnapshot>[].obs;
  
}