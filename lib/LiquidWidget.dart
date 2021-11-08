import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import './ControllerGetx.dart';

class LiquidPinter extends CustomPainter{

        Controller c = Get.find();
    @override
    paint(Canvas canvas, Size size){

        
        var paint = Paint();
        paint.color = Color.fromARGB(255, 93,98,140);
        paint.strokeWidth = 0;
        paint.style = PaintingStyle.fill;

        var path = Path();
        path.moveTo(paint.strokeWidth, size.height*0.9 -(0.8*size.height ) * c.liquidLineFirst[0]);
        
        for(var i = 1; i<c.liquidLineFirst.value.length; i++){
            path.lineTo((i )*size.width/(c.liquidLineFirst.value.length - 1),size.height*0.9 - (0.8*size.height) * c.liquidLineFirst[i]);
        }
        path.lineTo(size.width, size.height);
        path.lineTo(paint.strokeWidth,size.height);
        path.close();
        print('pinting');
        canvas.drawPath(path, paint);

        paint.color =  Color.fromARGB( 100, 195, 195, 85);
        var path2 = Path();
        path2.moveTo(paint.strokeWidth,size.height*0.9 - (0.8*size.height) * c.liquidLineSecond[0]);
        
        for(var i = 1; i<c.liquidLineSecond.value.length; i++){
            path2.lineTo((i)*size.width/(c.liquidLineSecond.value.length - 1),size.height*0.9 - (0.8*size.height) * c.liquidLineSecond[i]);
        }
        path2.lineTo(size.width, size.height);
        path2.lineTo(paint.strokeWidth,size.height);
        path2.close();

          canvas.drawPath(path2, paint);
    }

    @override 
    bool shouldRepaint(CustomPainter oldDelegete){

        return true;
    }
}
