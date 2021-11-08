import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './ControllerGetx.dart';
import './BrewDialog.dart';

class TeaPage extends StatelessWidget{
    const TeaPage({Key? key,
        required this.index,
        required this.name,
        
    }) :  super(key: key);


    final int index;
    final String name;

    @override
    Widget build(BuildContext context) {
        Controller c = Get.find();
        final tea = c.teaTypes[name]![index];
        return Scaffold(
                body: Column(
                        children: [
                            SizedBox( 
                                    height: context.mediaQuerySize.height * 0.2,
                                    child: Container(
                                    decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomLeft,
                                                    colors: <Color>[
                                                        Colors.black,
                                                        c.teaColors[name]!,
                                                      Colors.white60,
                                                    ],
                                            ),
                                    ),
                                    ),
                                    ),
                            Container(
                                    color: Theme.of(context).canvasColor,
                                    child: Column(children: [
                                        Text(tea.name, style: Theme.of(context).textTheme.headline1),
                                        Text(tea.description, style: Theme.of(context).textTheme.bodyText1),
                                    ],),
                            ),



                        ]),
                floatingActionButton: FloatingActionButton(
                        backgroundColor: c.teaColors[name]!,
                        child: Icon( Icons.coffee, ),
                        onPressed: () async {await  Get.dialog(Dialog(child: (BrewDialog(brew_times: tea.brew_time, context:
                                                        context)))).whenComplete(() =>  c.doReset = true);},
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                );
        
    }
}
