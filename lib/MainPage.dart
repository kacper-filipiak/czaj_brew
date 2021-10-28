import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './ControllerGetx.dart';
import './TeaPage.dart';


class MainPage extends StatelessWidget{
    const MainPage({Key? key}) : super(key: key);
    


    @override
    Widget build(BuildContext context) {
    Controller c = Get.find();
        

        return Center(
                child: FutureBuilder(
                        future: c.deserializeData(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                return Center(
                                  child: TeaTypeList(), 
                                );
                        },
                ),

        );
    }
}
class TeaTypeList extends StatelessWidget{
    const TeaTypeList({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        Controller c = Get.find();
        return ListView.builder(itemCount: c.teaTypes.length,
                
                                          itemBuilder: (context, index){
                                              var name = c.teaTypes.keys.elementAt(index);
                                              
                                              return Padding(
                                                      child: TeaTypeListTile( name: name),
                                                      padding:EdgeInsets.symmetric(
                                                              vertical: MediaQuery.of(context).size.height * 0.01 ),
                                                      );
                                          }
                                              );
    }
}

class TeaTypeListTile extends StatelessWidget {
  const TeaTypeListTile({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
      Controller c = Get.find();
    return Container(
            color: c.teaColors[name],
                            child: Column(
                              children: [
                                Text(name),
                                ListView.separated(itemCount: c.teaTypes[name]!.length,
                                        shrinkWrap: true,

                                        separatorBuilder: (context, index){
                                            return Divider(color: Theme.of(context).dividerColor ,);
                                        },
                                        itemBuilder:(context, index){
                                            return ListTile( 
                                                    title: Text((c.teaTypes[name]![index].name)),
                                                    onTap: ()=> Get.to(TeaPage(name:name, index: index)),
                                                    );
                             
                                        }
                                )

                              ],
                            )
                );
  }
}
