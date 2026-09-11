import 'dart:math';
import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_dimens.dart';
import 'core/theme/app_theme.dart';
import 'features/game/presentation/screens/game_screen.dart';

class ScreenUtil {
  ScreenUtil._();

  static double _scaleWidth = 1.0;
  static double _scaleHeight = 1.0;
  static double _scale = 1.0;

  static void init(BuildContext context) {
    final mediaQuerySize = MediaQuery.maybeSizeOf(context);
    final size = mediaQuerySize ?? View.maybeOf(context)?.physicalSize;
    final ratio = mediaQuerySize != null
        ? 1.0
        : (View.maybeOf(context)?.devicePixelRatio ?? 1.0);

    if (size != null && size.width > 0) {
      final logicalWidth = size.width / ratio;
      final logicalHeight = size.height / ratio;
      _scaleWidth = logicalWidth / AppDimens.appDesignWidth;
      _scaleHeight = logicalHeight / AppDimens.appDesignHeight;
      _scale = min(_scaleWidth, _scaleHeight);
    }
  }

  static double setWidth(num width) => width * _scaleWidth;
  static double setHeight(num height) => height * _scaleHeight;
  static double radius(num r) => r * _scale;
  static double setSp(num sp) => sp * _scale;
}

extension ScreenUtilsExtension on num {
  double get w => ScreenUtil.setWidth(this);
  double get h => ScreenUtil.setHeight(this);
  double get r => ScreenUtil.radius(this);
  double get sp => ScreenUtil.setSp(this);
}

class ScreenUtilInit extends StatelessWidget {
  const ScreenUtilInit({super.key, required this.builder});

  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return builder(context, null);
  }
}

class CatchTheFallingTilesApp extends StatelessWidget {
  const CatchTheFallingTilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, _) {
        return MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const GameScreen(),
        );
      },
    );
  }
}
