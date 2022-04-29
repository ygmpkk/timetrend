import 'package:intl/intl.dart';

class TimeTrend {
  final Duration _dayDuration = Duration(days: 1);
  final Duration _minuteDuration = Duration(minutes: 1);

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final List<int> times = [];

  TimeTrend(DateTime firstDate, String tradingTimes) {
    _timeseries(firstDate: firstDate, tradingTimes: tradingTimes);
  }

  _timeseries({required DateTime firstDate, required String tradingTimes}) {
    firstDate = firstDate.subtract(Duration(
        milliseconds:
            firstDate.millisecondsSinceEpoch % _dayDuration.inMilliseconds));

    var endTime = firstDate;

    for (var item in tradingTimes.split(',').map((item) => item.split('-'))) {
      final startTime = DateFormat('yyyy-MM-dd HH:mm')
          .parse('${_dateFormat.format(endTime)} ${item[0]}');

      endTime = DateFormat('yyyy-MM-dd HH:mm')
          .parse('${_dateFormat.format(endTime)} ${item[1]}}');

      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(_dayDuration);
      }

      final isOutRange =
          firstDate.isAfter(startTime) && firstDate.isBefore(endTime);

      var count = ((isOutRange
                  ? firstDate.millisecondsSinceEpoch
                  : endTime.millisecondsSinceEpoch) -
              startTime.millisecondsSinceEpoch) /
          _minuteDuration.inMilliseconds;

      if (count < 1) {
        count = 1;
      }

      for (var i = 0; i <= count; i++) {
        times.add(startTime.millisecondsSinceEpoch +
            _minuteDuration.inMilliseconds * i);
      }

      if (isOutRange) {
        break;
      }
    }

    return times;
  }

  adjustTimeseries(List<Map<String, dynamic>> tickdata) {
    return tickdata.map((item) {
      var timestamp = DateFormat('yyyy-MM-dd HH:mm')
          .parse(item['time'])
          .millisecondsSinceEpoch;

      item['time'] = timestamp - (timestamp % _minuteDuration.inMilliseconds);
      return item;
    }).toList();
  }

  dataframe(List<Map<String, dynamic>> tickdata) {
    return times.map((time) {
      var item = tickdata.singleWhere((item) {
        return item['time'] == time;
      }, orElse: () => {});

      return {
        'time': time,
        'call': item['call'],
        'put': item['put'],
      };
    }).toList();
  }
}
