
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'varss.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';


class db_maneger_v2{

  var databaseFactory = databaseFactoryFfi;
  db_maneger_v2._();

  static final db_maneger_v2 _database = db_maneger_v2._();
  factory db_maneger_v2() => _database;
  static Database? _db;

  Future<Database?> get db async{

    if(_db!=null) return _db;

    _db = await initialDB();
    print("DATABASE INITIALISED");
    return _db;
  }
 initialDB() async {
   sqfliteFfiInit();
   return await databaseFactory.openDatabase( inMemoryDatabasePath, options: OpenDatabaseOptions(
           version: 1,
           onCreate: _onCreate));

  }
  Future _onCreate(Database db,int version) async{

    await db.execute('DROP TABLE IF EXISTS surat');
    await db.execute('DROP TABLE IF EXISTS ayat');
    await db.execute("CREATE TABLE  ayat (ayat_id   INTEGER  PRIMARY KEY AUTOINCREMENT,  sourah_num int  ,ayah_number int ,ayah_page int, ayah_text text)");
    await db.execute("CREATE TABLE  surat ( surah_id INTEGER PRIMARY KEY AUTOINCREMENT, surah_name text , surah_num int )");
    String surah_list_inserter ="";
    for (int i=0;i<surahList.length;i++)
      {
        surah_list_inserter=surah_list_inserter+"(  $i ,'${surahList[i]}' ) ,";

      }
    surah_list_inserter=surah_list_inserter.substring(0,surah_list_inserter.length-1);
    await db.rawInsert("insert into surat (surah_num , surah_name) VALUES $surah_list_inserter ");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");
    await db.rawInsert("INSERT INTO 'ayat'(sourah_num , ayah_number ,ayah_page, ayah_text )  VALUES (1 ,22,1,' إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا ')");

  }



  Future<List<Map>> readData(String sql) async
  { Database? mydb=await db;
  List<Map> response=await mydb!.rawQuery(sql);

  return response;
  }
  Future<List<Map>> get_ayat_of_page (int pagenum)async
  {
    List<Map> ayat=await readData("SELECT sourah_num ,ayah_number,ayah_text from ayat where ayah_page =$pagenum");
    return ayat;
  }
  Future<String> get_surah(int surah_num)async
  {
    List<Map> s=await readData("select surah_name from surat where surah_num= $surah_num");
    return s[0]["surah_name"];
  }
  Future<String> get_page_title(int page)async
  {
    List<Map> s=await readData("SELECT surah_name from surat where surah_num in ( SELECT surah_num from ayat where ayah_page=$page) ");

    if(s.isEmpty) return "empty";
    return s[0]["surah_name"];
  }



  }





