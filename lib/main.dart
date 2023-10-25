import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/first_screen.dart';
import 'screens/second_screen.dart';
import 'screens/third_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _ru = Locale('ru', 'RU');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      supportedLocales: const [_ru],
      locale: _ru,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/second': (context) => const SecondScreen(),
        '/third': (context) => const ThirdScreen(),
      },
    );
  }
}

class ScreensButtons extends StatelessWidget {
  const ScreensButtons({super.key});

  static const _spacer = SizedBox(
    width: 10,
  );
  static const _activeColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: current == '/' ? _activeColor : null,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          child: const Text('Первый экран'),
        ),
        _spacer,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: current == '/second' ? _activeColor : null,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('Второй экран'),
        ),
        _spacer,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: current == '/third' ? _activeColor : null,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/third');
          },
          child: const Text('Третий экран'),
        ),
      ],
    );
  }
}

class Layout extends StatelessWidget {
  final List<Widget> children;

  const Layout({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              const ScreensButtons(),
              const SizedBox(
                height: 20,
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
