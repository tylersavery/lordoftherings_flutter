String formatMinutes(int minutes) {
  final duration = Duration(minutes: minutes).toString().split(".").first;

  return duration;
}
