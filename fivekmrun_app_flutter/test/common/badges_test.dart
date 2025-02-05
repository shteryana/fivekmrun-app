import 'package:fivekmrun_flutter/common/badges.dart';
import 'package:fivekmrun_flutter/common/date_extensions.dart';
import 'package:fivekmrun_flutter/state/run_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should not have max badge for no runs', () {
    var runs = <Run>[];
    expect(hasMaxBadge(runs), false);
  });

  test('should not have selfie badge for no runs', () {
    var runs = <Run>[];
    expect(hasSelfieBadge(runs), false);
  });

  test('should have max badge this year', () {
    var runs = <Run>[];

    var now = DateTime.now();
    var saturday = now.lastSaturday();
    while (saturday.year == now.year) {
      runs.add(new Run(date: saturday, isSelfie: false));
      saturday = saturday.subtract(Duration(days: 7));
    }

    expect(hasMaxBadge(runs), true);
  });

  test('should not have max badge this year', () {
    var runs = <Run>[];

    var now = DateTime.now();
    var saturday = now.lastSaturday().subtract(Duration(days: 7));
    while (saturday.year == now.year) {
      runs.add(new Run(date: saturday, isSelfie: false));
      saturday = saturday.subtract(Duration(days: 7));
    }

    expect(hasMaxBadge(runs), false);
  });

  test('should have selfie badge this year', () {
    var runs = <Run>[];

    var now = DateTime.now();
    var saturday = now.lastSaturday();
    while (saturday.year == now.year) {
      runs.add(new Run(date: saturday, isSelfie: true));
      saturday = saturday.subtract(Duration(days: 7));
    }

    expect(hasSelfieBadge(runs), true);
  });

  test('should not have selfie badge this year', () {
    var runs = <Run>[];

    var now = DateTime.now();
    var saturday = now.lastSaturday().subtract(Duration(days: 7));
    while (saturday.year == now.year) {
      runs.add(new Run(date: saturday, isSelfie: true));
      saturday = saturday.subtract(Duration(days: 7));
    }

    expect(hasMaxBadge(runs), false);
  });

  test('should have max badge for previous year', () {
    var runs = <Run>[];

    var previousYear = DateTime(2022, 12, 31);
    var saturday = previousYear.lastSaturday();
    while (saturday.year == previousYear.year) {
      runs.add(new Run(date: saturday, isSelfie: false));
      saturday = saturday.subtract(Duration(days: 7));
    }

    expect(hasMaxBadge(runs), true);
  });

  test('should have selfie badge for previous year', () {
    var runs = <Run>[];

    var previousYear = DateTime(2022, 12, 31);
    var saturday = previousYear.lastSaturday();
    while (saturday.year == previousYear.year) {
      runs.add(new Run(date: saturday, isSelfie: true));
      saturday = saturday.subtract(Duration(days: 7));
    }

    expect(hasSelfieBadge(runs), true);
  });
}
