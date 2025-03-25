import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yofa/models/data.dart';

abstract class FirestoreServices{
  static Future<Data> add(String collection, Map<String, dynamic> data) async{
    try{
      var res = await FirebaseFirestore.instance.collection(collection).add(data);
      return Data<String>(res.id, Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> set(String collection, String docId, Map<String, dynamic> data) async{
    try{
      await FirebaseFirestore.instance.collection(collection).doc(docId).set(data);
      return Data<String>(docId, Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> update(String collection, String id, Map<String, dynamic> data) async{
    try{
      await FirebaseFirestore.instance.collection(collection).doc(id).update(data);
      return Data<String>("done", Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> getInfo(String id) async{
    try{
      var snapshot = await FirebaseFirestore.instance.collection("Withdraw").doc(id).get();
      if(snapshot.exists){
        Map<String, dynamic> map = snapshot.data()!;
        return Data<Map<String, dynamic>>(map, Status.success);
      }
      else{
        return Data<String>("doesn't exist", Status.fail);
      }
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }


}