String kformatDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return "${duration.inMinutes}:$twoDigitSeconds";
}
