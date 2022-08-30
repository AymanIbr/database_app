import 'package:database_app/database/controller/product_db_controller.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> products = <Product>[];
  ProductsDbController _dbController = ProductsDbController();
  Future<ProcessResponse> create (Product product) async {
    int newRowId = await _dbController.create(product);
    if(newRowId != 0){
      product.id = newRowId ;
      products.add(product);
      notifyListeners();
    }
    return getResponse(newRowId != 0);
  }

  void read () async {
    products = await _dbController.read();
    notifyListeners();
  }

  Future<ProcessResponse> update (Product product)async{
    bool update = await _dbController.update(product);
    if(update){
      int index = products.indexWhere((element) => element.id == product.id);
      if(index != -1 ){
        products[index] = product;
        notifyListeners();
      }
    }
    return getResponse(update);
  }

  Future<ProcessResponse> delete (int index)async{
    bool delete = await _dbController.delete(products[index].id);
    if(delete){
      products.removeAt(index);
      notifyListeners();
    }
    return getResponse(delete);
  }



  ProcessResponse getResponse (bool success){
    return ProcessResponse(
      message: success ? 'Operation complted successfuly': 'Operation failed',
      success : success ,
    );
  }

}