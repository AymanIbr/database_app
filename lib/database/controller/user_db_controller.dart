import 'package:database_app/database/db_controller.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/models/user.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:sqflite/sqflite.dart';


class UserDbController {


 final Database _database = DbController().database;

 Future<ProcessResponse> login ({required String email , required String password}) async{

  List<Map<String,dynamic>> rowMap = await _database.query(User.tableName,
      where: 'email =? AND password =?',
      whereArgs: [email,password]
  );
  if(rowMap.isNotEmpty){
   User user = User.fromMap(rowMap.first);
   SharedPrefController().save(user:user);
   return ProcessResponse(message: 'Logged in Successfuly',success: true);
  }
  return ProcessResponse(message: 'Credentials error , check and try again !');
 }

 Future<ProcessResponse> register ({required User user }) async {

  // int newRowId = await _database.rawInsert('INSERT INTO users (name , email , password) VALUES (?,?,?)',
  //  [user.name,user.email,user.password]
  // );.

  if(await _isEmailExist(email: user.email)){
   int newRowId = await _database.insert(User.tableName, user.toMap());
   return ProcessResponse(message: newRowId != 0 ? 'Registered Successfuly' : 'Register failed',success: newRowId !=0);
  }else {
   return ProcessResponse(message: 'Email exist , use another',
       success: false
   );
  }
 }

 Future <bool> _isEmailExist ({required String email}) async {
  List<Map<String,dynamic>> rowsMap = await _database.rawQuery('SELECT * FROM users WHERE email = ? ',[email]);
  return rowsMap.isEmpty;
 }

}
// LOGIN  REGISTER




/**
 * SQL :
 * 1) Create => INSERT SQL
 *   => INSERT INTO tableName (c1,c2,c3) VALUES (v1,v2,v3);
 *
 *   2) READ => SELECT SQL
 *      => SELECT * FROM tableName
 *      => SELECT * FROM tableName WHERE c1 = value
 *      => SELECT * FROM tableName WHERE c1 = value AND c2 = value
 *      => SELECT * FROM tableName WHERE c1 = value OR c2 = value
 *
 *      3) UPDATE => UPDATE SQL
 *         => UPDATE tableName SET c1 = v1
 *         =>UPDATE tableName SET c1 = value WHERE c2 = v2
 *         =>UPDATE tableName SET c1 = v1 , c2 = v2 ,c3 = v3 WHERE c4 = v4
 *
 *         4) DELETE => DELETE SQL
 *             => DELETE from tableName
 *             =>DELETE from tableName  WHERE c1 = v1
 *
 *             -------------------
 *         *) DROP => DROP TABLE tableName
 *         *)ALTER
 *            1) ADD COLUMN : ALTER TABLE tableName ADD columnName VARCHAR(45) NOT NULL AFTER ID;
 *
 *            -------------------
 *            ADD FOREIGN KEY (user_id) references users(id) on Delete cascade null restrict
 *
 *
 *
 */
