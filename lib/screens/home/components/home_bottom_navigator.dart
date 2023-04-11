import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/tabs/tabs_bloc.dart';

class HomeBottomNavigator extends StatelessWidget {
  const HomeBottomNavigator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, int>(
      builder: (context, currentIndex) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) =>
              context.read<TabsBloc>().add(TabsChangeEvent(index: value)),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded),
              label: "Todo",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: "Settings",
            ),
          ],
        );
      },
    );
  }
}
