import 'package:flutter/widgets.dart';

import 'appointment_book.dart';
import 'chat_log.dart';

/// Hands the app-wide state objects down the tree. Widgets that need to
/// react to changes wrap themselves in a [ListenableBuilder].
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.appointments,
    required this.chats,
    required super.child,
  });

  final AppointmentBook appointments;
  final ChatLog chats;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope above this widget.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      appointments != oldWidget.appointments || chats != oldWidget.chats;
}
