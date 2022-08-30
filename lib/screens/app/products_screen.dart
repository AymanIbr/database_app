import 'package:database_app/models/cart.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/models/product.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/provider/cart_provider.dart';
import 'package:database_app/provider/products_provider.dart';
import 'package:database_app/screens/app/product_add_screen.dart';
import 'package:database_app/utils/context_extintion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context,listen: false).read();
    Provider.of<ProductsProvider>(context,listen: false).read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductsAddScreen(),
                  ) );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
              onPressed: (){
                // Navigator.pushReplacementNamed(context, '/login_screen');
                _confirmLogoutDialog();
              },
              icon: Icon(Icons.logout)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/cart_screen');
        },
        child: Icon(Icons.shopping_cart),
      ),
      body:Consumer<ProductsProvider>(
        builder: (context,value,child){
          if(value.products.isNotEmpty){
            return  ListView.builder(
                itemCount: value.products.length,
                itemBuilder: (context,index){
                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>ProductsAddScreen(product: value.products[index],)));
                    },
                    leading: Icon(Icons.shop),
                    title: Text(value.products[index].name),
                    subtitle: Text(value.products[index].info),
                    trailing: Column(
                      children: [
                        Expanded(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            visualDensity: VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity
                            ),
                            onPressed: ()=> _deleteProduct(index),
                            icon: Icon(Icons.delete),

                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity
                            ),
                            onPressed: (){
                              Provider.of<CartProvider>(context,listen: false).create(getCart(value.products[index]));
                            },
                            icon: Icon(Icons.shopping_cart_checkout_sharp),

                          ),
                        ),
                      ],
                    ),
                  );
                }
            );
          }else {
           return Center (child: Text(
                'NO DATA',
              style: GoogleFonts.cairo(
                fontSize: 24.sp,
                color: Colors.black45,
                fontWeight: FontWeight.bold
              ),
            ),);
          }
        }
      ),
    );
  }

  Cart getCart(Product product){
    Cart cart = Cart();
    cart.productId = product.id;
    cart.price = product.price;
    cart.total = product.price;
    cart.userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;
    cart.count = 1 ;
    cart.productName = product.name;
    return cart ;
  }

  void _confirmLogoutDialog() async{
   bool? result = await showDialog<bool>(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.title_dialog , style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.black
            ),),
            content: Text(AppLocalizations.of(context)!.content_dialog,style: GoogleFonts.cairo(
              fontSize: 12,
              color: Colors.black45
            ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context,true);
              },
                  child: Text(AppLocalizations.of(context)!.confirm,style: GoogleFonts.cairo(color: Colors.red),)
              ),
              TextButton(onPressed: (){
                Navigator.pop(context,false);
              },
                  child: Text(AppLocalizations.of(context)!.cancele,style: GoogleFonts.cairo(),)
              ),
            ],
          );
        }
    );
   if(result ?? false) {
     bool cleared = await SharedPrefController().removeValueFor(PrefKeys.loggedIn.name);
     if(cleared){
       Navigator.pushReplacementNamed(context, '/login_screen');
     }
   }
  }
  void _deleteProduct (int index) async {
    ProcessResponse processResponse = await Provider.of<ProductsProvider>(context,listen: false).delete(index);
    context.ShowSnackBar(message: processResponse.message,
      error: !processResponse.success
      );
  }
}
