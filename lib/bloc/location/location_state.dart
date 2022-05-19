part of 'location_cubit.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<History> histories;

  LocationLoaded(this.histories);
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
