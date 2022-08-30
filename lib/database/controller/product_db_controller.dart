import 'package:database_app/database/db_operations.dart';
import 'package:database_app/models/product.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';

class ProductsDbController extends DbOperations<Product> {
  
  
  @override
  Future<int> create(Product model) async {
      // int newRowId = await database.rawInsert('INSERT INTO product (name,info,price,quantity,user_id) VALUES (?,?,?,?,?)',
      //   [model.name , model.info,model.price,model.quantity,model.userId]
      // );
    return await database.insert(Product.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {

   // int countOfDeleteRows = await database.rawDelete('DELETE FROM products WHERE id=?',[id]);
   // return countOfDeleteRows !=0 ;

    int countOfDeleteRows = await database.delete(Product.tableName,where: 'id=?',whereArgs: [id]);
    return countOfDeleteRows !=0 ;
  }

  @override
  Future<List<Product>> read() async{
    // List<Map<String,dynamic>> rowsMap = await database.rawQuery('SELECT * FROM products');
    List<Map<String,dynamic>> rowsMap = await database.query(Product.tableName,where: 'user_id = ?',whereArgs: [SharedPrefController().getValueFor<int>(PrefKeys.id.name)]);
    return rowsMap.map((rowMap) => Product.fromMap(rowMap)).toList();
  }

  @override
  Future<Product?> show(int id) async {
    // List<Map<String,dynamic>> rowsMap = await database.rawQuery('SELECT * FROM products WHERE id=?',[id]);
    List<Map<String,dynamic>> rowsMap = await database.query(Product.tableName,where: 'id =?',whereArgs: [id]);
    if(rowsMap.isNotEmpty){
      return Product.fromMap(rowsMap.first);
    }
    return null ;
  }

  @override
  Future<bool> update(Product model) async {
    // int countOfUpdateRows =
    // await database.rawUpdate(
    //   'UPDATE products SET name=?,info=? , price =? ,quantity = ? WAHERE id =? AND user_id =?',
    //   [model.name ,model.info , model.price,model.quantity,model.userId]
    // );

    int countOfUpdateRows = await database.update(Product.tableName,model.toMap(),where: 'id=? AND user_id=?',whereArgs: [model.id , model.userId]);
    return countOfUpdateRows == 1 ;

  }

  
}