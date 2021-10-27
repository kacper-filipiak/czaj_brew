import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( GetMaterialApp(home: App()));
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
      final Controller c = Get.put(Controller());
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage(error: snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MainPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Loading();
      },
    );
  }
}
class Tea{
    final String description;
    final String name;
    final List<int> brew_time;


    Tea(this.name, this.description, this.brew_time);
    @override
    String toString(){
        String brews = "";
        for( var i in brew_time){
           brews+=i.toString() + ' '; 
        }
        return 'Tea: ${name}, ${description}, brewing times:  ${brews}';
    }
}
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
class MainPage extends StatelessWidget{
    const MainPage({Key? key}) : super(key: key);
    


    @override
    Widget build(BuildContext context) {
    Controller c = Get.find();
        

        return Center(
                child: FutureBuilder(
                        future: c.deserializeData(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                return Text(c.teaTypes.toString());
                        },
                ),

        );
    }
}
class ErrorPage extends StatelessWidget{
    const ErrorPage({Key? key, String? error}) : _error=error, super(key: key);
    final _error;
    @override
    Widget build(BuildContext context) {
        return Center(
                child: Text('Error!!! $_error'),
        );
    }
}
class Loading extends StatelessWidget{
    const Loading({Key? key}) : super(key: key);
    
    @override
    Widget build(BuildContext context) {
        return const Center(
                child: Text('Loading...'),
        );
    }
}
