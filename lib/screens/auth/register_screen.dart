import 'package:database_app/database/controller/user_db_controller.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/models/user.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/provider/language_provider.dart';
import 'package:database_app/utils/context_extintion.dart';
import 'package:database_app/utils/helpers.dart';
import 'package:database_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {

  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  bool _obscure = true ;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _nameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.register_title,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black
              ),
            ),
            Text(
              AppLocalizations.of(context)!.register_subTitle,
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black45
              ),
            ),
            SizedBox(height: 20.h),
            AppTextField(
                hint: AppLocalizations.of(context)!.name,
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
                controller: _nameTextController
            ),
            SizedBox(height: 10.h,),
            AppTextField(
                hint: AppLocalizations.of(context)!.email,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: _emailTextController,
            ),
            SizedBox(height: 10.h,),
            AppTextField(
              hint: AppLocalizations.of(context)!.password,
              prefixIcon: Icons.lock,
              keyboardType: TextInputType.text,
              controller: _passwordTextController,
              obscureText: _obscure,
              sufficIcon: IconButton(
                onPressed: (){
                  setState(()=> _obscure =! _obscure);
                }, icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off
              ),
              ),
            ),
            SizedBox(height: 20.h,),
            ElevatedButton(
                onPressed: (){
                  performRegister();
                },
                child: Text(
                    AppLocalizations.of(context)!.register,
                  style: GoogleFonts.cairo(),
                ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


  void performRegister(){
    if(CheckData()){
      _register();
    }
  }

  bool CheckData(){
    if(_nameTextController.text.isNotEmpty
        &&_emailTextController.text.isNotEmpty
        && _passwordTextController.text.isNotEmpty){
      return true ;
    }
    ShowSnackBar(context , message: 'Enter requird data' , error: true);
    return false;
  }
  Future<void> _register() async {
    //TODO : Call Database register function
    ProcessResponse processResponse = await UserDbController().register(user: user) ;
    if(processResponse.success){
      Navigator.pop(context);
    }
    context.ShowSnackBar(message: processResponse.message,error: !processResponse.success);
  }

  User get user{
    User user = User();
    user.name = _nameTextController.text;
    user.email = _emailTextController.text;
    user.password = _passwordTextController.text;
    return user ;

  }

}

