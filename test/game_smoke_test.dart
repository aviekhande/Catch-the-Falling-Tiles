import 'package:catch_the_falling_tiles/app.dart';
import 'package:catch_the_falling_tiles/core/constants/app_strings.dart';
import 'package:catch_the_falling_tiles/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  testWidgets('shows the start screen with a Start button', (tester) async {
    await tester.pumpWidget(const CatchTheFallingTilesApp());

    // Let the FlameGame finish its async onLoad and attach the start overlay.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(AppStrings.gameTitle), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, AppStrings.startButton), findsOneWidget);
  });
}
