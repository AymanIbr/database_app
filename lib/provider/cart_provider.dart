import 'package:database_app/database/controller/cart_db_controller.dart';
import 'package:database_app/models/cart.dart';
import 'package:database_app/models/process_response.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {

  List<Cart> cartItems = <Cart> [];


  final CartDbController _dbController = CartDbController();
  double total = 0 ;
  double quantity = 0 ;

  Future<ProcessResponse> create (Cart cart) async {
    int index = cartItems.indexWhere((element) => element.productId == cart.productId);
    int newRowId = await _dbController.create(cart);
    if(index == -1 ){
      if(newRowId != 0 ){
        total += cart.total;
        quantity += 1 ;
        cart.id = newRowId ;
        cartItems.add(cart);
        notifyListeners();
      }
      return getResponse(newRowId != 0 ) ;
    }else {
      int newCount = cartItems[index].count + 1 ;
      return changeQuantity(index, newCount);
    }
  }

  void read()async {
    cartItems = await _dbController.read();
    for(Cart cart in cartItems){
      total += cart.total;
      quantity +=  1 ;
    }
    notifyListeners();
  }

  Future<ProcessResponse> changeQuantity (int index , int count) async {
    bool isDelete = count == 0 ;
    Cart cart = cartItems[index];
    bool result = isDelete
        ? await _dbController.delete(cart.id)
        : await _dbController.update(cart);
    if(result){
      if(isDelete){
        total -= cart.total;
        quantity -= 1 ;
        cartItems.removeAt(index);
      }else {
        cart.count = count ;
        cart.total = cart.price * cart.count;
        total += cart.total;
        quantity += 1 ;
        cartItems[index]  = cart ;
      }
      notifyListeners();
    }
    return getResponse(result);
  }

  Future<ProcessResponse> clear() async {
    bool cleared = await _dbController.clear();
    if(cleared){
      total = 0 ;
      quantity = 0 ;
      cartItems.clear();
      notifyListeners();
    }
    return getResponse(cleared);
  }



  ProcessResponse getResponse (bool success){
    return ProcessResponse(
      message: success ? 'Operation complted successfuly': 'Operation failed',
      success : success ,
    );
  }
}