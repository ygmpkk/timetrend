import 'package:intl/intl.dart';
import 'package:test/test.dart';
import '../bin/timetrend.dart';

class IntradayDataFrame {
  final dynamic time;
  final double call;
  final double put;

  IntradayDataFrame({
    required this.time,
    required this.call,
    required this.put,
  });
}

void main() {
  group("Timetrend", () {
    test("intraday", () {
      TimeTrend timeTrend = TimeTrend(
          DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:31'),
          '09:30-16:00');

      expect(timeTrend.times.length, 391);
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times[0]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:30'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times.last),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 16:00'),
      );
    });

    test("two days", () {
      TimeTrend timeTrend = TimeTrend(
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:31'),
        '17:30-05:15',
      );

      expect(timeTrend.times.length, 706);
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times[0]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 17:30'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times.last),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-15 05:15'),
      );
    });

    test('two days and two range', () {
      TimeTrend timeTrend = TimeTrend(
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 09:31'),
        '17:30-05:15,09:00-16:30',
      );

      expect(timeTrend.times.length, 1157);
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times[0]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-14 17:30'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times[705]),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-15 05:15'),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(timeTrend.times.last),
        DateFormat('yyyy-MM-dd HH:mm').parse('2022-04-15 16:30'),
      );
    });

    test('get a time, return a index', () {});
  });

  test('Intraday data', () {
    final intradayTrend = [
      {"time": "2022-04-27 10:38", "call": 17203.5, "put": -5312},
      {"time": "2022-04-27 10:39", "call": -124107.5, "put": 617728.3999999999},
      {"time": "2022-04-27 10:40", "call": 8130, "put": 144416.24},
      {"time": "2022-04-27 10:41", "call": -62155.22, "put": 80292.8},
      {"time": "2022-04-27 10:42", "call": -265105.5, "put": 42699.24999999999},
      {"time": "2022-04-27 10:43", "call": -86786, "put": -24466.519999999997},
      {"time": "2022-04-27 10:44", "call": -45070, "put": 319563.65},
      {
        "time": "2022-04-27 10:45",
        "call": -160633.08000000002,
        "put": 47211.51999999999
      },
      {
        "time": "2022-04-27 10:46",
        "call": -6155.77,
        "put": -7792.5999999999985
      },
      {"time": "2022-04-27 10:47", "call": -167382, "put": 542703},
      {"time": "2022-04-27 10:48", "call": -69742.5, "put": 297357.32},
      {"time": "2022-04-27 10:49", "call": 39657.899999999994, "put": 59056.39},
      {"time": "2022-04-27 10:50", "call": -50179.18000000001, "put": 72655.6},
      {"time": "2022-04-27 10:51", "call": -17283.9, "put": 13152.54},
      {"time": "2022-04-27 10:52", "call": 0, "put": 49520.020000000004},
      {"time": "2022-04-27 10:53", "call": -110500, "put": 41155.36},
      {"time": "2022-04-27 10:54", "call": 40480, "put": 10612.8},
      {"time": "2022-04-27 10:55", "call": 29790, "put": -6218}
    ];

    print(intradayTrend.first['time']);

    TimeTrend timeTrend = TimeTrend(
      DateFormat('yyyy-MM-dd HH:mm')
          .parse(intradayTrend.first['time'] as String),
      '09:30-16:00',
    );

    List<Map<String, dynamic>> adjusttimeTrend =
        timeTrend.adjustTimeseries(intradayTrend);
    List<Map<String, dynamic>> dataframe = timeTrend.dataframe(adjusttimeTrend);

    expect(dataframe.length, 391);
    expect(dataframe[68], {
      'time': 1651027080000,
      'call': intradayTrend[0]['call'],
      'put': intradayTrend[0]['put'],
    });
  });
}
