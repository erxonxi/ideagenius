import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/tabs/tabs_bloc.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, int>(
      builder: (context, tabIndex) {
        const textStyle =
            TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);
        return Drawer(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      "IdeaGenius",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                    title: const Text("Home", style: textStyle),
                    onTap: () => _onTap(context, 0)),
                ListTile(
                    title: const Text("Todoes", style: textStyle),
                    onTap: () => _onTap(context, 1)),
                ListTile(
                    title: const Text("Summary", style: textStyle),
                    onTap: () => _onTap(context, 2)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTap(BuildContext context, int index) {
    context.read<TabsBloc>().add(TabsChangeEvent(index: index));
  }
}
