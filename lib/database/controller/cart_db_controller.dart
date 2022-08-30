import 'package:database_app/database/db_operations.dart';
import 'package:database_app/models/cart.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';

class CartDbController extends DbOperations<Cart>{

  int userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;


  @override
  Future<int> create(Cart model) async {
    // user add new for the first time to the cart
    return await database.insert(Cart.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int countOffDeletedRows = await database.delete(
        Cart.tableName,
        where: 'id = ? AND user_id = ? ',
        whereArgs: [id , userId]
    );
    return countOffDeletedRows == 1 ;
  }

  @override
  Future<List<Cart>> read() async {
    List<Map<String,dynamic>> rowsMap =
    await database.rawQuery(
        'SELECT cart.id, cart.product_id, cart.count, cart.total, cart.price, cart.user_id, products.name '
        'FROM cart JOIN products ON cart.product_id = products.id '
        'WHERE cart.user_id = ? ',[userId]);
      return rowsMap.map((rowMap) => Cart.fromMap(rowMap)).toList();
  }

  @override
  Future<Cart?> show(int id) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Cart model) async {
    int countOfUpdateRows = await database.update(
        Cart.tableName,
        model.toMap(),
        where: 'id = ? AND user_id = ?',
        whereArgs: [model.id,userId]
    );
    return countOfUpdateRows == 1 ;
  }

  @override
  Future<bool> clear() async {
    int countOfDeletedRows =
    await database.delete(Cart.tableName ,where: 'user_id = ? ' ,whereArgs: [userId]);
    return countOfDeletedRows > 0 ;
  }


}