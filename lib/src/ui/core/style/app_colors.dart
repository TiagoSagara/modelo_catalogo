import 'package:flutter/material.dart';

// Imagens padrão

const produtoImagemPadrao = "";
const pessoaImagemPadrao = "";

//

const grandisExtendedFont = "Grandis Extended";

const Color azulPadrao = Color(0xFF227F8E);
const Color verdePadrao = Color(0xFF25BF3D);

const MaterialColor materialAzul = MaterialColor(0xFF227F8E, <int, Color>{
  50: Color(0xFFE3F3F5),
  100: Color(0xFFB8E1E5),
  200: Color(0xFF88CDD4),
  300: Color(0xFF57B9C3),
  400: Color(0xFF35A9B5),
  500: Color(0xFF227F8E), // cor base
  600: Color(0xFF207786),
  700: Color(0xFF1B6C77),
  800: Color(0xFF176069),
  900: Color(0xFF0F4C52),
});

const MaterialColor materialVerde = MaterialColor(0xFF25BF3D, <int, Color>{
  50: Color(0xFFE4F7E7),
  100: Color(0xFFBAEBC2),
  200: Color(0xFF8CE097),
  300: Color(0xFF5ED46B),
  400: Color(0xFF3FCB51),
  500: Color(0xFF25BF3D), // cor base
  600: Color(0xFF21B837),
  700: Color(0xFF1CB030),
  800: Color(0xFF17A829),
  900: Color(0xFF0D971B),
});

const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color blackColor60 = Color(0xFF737378);
const Color blackColor40 = Color(0xFFA2A2A5);
const Color blackColor20 = Color(0xFFD0D0D2);
const Color blackColor10 = Color(0xFFE8E8E9);
const Color blackColor5 = Color(0xFFF3F3F4);

const Color whiteColor = Colors.white;
const Color whileColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

const Color greyColor = Color(0xFFB8B5C3);
const Color lightGreyColor = Color(0xFFF8F8F9);
const Color darkGreyColor = Color(0xFF1C1C25);

const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

abstract final class AppColors {
  static const primary = Color(0xFF1D1E3C);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF4D647F);
  static const onSecondary = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1A1C1E);
  static const error = Color(0xFFB3261E);
  static const onError = Color(0xFFFFFFFF);
  static const neutral500 = Color(0xFF00204D);
  static const neutral400 = Color(0xFF42699F);
  static const success = Color(0xFF0C8C10);
  static const warning = Color(0xFFD8610C);
  static const fieldLabel = Color(0xFF575757);
  static const field = Color(0xFF000000);
  static const requiredField = Color(0xFFB3261E);
  static const formTitle = Color(0xFF1F2A3B);
  static const inputBorder = Color(0xFFc9d3dd);
  static const background = Color(0xFFEFEFEF); //Color(0xfff5f5f5);
  static const tableHeader = Color(0xff575757);
}
