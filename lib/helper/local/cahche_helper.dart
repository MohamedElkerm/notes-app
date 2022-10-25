import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static  SharedPreferences?  sharedPreferences;
  static init()async{
    sharedPreferences =await SharedPreferences.getInstance();
  }

  static  getData({key})  {
    return  sharedPreferences!.get(key);
  }

  static Future<bool> saveData({required key,required value})async{
    if(value is String) return await sharedPreferences!.setString(key, value);
    else if(value is int) return await sharedPreferences!.setInt(key, value);
    else if(value is bool) return await sharedPreferences!.setBool(key, value);
    else return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData({@required key})async{
    return await sharedPreferences!.remove(key);
  }

}