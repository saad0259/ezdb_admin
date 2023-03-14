enum DashboardFilter {
  max,
  lastMonth,
  thisMonth,
  lastWeek,
  thisWeek,
  today,
  noFilter,
}

extension Name on DashboardFilter {
  String getName() {
    switch (this) {
      case DashboardFilter.max:
        return 'Max';
      case DashboardFilter.lastMonth:
        return 'Last Month';
      case DashboardFilter.thisMonth:
        return 'This Month';
      case DashboardFilter.lastWeek:
        return 'Last Week';
      case DashboardFilter.thisWeek:
        return 'This Week';
      case DashboardFilter.today:
        return 'Today';
      case DashboardFilter.noFilter:
        return 'No Filter';
    }
  }
}

extension DateRange on DashboardFilter {
  DateTime get startAt {
    switch (this) {
      case DashboardFilter.noFilter:
      case DashboardFilter.max:
        return DateTime.now().subtract(const Duration(days: 1825));
      case DashboardFilter.lastMonth:
        return _getStartOfLastMonth();
      case DashboardFilter.thisMonth:
        return _getStartOfThisMonth();
      case DashboardFilter.lastWeek:
        return _getStartOfLastWeek();
      case DashboardFilter.thisWeek:
        return _getStartOfThisWeek();
      case DashboardFilter.today:
        return _getStartOfToday();
    }
  }

  DateTime get endAt {
    switch (this) {
      case DashboardFilter.max:
        return DateTime.now();
      case DashboardFilter.lastMonth:
        return _getEndOfLastMonth();
      case DashboardFilter.thisMonth:
        return DateTime.now();
      case DashboardFilter.lastWeek:
        return _getEndOfLastWeek();
      case DashboardFilter.thisWeek:
        return DateTime.now();
      case DashboardFilter.today:
        return DateTime.now();
      case DashboardFilter.noFilter:
        return DateTime.now().add(const Duration(days: 1825));
    }
  }

  DateTime _getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _getStartOfThisWeek() {
    final now = DateTime.now();
    final weekDay = now.weekday;
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekDay));
  }

  DateTime _getStartOfLastWeek() {
    final now = DateTime.now();
    final weekDay = now.weekday;
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekDay + 7));
  }

  DateTime _getEndOfLastWeek() {
    return _getStartOfThisWeek().subtract(const Duration(seconds: 1));
  }

  DateTime _getStartOfThisMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  DateTime _getStartOfLastMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month - 1);
  }

  DateTime _getEndOfLastMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month).subtract(const Duration(seconds: 1));
  }
}
