String convertTimeGapToString(DateTime time) {
  final DateTime now = DateTime.now();
  final Duration gap = now.difference(time);

  //15일 이상 발생
  if (gap.inDays >= 15) {
    return '${time.year}.${time.month}.${time.day}';
  }
  //1일 이상 발생
  if (gap.inDays >= 1) {
    return '${gap.inDays}일 전';
  }
  //24시간 내로 발생
  if (gap.inHours >= 1) {
    return '${gap.inHours}시간 전';
  }
  //1시간 내로 발생
  if (gap.inMinutes >= 1) {
    return '${gap.inMinutes}분 전';
  }

  return '방금 전';
}
