import 'package:flutter/material.dart';

abstract class SaleDimens {
  static double width(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return SaleDimensMobile.maxWidth;
    } else if (screenWidth < 1200) {
      return SaleDimensTablet.maxWidth;
    } else {
      return SaleDimensDesktop.maxWidth;
    }
  }

  static double buttonWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return double.infinity;
    } else if (screenWidth < 1200) {
      return screenWidth * 0.5;
    } else {
      return screenWidth * 0.33;
    }
  }
}

class SaleDimensMobile extends SaleDimens {
  static double maxWidth = double.infinity;
}

class SaleDimensTablet extends SaleDimens {
  static double maxWidth = 800;
}

class SaleDimensDesktop extends SaleDimens {
  static double maxWidth = 1100;
}
