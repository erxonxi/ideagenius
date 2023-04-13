import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideagenis/blocs/notes/notes_bloc.dart';
import 'package:ideagenis/screens/login_screen.dart';

import 'blocs/tabs/tabs_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'screens/create_note_screen.dart';
import 'screens/home/home_screen.dart';
import 'theme/theme_consts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAppStates(
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'IdeaGenius',
            home: const LoginScreen(),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                theme == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routes: {
              "/create-note": (context) => const CreateNoteScreen(),
            },
          );
        },
      ),
    );
  }
}

class MyAppStates extends StatefulWidget {
  final Widget child;

  const MyAppStates({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppStatesState createState() => _MyAppStatesState();
}

class _MyAppStatesState extends State<MyAppStates> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
      ),
      BlocProvider<TabsBloc>(
        create: (_) => TabsBloc(),
      ),
      BlocProvider(create: (_) => NotesBloc()),
    ], child: widget.child);
  }
}
