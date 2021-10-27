import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './ControllerGetx.dart';


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
