String formatSecondsDuration(int seconds) {
    if (seconds < 0) {
        return '00:00';
    }
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String minutesStr = (seconds % 3600 ~/ 60).toString().padLeft(2, '0');
    int hours = seconds ~/ 3600;
    String hoursStr = hours.toString().padLeft(2, '0');

    return hours > 0 ? '$hoursStr:$minutesStr:$secondsStr' : '$minutesStr:$secondsStr';
}
