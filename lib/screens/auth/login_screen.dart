import 'package:database_app/database/controller/user_db_controller.dart';
import 'package:database_app/models/process_response.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  bool _obscure = true ;
  late String _language;

  @override
  void initState() {
    super.initState();
    _language = SharedPrefController().getValueFor(PrefKeys.language.name) ?? 'en';
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login_name),
        actions: [
          IconButton(onPressed: (){
            _showLanguageSheet();
          }, icon: Icon(Icons.language))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.login_title,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black
              ),
            ),
            Text(
              AppLocalizations.of(context)!.login_subtitle,
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black45
              ),
            ),
            SizedBox(height: 20.h),
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
                  performLogin();
                },
                child: Text(
                    AppLocalizations.of(context)!.login_name,
                  style: GoogleFonts.cairo(),
                ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.new_account),
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/register_screen');
                    },
                    child: Text(AppLocalizations.of(context)!.create_account),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void _showLanguageSheet() async{
  String? langCode = await showModalBottomSheet<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        ),
      ),
        clipBehavior: Clip.antiAlias,
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context , setState){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context)!.change_language,style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                      ),

                      Text(AppLocalizations.of(context)!.choose_sutable_language,style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        height: 1.0.h,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                      ),
                      Divider(),
                      RadioListTile<String>(
                          value: 'en',
                          title: Text('English',style: GoogleFonts.cairo(),),
                          groupValue: _language,
                          onChanged: (String? value){
                            if(value != null){
                              setState(()=> _language = value);
                              Navigator.pop(context,'en');
                            }
                          }
                      ),
                      RadioListTile<String>(
                          value: 'ar',
                          title: Text('العربية',style: GoogleFonts.cairo(),),
                          groupValue: _language,
                          onChanged: (String? value){
                            if(value != null){
                              setState(()=> _language = value);
                              Navigator.pop(context,'ar');
                            }
                          }
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );

  if (langCode != null){
    Future.delayed(Duration(milliseconds: 500),(){
      Provider.of<LanguageProvider>(context,listen: false).ChangeLanguage();
    });
  }

  }

  void performLogin(){
    if(CheckData()){
      _login();
    }
  }

  bool CheckData(){
    if(_emailTextController.text.isNotEmpty && _passwordTextController.text.isNotEmpty){
      return true ;
    }
    ShowSnackBar(context , message: 'Enter requird data' , error: true);
    return false;
  }
  void _login() async {
    ProcessResponse processResponse = await UserDbController().login(
        email: _emailTextController.text,
        password: _passwordTextController.text
    );
    if(processResponse.success){
      Navigator.pushReplacementNamed(context, '/product_screen');
    }
    context.ShowSnackBar(message: processResponse.message,error: !processResponse.success);
  }

}

