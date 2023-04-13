import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/config_screen.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../components/speed_dial.dart';
import 'components/home_bottom_navigator.dart';
import 'components/home_drawer.dart';
import 'components/home_tabs_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTabletOrDesktop = screenWidth >= 600;

    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("IdeaGenius"),
            actions: [
              IconButton(
                  onPressed: _visitConfigPage,
                  icon: const Icon(Icons.settings_rounded)),
              Switch(
                value: state == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ThemeChangedEvent(
                        themeMode: value ? ThemeMode.dark : ThemeMode.light,
                      ));
                },
              ),
            ],
          ),
          drawer: isTabletOrDesktop ? const HomeDrawer() : null,
          body: const HomeTabsView(),
          bottomNavigationBar:
              isTabletOrDesktop ? null : const HomeBottomNavigator(),
          floatingActionButton: const SpeedDialAddTask(),
        );
      },
    );
  }

  void _visitConfigPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const ConfigScreen(),
          );
        },
      ),
    );
  }
}
