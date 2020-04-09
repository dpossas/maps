import 'package:flutter/material.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/notifier/spot_notifier.dart';
import 'package:maps/screens/login/login.screen.dart';
import 'package:maps/theme/app.theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SpotNotifier>(create: (_) => SpotNotifier()),
          Provider<PageBloc>(create: (_) => PageBloc())
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  final key = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnowmanLabs - Mobile Challenge',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: LoginScreen()
    );
  }
}
