import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:inotebook/api/ApiCalls.dart';
import 'package:inotebook/models/Note.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
List notes=[
];

bool _isLoading=false;
class _HomeState extends State<Home> {

@override
  void initState() {
    getAllNotes();
  }
void deleteNote(Note note)async{
  setState(() {
    _isLoading=true;
  });
  Response response =await ApisCall.deleteNote(note: note);
  if(response.statusCode==200){
    notes.remove(note);
    setState(() {
      notes=notes;
      _isLoading=false;

    });
    Fluttertoast.showToast(msg: "Successfully deleted" , backgroundColor: Colors.greenAccent);

  }else{
    setState(() {
      _isLoading=false;
    });
    Fluttertoast.showToast(msg: "Cannot Delete Error",backgroundColor: Colors.redAccent);
  }
}
  void getAllNotes() async{
    setState(() {
      _isLoading=true;
    });
    Response response=await ApisCall.getAllNotes();
    setState(() {
      _isLoading=false;
    });
    if(response.statusCode==200){
      List l=jsonDecode(response.body)['notes'];
      List tnotes=[];
      for(Map<String,dynamic> note in l){
        tnotes.add(Note.fromMap(note));
      }
      setState(() {
        notes=tnotes;
        _isLoading=false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions:[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  getAllNotes();
                },
                child: Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )
          ),],

      ),
      body: Container(
        child :_isLoading?NotesLoadingPage():NotesPage(deleteNote: deleteNote,)
      ),
      floatingActionButton:
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/ViewNote');
        },),

    );
  }
}

class NotesPage extends StatefulWidget {
  final deleteNote;
  const NotesPage({ required this.deleteNote});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: MasonryGridView.count(

          crossAxisCount: 2,
          mainAxisSpacing: 4,
          itemCount: notes.length,
          crossAxisSpacing: 4,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            Note note=notes[index];
            return Card(
              child: Container(
                padding: EdgeInsets.all(10),
                height:max(3, min(10, note.description.length~/100))*20+(min(1, note.title.length~/10)+1)*30+60,
                child: Column(


                  children: [
                    Text(note.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20
                      ),
                      overflow: TextOverflow.ellipsis,),
                    Text(note.description,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        maxLines: max(3, min(10, note.description.length~/100)),


                        overflow: TextOverflow.ellipsis),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){
                            widget.deleteNote(note);
                          }, icon: const Icon(Icons.delete)),
                          IconButton(onPressed: (){
                            Navigator.pushNamed(context, '/ViewNote',arguments: note);
                          }, icon: const Icon(Icons.edit) ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

            );
          },
        )
    );
  }
}

class NotesLoadingPage extends StatelessWidget {
  const NotesLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.blueAccent, size: 100));
  }
}


