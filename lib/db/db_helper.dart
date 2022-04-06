import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import '../models/task.dart';

class DBHelper {
  DBHelper();

  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';


  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      return initDb();
    }
  }
  static String? _dbPath;

  static Future<String> get databaseFilepath async {
    if (_dbPath != null) {
      return _dbPath!;
    } else {
      return await getDatabasesPath();
    }
  }
//that's initialize data base
  static Future<Database> initDb() async {
    //if it already here just tell me
    // Get a location using getDatabasesPath
    String path =join(await databaseFilepath, 'task.db') ;
    debugPrint("path $path");
    Database ourDb = await openDatabase(
      path,
      version: _version,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table columns
        await db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' title TEXT, note TEXT, date TEXT, startTime TEXT, isCompleted INTEGER,'
            ' endTime TEXT, color INTEGER, remind INTEGER, repeat TEXT )');
        debugPrint("database created $_db => $_tableName");
      },
    );
    return ourDb;
  }

 static Future<int> insertToDtaBase(Task? task) async {
    var db = await database;
    debugPrint("inserted ${task?.id}");

    return await db.insert(_tableName, task!.toJson());
  }

// static Future<int> insertRowToDtaBase(Task? task) async {
//   print("insert something my dear");
//
//   return await _db!.transaction((txn) async {
//     int id1 = await txn.rawInsert(
//         'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
//     print('inserted1: $id1');
//     return id1;
//   });
// }

 static Future<int> delete(Task task) async {
    var db = await database;
    debugPrint("deleted $task");
    return await db.delete(_tableName, where: ' id = ? ', whereArgs: [task.id]);
  }

static  Future<int> deleteAll() async {
    var db = await database;

    debugPrint("deleted All tasks");
    return await db.delete(_tableName);
  }

 static Future<List<Map<String, dynamic>>> query() async {
    var db = await database;

    debugPrint("queryed something");
    return await db.query(_tableName);
  }

// static Future<List<Map>> query1() async {
//   // Get the records
//   List<Map> list = await _db!.rawQuery('SELECT * FROM tasks');
//
//   print(list);
//  // print(expectedList);
//   return list;
// }

  updateAll(Task task)async{
    var db=await database;
    await db.update(_tableName, task.toJson(),where: "id = ?" ,whereArgs:[task.id] );
  }
  static  int x=1;
 static Future<int> update(int id) async {
    var db = await database;
    debugPrint("updated==>  $id");
    return await db.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [x, id]);
  }
}
/*import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // علشان مش كل مره يروح يعمل اوبجيكت جديد هنكريت كود يجيب نفس الاوبجيكت ده وهو الانيستانس
  static final DbHelper _instance = internal();

  //هنا بنكريت كونستراكتور من نفس نوع الكلاس علشان نقدر من خلالله نريتيرن او نرجع قيمه ال الاندر اسكور انستانس
  //ده هيجيبلينا الانيستانس اللي هو اصلاا نسخه وحيده
  factory DbHelper() => _instance;

  //هنا هنكريت النيمد كونستراكتور اللي اسمه internal علشان نبدا نقدر نستعمله
  //ده كونستراكتور من الكلاس اسمه internal علشان نستخدمه فوق ف اننا ناكسيس الكلاس الموجود مش كل شويه هنكريت اوبجيكت من الداتا بيز ده بيغنينا عن الهري ده
  internal();

//هنكريت بقي متغير نوعه داتا بيز اوبجيكت ونستدعي الباكيدج اللي اسمعا سيكوال اف لايت علشان نبدا بقي شغل البرمجه للداتا بيز دايناميكالي
  //المتغير ده بيشاور لي الداتا بيز لو موجوده او لا
  static Database? _db;

  Future<Database?> createDataBase() async {
    //بنسال الاول لو الداتا بيز دي موجوده هنا بنشاور عليها علشان نشتغل عليها لو مش موجوده هنخش في فانكشن الكريته بتاعتها علشان نكريت الداتا بيز يا نجم النجوم
    if (_db != null) {
      return _db;
    }
    //هنا بنقوله ضيف الداتا بيز دي ف المسار ده بالطريقه المناسبه للبلاتفورم اللي البرنامج هيشتغل عليها سواء اندرويد او ايفون يعني الشيبينج دي اسم الداتا بيز نفسها هنبدا بعد كده نكريت جواها التيبولز اللي احنا عايزينه
    // String path = join(await getDatabasesPath(), 'shipping.db');
    _db = await openDatabase('Shipping.db', version: 1, onCreate: (db, version) {
      // here we will create all tables you want
      //جمله sql اللي هتبدا تنشء الجدول كله
      print("database created");
      db.execute(
          'CREATE TABLE shipping_details (id INTEGER PRIMARY KEY ,type TEXT ,service TEXT ,payment TEXT ,amount INTEGER ,pricetype TEXT ,opening TEXT)');

    },onOpen: (db){print("database opend");});

    return _db;
  }

  Future<Future<int>?> createShipping() async {
    Database? db = await createDataBase();
    return db
        ?.rawInsert(
            'INSERT INTO shipping_details(amount  ,payment , service , type , pricetype  , opening) VALUES ("تسليم جزء من الطرد","شحن وتغليف","مسدده نقدا","12122","Expenses Included","غير مسموح بفتح الطرد")')
        .then((value) {
      print("table inserted $value");
    });
  }

  Future<Future<List<Map<String, Object?>>>?> allShipping() async {
    //علشان نكريت ريفرينس للداتا بيز بتاعتنا علشان نبدا نتعامل معاه وهتكريت اوبجيكت واحد مش اكتر من اوبجيكت
    Database? db = await createDataBase();
    return db?.rawQuery('select * from shippingDetails');
  }

  Future<Future<int>?>? deleteFromTable(int id) async {
    Database? db = await createDataBase();
    return db?.rawDelete('DELETE FROM shippingDetails WHERE id = ?'[id]);
  }
}
*/
