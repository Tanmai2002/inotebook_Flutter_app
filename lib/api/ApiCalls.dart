import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inotebook/models/Note.dart';

const  String AUTHTOKEN='authToken';
class ApisCall{
  static String host='https://inotebook-dazz.herokuapp.com';
  static  String auth='';
  static final FlutterSecureStorage storage=new FlutterSecureStorage();
  static Future initializeValues() async{
    var t=await storage.read(key: AUTHTOKEN);
    if(t!=null && t.isNotEmpty){
      auth=t;
    }
  }
  static Future<Response> signUpApi({required username,required email,required password}) async {

    String url='$host/api/auth/createUser';
    Response response=await post(Uri.parse(url),
        headers: <String ,String>{
        'Content-Type':'application/json'
        },
        body: jsonEncode(<String, String>{
        "name":username,
        "email":email,
        "password":password
        }),
    );
    if(response.statusCode==200) {

      auth=jsonDecode(response.body)['authToken'];

      await storage.write(key: AUTHTOKEN, value: jsonDecode(response.body)['authToken'] );
      print(await storage.read(key: AUTHTOKEN));
    }
    return response;
  }
  static Future<Response> loginApi ({required email,required password}) async{
    String url='$host/api/auth/login';
    Response response=await post(Uri.parse(url),
      headers: <String ,String>{
        'Content-Type':'application/json'
      },
      body: jsonEncode(<String, String>{
        "email":email,
        "password":password
      }),
    );
    if(response.statusCode==200) {
      auth=jsonDecode(response.body)['authToken'];
      await storage.write(key: AUTHTOKEN, value: jsonDecode(response.body)['authToken'] );
      print(await storage.read(key: AUTHTOKEN));
    }
    // print(jsonDecode(response.body)['authToken']);

    return response;
  }

  static Future<Response> getAllNotes() async{
    String url='$host/api/notes/allNotes';
    Response response=await get(Uri.parse(url),headers: <String,String>{
      'auth-token':auth
    });
    print(response.body);
    return response;
  }
  
}