import _debug from 'debug';
const debug = _debug('timetrend');

interface DataFrame {
  time: number;
  price: number;
  volume: number;
  amount: number;
}

export class TimeTrend {
  private _dayDuration = 24 * 60 * 60 * 1000;
  private _minuteDuration = 60 * 1000;
  times: Array<number> = [];

  setDate(date, time: string) {
    const [startHour, startMinute]: any = time.split(':');
    let startTime: Date | number = new Date(date);
    console.log(startTime);
    startTime.setHours(startHour);
    startTime.setMinutes(startMinute);
    return startTime.getTime();
  }

  constructor() {}

  timeseries({ firstDate, tradingTimes }: { firstDate: Date; tradingTimes: string }) {
    const _firstDate = firstDate.getTime() - (firstDate.getTime() % this._dayDuration);

    let endTime = _firstDate;
    for (const [start, end] of tradingTimes.split(',').map((item) => item.split('-'))) {
      const startTime = this.setDate(endTime, start);
      endTime = this.setDate(endTime, end);

      debug('startTime:', startTime);
      debug('endTime:', endTime);

      if (endTime < startTime) {
        endTime += this._dayDuration;
        debug('Day:', 'T-1');
      }

      const isInRange = _firstDate > startTime && _firstDate < endTime;

      var count = ((isInRange ? _firstDate : endTime) - startTime) / this._minuteDuration;

      if (count < 1) {
        count = 1;
      }

      debug('count:', count);

      for (var i = 0; i <= count; i++) {
        this.times.push(startTime + this._minuteDuration * i);
      }

      if (isInRange) {
        break;
      }
    }

    return this.times;
  }

  timeToIndex(time: number) {
    const minute = time - (time % this._minuteDuration);
    debug('start to minute:', time, minute);
    return this.times.findIndex((value) => value === minute);
  }

  dataframe() {}
}
