class AppConstants {
  AppConstants._();
}

enum GetAlarmStatus {
  active,
  inactive,
  dismissed,
  reported,
}

enum AlarmStatus {
  ACTIVE,
  DISMISSED,
  REPORTED,
  REPORTED_AUTOMATICALLY,
}

enum UpdateAlarmStatus {
  report,
  dismiss,
}

enum SensorPowered {
  ON,
  OFF,
}

enum SensorStatus {
  ACTIVE,
  INACTIVE,
}
