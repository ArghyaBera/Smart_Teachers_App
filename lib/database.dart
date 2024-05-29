import 'package:cloud_firestore/cloud_firestore.dart';
class datab{
  Future addStudDetail(Map<String,dynamic>studDet,String id)async{
    return await FirebaseFirestore.instance
        .collection("students")
        .doc(id)
        .set(studDet);
  }
  Future<Stream<QuerySnapshot>>getDetails() async{
      return await FirebaseFirestore.instance.collection("students").snapshots();
  }
}