

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TCheckBoxTheme{
  TCheckBoxTheme._();
  static CheckboxThemeData lightAppBArTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected))
        {
          return Colors.white;
        }
      else
        {
          return Colors.black;
        }
    }),
    fillColor:  MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected))
      {
        return Colors.blue;
      }
      else
      {
        return Colors.transparent;
      }
    }),


  );
  static CheckboxThemeData darkAppBArTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected))
      {
        return Colors.white;
      }
      else
      {
        return Colors.black;
      }
    }),
    fillColor:  MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected))
      {
        return Colors.blue;
      }
      else
      {
        return Colors.transparent;
      }
    }),


  );
}