import 'package:flutter/material.dart';

import '../../model/appointment.dart';
import '../../model/doctor.dart';
import '../../res/app_theme.dart';
import '../../utils/date_format.dart';
import '../../utils/schedule.dart';
import '../../view_model/app_scope.dart';
import '../common_widget/doctor_card.dart';
import '../common_widget/primary_button.dart';
import 'booked_sheet.dart';

/// Pick a day and a time slot, then book.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.doctor, this.initialDay});

  final Doctor doctor;
  final DateTime? initialDay;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  /// How far ahead appointments can be booked.
  static const _bookingWindowDays = 60;

  late DateTime _firstDay;
  late DateTime _day;
  DateTime? _slot;
  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;
    final now = AppScope.of(context).appointments.now();
    _firstDay = upcomingWorkingDays(now, 1).first;
    final initial = widget.initialDay;
    _day = initial != null && !initial.isBefore(_firstDay)
        ? dateOnly(initial)
        : _firstDay;
  }

  void _book() {
    final slot = _slot;
    if (slot == null) return;
    final book = AppScope.of(context).appointments;
    final result = book.book(widget.doctor, slot);
    switch (result) {
      case BookingResult.booked:
        showBookedSheet(
          context,
          Appointment(doctor: widget.doctor, start: slot),
        ).then((_) {
          if (mounted) Navigator.of(context).pop();
        });
      case BookingResult.slotTaken || BookingResult.inPast:
        setState(() => _slot = null);
        _showError('That time is no longer available. Please pick another.');
      case BookingResult.clash:
        _showError(
          'You already have an appointment at ${formatTime(slot)} on '
          '${formatDay(slot)}.',
        );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final book = AppScope.of(context).appointments;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: ListenableBuilder(
        listenable: book,
        builder: (context, _) {
          final slots = slotsOn(_day);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Row(
                children: [
                  DoctorAvatar(doctor: widget.doctor, radius: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.doctor.name, style: textTheme.titleMedium),
                        Text(
                          widget.doctor.title,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: CalendarDatePicker(
                  key: const ValueKey('calendar'),
                  initialDate: _day,
                  firstDate: _firstDay,
                  lastDate: _firstDay.add(
                    const Duration(days: _bookingWindowDays),
                  ),
                  selectableDayPredicate: isWorkingDay,
                  onDateChanged: (day) => setState(() {
                    _day = day;
                    _slot = null;
                  }),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Clinics are closed on Sundays.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Text('Time', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.1,
                children: [
                  for (final slot in slots)
                    _SlotTile(
                      time: slot,
                      selected: slot == _slot,
                      available: book.isAvailable(widget.doctor, slot),
                      onTap: () => setState(() => _slot = slot),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: _slot == null
                    ? 'Pick a time'
                    : 'Book ${formatTime(_slot!)}, ${formatDay(_slot!)}',
                showChevrons: false,
                onPressed: _slot == null ? null : _book,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.time,
    required this.selected,
    required this.available,
    required this.onTap,
  });

  final DateTime time;
  final bool selected;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = formatTime(time);
    final foreground = selected
        ? Colors.white
        : available
        ? AppColors.text
        : AppColors.textMuted;
    return Semantics(
      button: true,
      enabled: available,
      selected: selected,
      label: available ? label : '$label, unavailable',
      excludeSemantics: true,
      child: Material(
        color: selected
            ? AppColors.primary
            : available
            ? AppColors.surface
            : AppColors.divider,
        borderRadius: BorderRadius.circular(12),
        elevation: available && !selected ? 1 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: available ? onTap : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.bold,
                  decoration: available ? null : TextDecoration.lineThrough,
                ),
              ),
              if (!available)
                const Text(
                  'Unavailable',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
