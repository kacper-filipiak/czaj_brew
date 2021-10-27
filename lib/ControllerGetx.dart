import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import './Tea.dart';

class Controller extends GetxController {
    Map<String, List<Tea>> teaTypes = {};
       Future<void> deserializeData() async{
           print('Fetching data from firebasesirestore');
            FirebaseFirestore firebase = FirebaseFirestore.instance;
            var snapshotTeaTypes = firebase.collection('tea_types');
            var teaTypesDocs =  await snapshotTeaTypes.get().then((snapshot)=> snapshot.docs);
           for( var teaType in teaTypesDocs){
                teaTypes.addEntries({MapEntry(teaType.id, <Tea>[])});

                var snapshotTea = firebase.collection('tea_types').doc(teaType.id).collection('teas');
                var teaDocs = await snapshotTea.get().then((snapshot) => snapshot.docs);
                for(var teaDoc in teaDocs){
                    final snapshotBrewTime = snapshotTea.doc(teaDoc.id).collection('brews');
                    final brewTimeDocs =  await snapshotBrewTime.get().then((snapshot)=>snapshot.docs);
                    
                    final brewMap = brewTimeDocs.asMap();
                    
                    var tea = Tea(teaDoc.data()['name'].toString(), teaDoc.data()['description'].toString(), []);
                    for(var doc in brewMap.entries){
                        tea.brew_time.add(int.parse(doc.value['time']));
                    }
                    print(tea.toString());
                    teaTypes[teaType.id]?.add(tea);
                }
           }

       }
}
