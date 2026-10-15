const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String weekdayShort(DateTime d) => _weekdays[d.weekday - 1];

String monthShort(DateTime d) => _months[d.month - 1];

/// "09:30 AM", "12:00 PM".
String formatTime(DateTime d) {
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? 'AM' : 'PM';
  return '${hour12.toString().padLeft(2, '0')}:$minute $period';
}

/// "Thu, 19 Oct".
String formatDay(DateTime d) => '${weekdayShort(d)}, ${d.day} ${monthShort(d)}';
