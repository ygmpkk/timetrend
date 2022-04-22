import assert from 'assert';
import { TimeTrend } from '.';

describe('TimeTrend', () => {
  it('intraday', () => {
    const timeTrend = new TimeTrend();

    const timeseries = timeTrend.timeseries({
      firstDate: new Date('2022-04-14 09:31:00.000'),
      tradingTimes: '09:30-16:00',
    });

    assert.deepEqual(timeseries.length, 391);

    assert.deepEqual(new Date(timeseries[0]).toLocaleString(), new Date('2022-04-14 09:30:00').toLocaleString());

    assert.deepEqual(
      new Date(timeseries[timeseries.length - 1]).toLocaleString(),
      new Date('2022-04-14 16:00:00').toLocaleString(),
    );
  });

  it('two days', () => {
    const timeTrend = new TimeTrend();

    const timeseries = timeTrend.timeseries({
      firstDate: new Date('2022-04-14 08:31:00.000'),
      tradingTimes: '17:30-05:15',
    });

    assert.deepEqual(timeseries.length, 706);

    assert.deepEqual(new Date(timeseries[0]).toLocaleString(), new Date('2022-04-14T17:30:00').toLocaleString());

    assert.deepEqual(
      new Date(timeseries[timeseries.length - 1]).toLocaleString(),
      new Date('2022-04-15T05:15:00').toLocaleString(),
    );
  });

  it('two days and two range', () => {
    const timeTrend = new TimeTrend();

    const timeseries = timeTrend.timeseries({
      firstDate: new Date('2022-04-14 09:31:00.000'),
      tradingTimes: '17:30-05:15,09:00-16:30',
    });

    assert.deepEqual(timeseries.length, 1157);

    assert.deepEqual(new Date(timeseries[0]).toLocaleString(), new Date('2022-04-14 17:30:00').toLocaleString());

    assert.deepEqual(new Date(timeseries[705]).toLocaleString(), new Date('2022-04-15 05:15:00').toLocaleString());

    assert.deepEqual(
      new Date(timeseries[timeseries.length - 1]).toLocaleString(),
      new Date('2022-04-15 16:30:00').toLocaleString(),
    );
  });

  it('get a time, return a index', () => {
    const timeTrend = new TimeTrend();

    const timeseries = timeTrend.timeseries({
      firstDate: new Date('2022-04-14 09:00:00'),
      tradingTimes: '09:30-16:00',
    });

    const timeToIndex = timeTrend.timeToIndex(new Date('2022-04-14 09:41:31').getTime());
    assert.deepEqual(timeToIndex, 11);
  });
});
