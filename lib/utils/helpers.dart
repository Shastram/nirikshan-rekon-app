import 'package:timeago/timeago.dart' as timeago;

String convertToAgo(DateTime input) {
  return timeago.format(input);
}
