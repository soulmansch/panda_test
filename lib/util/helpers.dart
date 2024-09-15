import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  return DateFormat('MMMM dd, yyyy – hh:mm a').format(date);
}
