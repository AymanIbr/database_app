import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


extension ContextHelper on BuildContext{
  void ShowSnackBar({required String message , bool error = false}){
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message , style: GoogleFonts.cairo(),),
          backgroundColor: error ? Colors.red.shade700 : Colors.blue.shade300,
          duration: Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
        )
    );
  }
  AppLocalizations get localization{
    return AppLocalizations.of(this)!;
  }


}