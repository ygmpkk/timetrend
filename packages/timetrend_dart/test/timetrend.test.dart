import 'package:intl/intl.dart';
import 'package:test/test.dart';
import '../bin/timetrend.dart';

void main() {
  group("Timetrend", () {
    test("intraday", () {
      TimeTrend timeTrend = TimeTrend();
      List<int> timeseries = timeTrend.timeseries(
        firstDate: DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:31'),
        tradingTimes: '09:30-16:00',
      );

      expect(timeseries.length, 391);
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries[0]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:30'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries.last),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 16:00'),
      );
    });

    test("two days", () {
      TimeTrend timeTrend = TimeTrend();
      List<int> timeseries = timeTrend.timeseries(
        firstDate: DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:31'),
        tradingTimes: '17:30-05:15',
      );

      expect(timeseries.length, 706);
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries[0]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 17:30'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries.last),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-15 05:15'),
      );
    });

    test('two days and two range', () {
      TimeTrend timeTrend = TimeTrend();
      List<int> timeseries = timeTrend.timeseries(
        firstDate: DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:31'),
        tradingTimes: '17:30-05:15,09:00-16:30',
      );

      expect(timeseries.length, 1157);
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries[0]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 17:30'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries[705]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-15 05:15'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeseries.last),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-15 16:30'),
      );
    });

    test('get a time, return a index', () {});
  });
}
