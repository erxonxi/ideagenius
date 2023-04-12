import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/home/views/summary_view.dart';
import '../../../blocs/tabs/tabs_bloc.dart';
import '../views/home_view.dart';
import '../views/todoes_view.dart';

class HomeTabsView extends StatelessWidget {
  const HomeTabsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, int>(
      builder: (context, currentIndex) {
        return IndexedStack(
          index: currentIndex,
          children: const [HomeView(), ToDoesView(), SummaryView()],
        );
      },
    );
  }
}
