
import 'package:flutter/cupertino.dart';

class widget_controler{
 double factor =1;
 late Size media_size  ;
 widget_controler(Size s){this.media_size=s;}




 Size bottombar()
 {
  return media_size*0.05;
 }


}