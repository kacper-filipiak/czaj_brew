import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './ControllerGetx.dart';

class BrewDialog extends StatefulWidget{
    const BrewDialog({Key? key,
        required this.brew_times,
        required this.context,
    }) :  super(key: key);
    final BuildContext? context;
    final List<int> brew_times;

    @override 
    _BrewDialogState createState() => _BrewDialogState();

}
class _BrewDialogState extends State<BrewDialog>{


    
    @override
    Widget build(context) {
        Controller c = Get.find();
        return Center(child: Container(
                                child:   Obx(() => c.brewIndex.value == -1? 
                Center( child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.brew_times.length, 
                        itemBuilder: (context, index) {
                            return Center(
                              child: IconButton(
                                      icon: Icon(Icons.coffee_rounded), 
                                      onPressed: () => c.brewIndex.value = index,

                                      ),
                            );
                }),
                )
        :
                Obx(() => c.isInitTimer.value? InitialTimer(): TeaTimer(time: widget.brew_times[c.brewIndex.value])) 
        ),
        ),
        );
    }
}
class InitialTimer extends StatelessWidget{
    InitialTimer({Key? key}) : super(key: key);

    final int time = 5;
    @override
    build(BuildContext context){
        Controller c = Get.find();
        c.startInitialTimer(time);
        return Center( child: Obx(() =>  Text("Start brewing in: ${c.brewTimer.value} seconds")));
    }

}
class TeaTimer extends StatelessWidget{
    TeaTimer({Key? key, required this.time}) : super(key: key);

    final int time;
    @override
    build(BuildContext context){
        Controller c = Get.find();
        c.startTimer(time);
        return Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
            
            Obx(() => Text(c.timerStateString[c.timerStateIndex.value])),
            Obx(() =>  Text("${c.brewTimer.value}"))
        ]);
    }

}
