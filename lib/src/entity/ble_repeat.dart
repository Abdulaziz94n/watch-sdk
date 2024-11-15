class BleRepeat {
  static const int MONDAY = 1;
  static const int TUESDAY = 1 << 1;
  static const int WEDNESDAY = 1 << 2;
  static const int THURSDAY = 1 << 3;
  static const int FRIDAY = 1 << 4;
  static const int SATURDAY = 1 << 5;
  static const int SUNDAY = 1 << 6;
  static const int ONCE = 0;
  static const int WORKDAY = MONDAY | TUESDAY | WEDNESDAY | THURSDAY | FRIDAY;
  static const int WEEKEND = SATURDAY | SUNDAY;
  static const int EVERYDAY =
      MONDAY | TUESDAY | WEDNESDAY | THURSDAY | FRIDAY | SATURDAY | SUNDAY;
}
