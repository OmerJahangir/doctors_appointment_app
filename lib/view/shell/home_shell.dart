import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../res/app_theme.dart';
import '../account/account_screen.dart';
import '../appointments/appointments_screen.dart';
import '../home/home_screen.dart';
import '../messages/messages_screen.dart';

/// The four main tabs behind the curved bottom bar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _tabs = [
    (Icons.home_rounded, 'Home'),
    (Icons.calendar_month_rounded, 'Appointments'),
    (Icons.chat_bubble_rounded, 'Messages'),
    (Icons.account_circle_rounded, 'Profile'),
  ];

  late int _index = widget.initialTab;

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          AppointmentsScreen(onFindDoctor: () => _select(0)),
          const MessagesScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurvedNavigationBar(
            index: _index,
            height: 64,
            color: AppColors.surface,
            buttonBackgroundColor: AppColors.primary,
            backgroundColor: AppColors.background,
            animationDuration: MediaQuery.disableAnimationsOf(context)
                ? const Duration(milliseconds: 1)
                : const Duration(milliseconds: 400),
            onTap: _select,
            items: [
              for (final (i, (icon, label)) in _tabs.indexed)
                Semantics(
                  key: ValueKey(label),
                  label: label,
                  selected: i == _index,
                  button: true,
                  excludeSemantics: true,
                  child: Icon(
                    icon,
                    size: 28,
                    color: i == _index ? Colors.white : AppColors.textMuted,
                  ),
                ),
            ],
          ),
          ColoredBox(
            color: AppColors.surface,
            child: SizedBox(
              height: MediaQuery.paddingOf(context).bottom,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
