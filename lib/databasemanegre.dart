import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'varss.dart';
class dbmaneger {

  dbmaneger._();

  static final dbmaneger _database = dbmaneger._();
  factory dbmaneger() => _database;
  static Database? _db;

  Future<Database?> get db async{
    if (_db !=null) return _db;
    _db = await initialDB();
    return _db;
  }
  initialDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return openDatabase(join(documentsDirectory.path, 'quran.db'),
        version: 1, onCreate: _onCreate);
  }


  Future _onCreate(Database db,int version) async{

    await db.execute('DROP TABLE IF EXISTS surat');
    await db.execute('DROP TABLE IF EXISTS ayat');
    await db.execute("CREATE TABLE  ayat (ayat_id INTEGER PRIMARY KEY AUTOINCREMENT,  sourah_num int  ,ayah_number int ,ayah_page int, ayah_text text)");
    await db.execute("CREATE TABLE  surat ( surah_id int PRIMARY KEY, surah_name text )");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
  }
  Future<List<Map>> readData(String sql) async
  { Database? mydb=await db;
    List<Map> response=await mydb!.rawQuery(sql);
     print(response[0]["ayat_id"]); // add this line
    return response;
  }
  Future<List<Map>> get_ayat_of_page (int pagenum)async
  {
    List<Map> ayat=await readData("SELECT ayah_number,ayah_text from ayat where ayah_page =$pagenum order by sorah_num,ayah_number");
    return ayat;
  }



  }





/*
FutureBuilder(future : readall()
, builder: (BuildContext context,AsyncSnapshot<List<Map>> snapshot){
print(snapshot); // add this line
if(snapshot.hasData) {

return ListView.builder(
itemCount: snapshot.data!.length,
physics: NeverScrollableScrollPhysics(),
shrinkWrap: true,
itemBuilder: (context, i) {
return  Text("${snapshot.data![i]}");
});
}

return Center(child: CircularProgressIndicator(),);
})

 */