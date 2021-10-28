import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './ControllerGetx.dart';

class TeaPage extends StatelessWidget{
    const TeaPage({Key? key,
        required this.index,
        required this.name}) :  super(key: key);

    final int index;
    final String name;

    @override
    Widget build(BuildContext context) {
        Controller c = Get.find();
        final tea = c.teaTypes[name]![index];
        return Scaffold(
                body: Column(
                        children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2,
                                    child: Image.network('https://www.google.com/url?sa=i&url=https%3A%2F%2Fswiezopalona.pl%2Fprodukt%2F2326%2FOolong&psig=AOvVaw0zU2iJFWxGdbaF80BV8c8D&ust=1635544929830000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCNjP8eyN7vMCFQAAAAAdAAAAABAD')),
                            Container(
                                    color: Theme.of(context).canvasColor,
                                    child: Column(children: [
                                        Text(tea.name, style: Theme.of(context).textTheme.headline1),
                                        Text(tea.description, style: Theme.of(context).textTheme.bodyText1),
                                    ],),
                            ),


                        ]),
                floatingActionButton: FloatingActionButton(
                        child: Icon( Icons.coffee),
                        onPressed: () => print('Zaparzanie'),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                );
        
    }
}
