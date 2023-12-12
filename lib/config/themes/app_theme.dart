import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:flutter/material.dart';

class PowerModeTheme {
  PowerModeTheme._();

  static const double dropShadowOpacity = 0.2;

  static Color barrier = Colors.white;
  static Color background = const Color(0xFFFAFAFA);
  static Color borderColor = const Color(0xFFFFFFFF);
  static Color searchFieldColor = const Color(0xFFF4F5F6);
  static Color searchFieldBorderColor =
      const Color(0xFF9A9996).withOpacity(0.5);
  static Color searchFieldBorderEnabledColor =
      const Color(0xFF00A6CB).withOpacity(0.5);
  static Color searchFieldHintColor = const Color(0xFF5E5C64);
  static Color dateFilterTextColor = const Color(0xFF565656);
  static Color dateFilterHoverBackgroundColor = const Color(0xffe7e7e6);
  static Color activeImageFilterBackgroundColor = const Color(0xffCFE4F4);
  static Color activeImageFilterTextColor = const Color(0xff228CDA);
  static Color inActiveImageFilterBackgroundColor = const Color(0xffe7e7e6);
  static Color inActiveImageFilterTextColor = const Color(0xff2e2e2e);
  static Color cardDropShadowColor = const Color(0xFFD3D3D3).withOpacity(0.60);
  static Color imageCardDropShadowColor = Colors.blue.withOpacity(0.60);
  static Color cardBorderColor = Colors.black.withOpacity(0.20);
  static Color panelBackgroundColor = const Color(0xffFFFFFF);
  static Color panelTopBarColor = const Color(0xffF2F2F2);
  static Color collectionCardColor = const Color(0xffF4f4f4);
  static Color collectionCardDropShadowColor = Colors.grey.withOpacity(0.60);

  static void init() {
    // if (getSystemTheme() == 'dark') {}
  }
}

class AppTheme {
  AppTheme._();

  static Color background = Colors.white;
  static Color foreground = Colors.black;
  static Color foreground2 = const Color(0xFF2E2E2E);
  static Color windowDropShadowColor = Colors.black.withOpacity(0.25);
  static Color topBarDropShadowColor = Colors.black.withOpacity(0.10);
  static Color buttonSurfaceColor = const Color(0xFF7E7C77).withOpacity(0.25);
  static Color integrateButtonSurfaceColor =
      const Color(0xFF2E3CDD).withOpacity(0.25);
  static Color activeRouteColor = Colors.blue;
  static Color tooltipBackgroundColor = Colors.white;
  static Color tooltipBorderColor = Colors.yellow;
  static Color closeButtonSurfaceColor = const Color(0xFFF04949);
  static Color hintColor = const Color(0xFF676767);
  static Color enabledBorderColor = Colors.blueAccent;
  static Color focusedBorderColor = Colors.green;
  static Color barrierColor = const Color(0xFFD9D9D9).withOpacity(0.40);
  static Color imageFilterBackgroundColor = const Color(0xFFC8E9F0);
  static Color videoFilterBackgroundColor = const Color(0xFFC8D6F0);
  static Color audioFilterBackgroundColor = const Color(0xFFF0C8DB);
  static Color filesFilterBackgroundColor = const Color(0xFFE8F0C8);
  static Color imageFilterForegroundColor = const Color(0xFF10717E);
  static Color videoFilterForegroundColor = const Color(0xFF10357E);
  static Color audioFilterForegroundColor = const Color(0xFF7E106D);
  static Color filesFilterForegroundColor = const Color(0xFF547E10);
  static Color filterDialogCloseButtonColor = const Color(0xFF363636);
  static Color filterActiveColor = const Color(0xFF139FCB).withOpacity(0.25);
  static Color tileUpperDropShadowColor =
      const Color(0xFFD9D9D9).withOpacity(0.25);
  static Color tileLowerDropShadowColor =
      const Color(0xFFD9D9D9).withOpacity(0.50);
  static Color copyButtonColor = const Color(0xFFD9D9D9);
  static Color commandTileColor = const Color(0xFFF0F0F0);
  static Color commandTileCopyButtonColor = const Color(0xFFA9A9A9);
  static Color selectedCategoryBackgroundColor = const Color(0xFF339DFF);
  static Color infoCardUpperDropShadowColor =
      const Color(0xFFD9D9D9).withOpacity(0.20);
  static Color infoCardLowerDropShadowColor =
      const Color(0xFFD3D3D3).withOpacity(0.40);
  static Color messageBirdColor = Colors.blue.shade700;
  static Color messageBirdErrorColor = Colors.red.shade700;
  static Color messageBirdWarningColor = Colors.orange.shade700;

  static Color exclusionTileNameBackgroundColor = const Color(0xFFdeddda);
  static Color exclusionTileNameForegroundColor = const Color(0xFF3d3846);
  static Color exclusionTilePatternBackgroundColor = const Color(0xFFf6f5f4);
  static Color exclusionTilePatternForegroundColor = const Color(0xFF3d3846);

  // static ThemeMode get mode =>
  //     getSystemTheme() == 'dark' ? ThemeMode.dark : ThemeMode.light;

  static ThemeMode get mode => ThemeMode.light;

  static void init() {
    // if (getSystemTheme() == 'dark') {}
  }

  static TextStyle get fontBold => TextStyle(
        fontFamily: "Sen",
        fontWeight: FontWeight.bold,
        color: foreground,
      );

  static TextStyle get fontExtraBold => TextStyle(
        fontFamily: "Sen",
        fontWeight: FontWeight.w900,
        color: foreground,
      );

  static TextStyle fontSize(double size) => TextStyle(
        fontFamily: "Sen",
        fontSize: size,
        color: foreground,
      );
}

extension ConfigurableTextStyle on TextStyle {
  TextStyle withColor(Color color) {
    return copyWith(
      color: color,
    );
  }

  TextStyle makeBold() {
    return copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle makeItalic() {
    return copyWith(
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle makeExtraBold() {
    return copyWith(
      fontWeight: FontWeight.w900,
    );
  }

  TextStyle makeMedium() {
    return copyWith(
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle fontSize(double size) {
    return copyWith(
      fontSize: size,
    );
  }
}

extension ThemeConfigurator on JsonConfigurator {
  Color getColor(key) {
    return HexColor.from(get(key));
  }
}

extension HexColor on Color {
  static Color from(String hexColor) {
    hexColor = hexColor.replaceAll("0x", "");
    hexColor = hexColor.replaceAll("#", "");
    hexColor = hexColor.toUpperCase();
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
