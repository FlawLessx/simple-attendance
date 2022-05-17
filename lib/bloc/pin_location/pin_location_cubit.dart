import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pin_location_state.dart';

class PinLocationCubit extends Cubit<PinLocationState> {
  PinLocationCubit() : super(PinLocationInitial());

  void passPinLocationData(
      String addressName, double latitude, double langitude) {
    emit(PinLocationLoaded(addressName, langitude, latitude));
  }
}
