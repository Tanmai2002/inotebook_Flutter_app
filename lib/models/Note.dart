class Note{
   String title;
   String description;
  final String id;
   String tag;
  final DateTime dateTime;

  Note({required this.id, required this.title,required this.description,required this.dateTime,this.tag='General'});
  factory Note.fromMap(Map note){
        return Note(id: note['_id'], title: note['title'], description: note["description"], dateTime: DateTime.parse(note['date']),tag :note['tag'] ?? "General");
  }
}