import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryBackground,
        height: 60.0,
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,

        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home,
                color: selectedIndex == 0
                    ? Colors.white
                    : Colors
                        .black), // Использовать белый цвет для выбранной иконки
            label: 'Главная',
            selectedIcon:
                const Icon(Icons.home, color: Colors.white), // Выбранная иконка
          ),
          NavigationDestination(
            icon: Icon(Icons.settings,
                color: selectedIndex == 1
                    ? Colors.white
                    : Colors
                        .black), // Использовать белый цвет для выбранной иконки
            label: 'Настройки',
            selectedIcon: const Icon(Icons.settings,
                color: Colors.white), // Выбранная иконка
          ),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.primaryBackground,
            labelType: NavigationRailLabelType.none, // No labels
            selectedIndex: selectedIndex,
            indicatorColor: Colors.white,
            onDestinationSelected: onDestinationSelected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home,
                    color: selectedIndex == 0
                        ? Colors.black
                        : Colors
                            .white), // Использовать белый цвет для выбранной иконки
                label: const Text('Главная'), // Empty label
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings,
                    color: selectedIndex == 1
                        ? Colors.black
                        : Colors
                            .white), // Использовать белый цвет для выбранной иконки
                label: const Text('Настройки'), // Empty label
              ),
            ],
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: AppColors.primaryLightGray,
          ),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
