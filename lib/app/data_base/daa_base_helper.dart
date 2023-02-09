import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   late Database dataBase;
//   static const String tableName = "movies";
//   // static const String id = "id";
//   // static const String taskId = "taskId";
//   // static const String progress = "progress";
//
//   Future<Database> createDataBase(String tableName, List<String> fields) async {
//     var dataPath = await getDatabasesPath();
//     String path = join(dataPath, "movies.db");
//     dataBase = await openDatabase(path);
//     var fieldStr = fields.join(",");
//     await dataBase.execute(
//         "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY,$fieldStr)");
//     return dataBase;
//   }
//
//   Future<int> insertData(Map<String, dynamic> data, String tableName, List<String> fields) async {
//     dataBase = await createDataBase("movies", ["id" , "taskId" , "progress"]);
//     return await dataBase.insert(tableName, data);
//   }
//
//   Future<List<Map<String, dynamic>>> getAllDownloadHistory() async {
//     dataBase = await createDataBase("movies", ["id" , "taskId" , "progress"]);
//     return await dataBase.query(tableName, columns: [
//       "id",
//       "taskId",
//       "progress"
//     ]);
//   }
//
//   Future<int> updateData(Map<String, dynamic> data, int id) async {
//     dataBase = await createDataBase();
//     return await dataBase
//         .update(tableName, data, where: "id=?", whereArgs: [id]);
//   }
//
//   Future<int> deleteData(int id) async {
//     dataBase = await createDataBase();
//     return await dataBase.delete(tableName, where: "id=?", whereArgs: [id]);
//   }
//
//   Future<int> deleteAll() async {
//     dataBase = await createDataBase();
//     return await dataBase.rawDelete("DELETE FROM $tableName");
//   }
// }


// Future<int> insertData(Map<String, dynamic> data) async {
//   return _insertDBData(data, tableName, fields);
// }
//
// Future<int> _insertDBData(Map<String, dynamic> data, String tableName, List<String> fields) async {
//   var dataBase = await DatabaseHelper().createDataBase(tableName, fields);
//   return await dataBase.insert(tableName, data);
// }