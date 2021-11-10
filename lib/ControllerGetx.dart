import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import './Tea.dart';
import './BrewDialog.dart';

class Controller extends GetxController {
    final speed = 1;
    var  brewTimer = (-1.0).obs;
    var isInitTimer = true.obs;
    var brewIndex = (-1).obs;
    final timerStateString = ["Wlewaj wodę", "Zamknij czajniczek i czekaj", "Wylewaj napar do filiżanki"];
    var timerStateIndex = (0).obs;
    var dividerBounce = (1.0).obs;

    var liquidLineFirst = List<double>.filled(25, 0.0).obs;
    var liquidLineSecond = List<double>.filled(25, 0.0).obs;
    void flow( final int time) async{
        final rng = Random(DateTime.now().microsecondsSinceEpoch);
        var k1 = rng.nextDouble();
        var k2 = rng.nextDouble();
        while(brewIndex.value != -1){
            k1 += 0.008;
            k2 += 0.018;
            for(var i = 0; i < liquidLineFirst.value.length; i++){
                liquidLineFirst.value[i] = (0.9*(( brewTimer.value)/time)+  0.1*sin(0.05*(k1+i)*pi));
                liquidLineSecond.value[i] = (0.9*(( brewTimer.value)/time)+ 0.1*cos(0.05*(k2+i)*pi));
            }
            await Future.delayed(Duration(milliseconds: 1));
        }
    }
    /*void flow() async{
        while(brewIndex.value != -1){
            liquidLine.value[liquidLine.value.length - 2] = Random().nextDouble() * 10;
            var firstDeriv = List<double>.filled(liquidLine.value.length + 1, 0);
            for(var i = 1; i < liquidLine.value.length - 1; i++){
                firstDeriv[i] = liquidLine.value[i] - liquidLine.value[i-1];
            }

            var secondDeriv = List<double>.filled(liquidLine.value.length, 0);
            for(var i = 0; i < firstDeriv.length - 1; i++){
                secondDeriv[i] = firstDeriv[i+1] - firstDeriv[i];
            }
            for(var i = 2; i < liquidLine.length - 1; i++){
                liquidLine[i] -= secondDeriv[i + 1] * 0.7;
                liquidLine[i] -= liquidLine[i] * 0.2;
            }
            print(liquidLine.value.toString());
            await Future.delayed(Duration(milliseconds: 15));
        }
    }*/

    var doReset = false;
    Map<String, Color> teaColors = {};
    Map<String, List<Tea>> teaTypes = {};
    var dataFetched = false;
    void startInitialTimer(int time) async {
        brewTimer.value = 1.0 * time;
        while(brewTimer>0){
            if(doReset){
                doReset = false;
                brewTimer.value = -1.0;
                brewIndex.value = -1;
                return;
            }
            await Future.delayed(Duration(milliseconds: speed));
            brewTimer.value-= speed * 0.01;
            
        }
        brewTimer.value = -1.0;
        isInitTimer.value = false;
    }
    void startTimer(int time) async {
        brewTimer.value = 1.0 * time;
        while(brewTimer > 0){
            if(doReset){
                doReset = false;
                brewTimer.value = -1.0;
                brewIndex.value = -1;
                isInitTimer.value = true;
                return;
            }
            await Future.delayed(Duration(milliseconds: speed));
            if(brewTimer.value > time - 5){
                timerStateIndex.value = 0;
            }else if(brewTimer.value > 5){
                timerStateIndex.value = 1;
            }else{ 
                timerStateIndex.value = 2;
            }
            brewTimer.value-=speed*0.01;
            
        }
        Get.snackbar('Ready!!!','You can enjoy your tea');
        brewTimer.value = -1.0;
        brewIndex.value = -1;
        isInitTimer.value = true;
    }
    Color translateHexToColor(String stringHex){
        if(!stringHex.isHexadecimal) return Colors.white54;

        final hex =  int.parse(stringHex.replaceFirst('#','0xff'));
        return Color(hex);
    }
       Future<void> deserializeData() async{
           assert(teaTypes.isEmpty);
           if(teaTypes.isNotEmpty) teaTypes = {};
           print('Fetching data from firebasesirestore');
            FirebaseFirestore firebase = FirebaseFirestore.instance;
            var snapshotTeaTypes = firebase.collection('tea_types');
            var teaTypesDocs =  await snapshotTeaTypes.get().then((snapshot)=> snapshot.docs);
           for( var teaType in teaTypesDocs){
                teaTypes.addEntries({MapEntry(teaType.id, <Tea>[])});
                teaColors.addEntries({MapEntry(teaType.id, translateHexToColor(teaType.data()['color'].toString()))});
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
