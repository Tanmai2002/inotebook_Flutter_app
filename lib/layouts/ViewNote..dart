
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:inotebook/api/ApiCalls.dart';
import 'package:inotebook/models/Note.dart';

String title='',desc='',tag='General';
bool _isUpdateMode=false;

class ViewNote extends StatelessWidget {

  const ViewNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Note? note1=ModalRoute.of(context)?.settings.arguments as Note?;
    void AddNote() async{
      if(!_isUpdateMode){
      Response response =await ApisCall.addNote(title: title, description: desc,tag: tag);
      if(response.statusCode!=200){

        Map<String,dynamic> errors=jsonDecode(response.body);
        Fluttertoast.showToast(msg: errors['Error']!=null?errors['Error'].toString():"",backgroundColor: Colors.redAccent);
        return;
      }
      Fluttertoast.showToast(msg:'Note Added Successfully!',backgroundColor: Colors.greenAccent);
      Navigator.pop(context);
      }
      else{
        note1!.title=title;
        note1.description=desc;
        note1.tag=tag;
        Response response =await ApisCall.updateNote(note: note1);
        if(response.statusCode!=200){

          Map<String,dynamic> errors=jsonDecode(response.body);
          Fluttertoast.showToast(msg: errors['Error']!=null?errors['Error'].toString():"",backgroundColor: Colors.redAccent);
          return;
        }
        Fluttertoast.showToast(msg:'Note updated Successfully!',backgroundColor: Colors.greenAccent);
        Navigator.pop(context);
      }
    }
    return Scaffold(

      appBar: AppBar(title: const Text('INotebook'),
          actions: <Widget>[
          Padding(
          padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            AddNote();
          },
          child: Icon(
            Icons.add,
            size: 26.0,
          ),
        )
    ),]
    ),

      body: AddNoteView(note: note1),
    );
  }
}

class AddNoteView extends StatefulWidget {
  final Note? note;
  AddNoteView({required this.note});


  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
@override
  void initState() {
    if(widget.note!=null){
      Note n=widget.note!;
      setState(() {
        title=n.title;
        desc=n.description;
        tag=n.tag;
        _isUpdateMode=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(10),
              child: Text('Add Note',style: TextStyle(fontSize: 35),)),
      Container(
      margin: EdgeInsets.all(10),
        child: TextFormField(
          textAlign: TextAlign.center,
            maxLines: 2,
            initialValue: title,
            minLines: 1,
            onChanged: (val){title=val;},
            decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder()),
            ),

      ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLines: 10,
              minLines: 4,
              initialValue: desc,
              onChanged: (val){desc=val;},
              decoration: InputDecoration(
                  hintText: 'description',
                  border: OutlineInputBorder()),
            ),

          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              autofillHints: const ['General','Medicines','Sports','Reminder'],
              textAlign: TextAlign.center,
              maxLines: 1,
              initialValue: tag,
              minLines: 1,
              onChanged: (val){tag=val;},
              decoration: InputDecoration(
                  hintText: 'tag',
                  border: OutlineInputBorder()),
            ),

          ),

        ],
      )),
    );
  }
}
