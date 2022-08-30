import 'package:database_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();

}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          IconButton(
              onPressed: (){
                Provider.of<CartProvider>(context,listen: false).clear();
              },
              icon: Icon(Icons.delete_outline)
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context,CartProvider value ,child){
          if(value.cartItems.isNotEmpty){
           return Column(
             children: [
               Expanded(
                 child: ListView.builder(
                     itemCount: value.cartItems.length,
                     itemBuilder: (context,index){
                       return Container(
                         height: 90,
                         alignment: Alignment.center,
                         margin: EdgeInsets.symmetric(
                             horizontal: 15.w,
                             vertical: 10.h
                         ),
                         padding: EdgeInsetsDirectional.only(
                             start: 15.w,
                             end: 5.w
                         ),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               offset: Offset(0,0),
                               color: Colors.black45,
                               blurRadius: 4,
                             )
                           ],
                         ),
                         child: Stack(
                           children: [
                             PositionedDirectional(
                               end: 0,
                               top: 0,
                               child: IconButton(
                                 onPressed: (){
                                   Provider.of<CartProvider>(context,listen: false).changeQuantity(index, 0);
                                 },
                                 icon: Icon(Icons.close),
                                 color: Colors.red,
                                 visualDensity: VisualDensity(
                                     vertical: VisualDensity.minimumDensity,
                                     horizontal: VisualDensity.minimumDensity
                                 ),
                               ),
                             ),
                             Row(
                               children: [
                                 Icon(Icons.shopping_cart),
                                 SizedBox(width: 10.w,),
                                 Expanded(
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(value.cartItems[index].productName,style: GoogleFonts.cairo(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 14.sp
                                       ),),
                                       Text(
                                         'Quantity : ${value.cartItems[index].count} - Total : ${value.cartItems[index].total}',
                                         style: GoogleFonts.cairo(
                                             fontWeight: FontWeight.w300,
                                             height: 1.0,
                                             fontSize: 12.sp
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Row(
                                   children: [
                                     IconButton(
                                       onPressed: (){
                                         Provider.of<CartProvider>(context,listen: false).changeQuantity(index, value.cartItems[index].count+1);
                                       },
                                       iconSize: 20.sp,
                                       icon: Icon(Icons.add),
                                     ),
                                     IconButton(
                                       onPressed: (){
                                         Provider.of<CartProvider>(context,listen: false).changeQuantity(index, value.cartItems[index].count-1);
                                       },
                                       iconSize: 20.sp,
                                       icon: Icon(Icons.remove),
                                     ),
                                   ],
                                 ),
                               ],
                             ),

                           ],
                         ),
                       );
                     }
                 ),
               ),
               Container(
                 padding: EdgeInsets.symmetric(
                   horizontal: 15.w,
                   vertical: 20.h,
                 ),
                 color: Colors.grey.shade300,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total :',
                            style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Spacer(),
                          Text(
                            value.total.toString(),
                            style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Row(
                        children: [
                          Text(
                            'Quantity :',
                            style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Spacer(),
                          Text(
                            value.quantity.toString(),
                            style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
               ),

             ],
           );
          }else{
            return Center(
              child: Text(
                'CART IS EMPTY',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            );
          }
        }
      ),
    );
  }
}
