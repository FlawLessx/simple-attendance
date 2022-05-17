part of 'pin_location_cubit.dart';

@immutable
abstract class PinLocationState {}

class PinLocationInitial extends PinLocationState {}

class PinLocationLoaded extends PinLocationState {
  final String addressName;
  final double latitude;
  final double langitude;

  PinLocationLoaded(this.addressName, this.langitude, this.latitude);
}

class PinLocationError extends PinLocationState {}
