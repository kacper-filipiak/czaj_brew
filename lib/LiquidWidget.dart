import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import './ControllerGetx.dart';

class LiquidPinter extends CustomPainter{

        Controller c = Get.find();
    @override
    paint(Canvas canvas, Size size){

        
        var paint = Paint();
        paint.color = Color.fromARGB(255, 193,138,69);
        paint.strokeWidth = 0;
        paint.style = PaintingStyle.fill;

        var path = Path();
        path.moveTo(paint.strokeWidth, size.height/2 +(size.height/2) * c.liquidLineFirst[0]);
        
        for(var i = 1; i<c.liquidLineFirst.value.length; i++){
            path.lineTo((i )*size.width/(c.liquidLineFirst.value.length - 1),size.height/2 + (size.height/2) * c.liquidLineFirst[i]);
        }
        path.lineTo(size.width, size.height);
        path.lineTo(paint.strokeWidth,size.height);
        path.close();
        print('pinting');
        canvas.drawPath(path, paint);

        paint.color =  Color.fromARGB( 100, 5, 5, 255);
        var path2 = Path();
        path2.moveTo(paint.strokeWidth,size.height/2 + (size.height/2) * c.liquidLineSecond[0]);
        
        for(var i = 1; i<c.liquidLineSecond.value.length; i++){
            path2.lineTo((i)*size.width/(c.liquidLineSecond.value.length - 1),size.height/2 + (size.height/2) * c.liquidLineSecond[i]);
        }
        path2.lineTo(size.width, size.height);
        path2.lineTo(paint.strokeWidth,size.height);
        path2.close();

          canvas.drawPath(path2, paint);
          c.dividerBounce.value += 0.000001;
    }

    @override 
    bool shouldRepaint(CustomPainter oldDelegete){

        return true;
    }
}