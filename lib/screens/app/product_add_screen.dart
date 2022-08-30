import 'package:database_app/models/process_response.dart';
import 'package:database_app/models/product.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/provider/products_provider.dart';
import 'package:database_app/utils/context_extintion.dart';
import 'package:database_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsAddScreen extends StatefulWidget {
  const ProductsAddScreen({Key? key,this.product}) : super(key: key);

  final Product? product ;

  @override
  State<ProductsAddScreen> createState() => _ProductsAddScreenState();
}

class _ProductsAddScreenState extends State<ProductsAddScreen> {

  late TextEditingController  _nameTextController;
  late TextEditingController  _infoTextController;
  late TextEditingController _priceTextController;
  late TextEditingController  _quantityTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTextController = TextEditingController(text: widget.product?.name);
    _infoTextController = TextEditingController(text: widget.product?.info);
    _priceTextController = TextEditingController(text: widget.product?.price.toString());
    _quantityTextController = TextEditingController(text: widget.product?.quantity.toString());
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _infoTextController.dispose();
    _priceTextController.dispose();
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
        children: [
          Text(
              title,
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 20.h,),
          AppTextField(
              hint: context.localization.name,
              prefixIcon: Icons.title,
              keyboardType: TextInputType.text
              , controller: _nameTextController,
          ),
          SizedBox(height: 10.h,),
          AppTextField(
            hint: context.localization.info,
            prefixIcon: Icons.info,
            keyboardType: TextInputType.name
            , controller: _infoTextController,
          ),
          SizedBox(height: 10.h,),
         Row(
           children: [
             Expanded(
               child: AppTextField(
                 hint: context.localization.price,
                 prefixIcon: Icons.price_change,
                 keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true)
                 , controller: _priceTextController,
               ),
             ),
             SizedBox(width: 10.w,),
             Expanded(
               child:AppTextField(
               hint: context.localization.quantity,
               prefixIcon: Icons.price_change,
               keyboardType: TextInputType.numberWithOptions()
               , controller: _quantityTextController,
             ),
             ),
           ],
         ),
          SizedBox(height: 20.h,),
          ElevatedButton(
              onPressed: () => _performSave(),
              child: Text(context.localization.save)
          ),
        ],
      ),
    );
  }

  bool get isUpdateProduct => widget.product != null ;
  String get title => isUpdateProduct
      ? context.localization.update_product
      : context.localization.add_new_product;



  void _performSave(){
    if(_checkData()){
      _save();
    }
  }
  bool _checkData(){
    if(_nameTextController.text.isNotEmpty
        &&_infoTextController.text.isNotEmpty
        && _priceTextController.text.isNotEmpty
        &&_quantityTextController.text.isNotEmpty){
      return true;
    }
    context.ShowSnackBar(message: context.localization.error_data,error: true);
    return false;
  }

  Future<void> _save() async {
    //TODO : CALL DATABASE SAVE FUNCTION FROM ProductsProvider as (Intermidiate) UI AND CONTROLLER
    ProcessResponse processResponse = isUpdateProduct
    ? await Provider.of<ProductsProvider>(context,listen: false).update(product)
    : await Provider.of<ProductsProvider>(context,listen: false).create(product);
    context.ShowSnackBar(
        message:processResponse.message,
      error: !processResponse.success
    );
    if(processResponse.success){
      isUpdateProduct ? Navigator.pop(context)
      : clear();
    }
  }
  void clear(){
    _nameTextController.clear();
    _infoTextController.clear();
    _priceTextController.clear();
    _quantityTextController.clear();
  }
  Product get product {
    Product product =isUpdateProduct ? widget.product! : Product();
    product.name = _nameTextController.text;
    product.info = _infoTextController.text;
    product.price = double.parse(_priceTextController.text) ;
    product.quantity = int.parse(_quantityTextController.text) ;
    product.userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;
    return product ;
  }
}
