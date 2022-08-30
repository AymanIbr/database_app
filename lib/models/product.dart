class Product {
  late int id;
  late String name;
  late String info ;
  late double price;
  late int quantity;
  late int userId;

  static const String tableName = 'products';

  Product();
  Product.fromMap(Map<String,dynamic>rowMapp){
    id = rowMapp['id'];
    name = rowMapp['name'];
    info = rowMapp['info'];
    price = rowMapp['price'];
    quantity =rowMapp['quantity'];
    userId = rowMapp['user_id'];
  }

  Map<String,dynamic>toMap(){
    Map<String,dynamic>map = <String,dynamic>{};
    map['name'] = name;
    map['info'] = info;
    map['price'] = price ;
    map['quantity'] = quantity;
    map['user_id'] = userId;
    return map;
  }

}