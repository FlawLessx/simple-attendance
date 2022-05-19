import 'package:attendance/bloc/history/history_cubit.dart';
import 'package:attendance/bloc/pin_location/pin_location_cubit.dart';
import 'package:attendance/model/history.dart';
import 'package:attendance/pages/pick_pin_location_page.dart';
import 'package:attendance/widgets/history_card.dart';
import 'package:attendance/widgets/location_card.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  String? addressName;
  double? latitude;
  double? longitude;
  double? distance;

  String? pinAddressName;
  double? pinLatitude;
  double? pinLongitude;

  @override
  void initState() {
    super.initState();
    _getPosition();
    BlocProvider.of<HistoryCubit>(context).getListHistory();
  }

  Future<void> _getPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    } else {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // update the ui with the address
      addressName =
          '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
      latitude = position.latitude;
      longitude = position.longitude;
      distance = Geolocator.distanceBetween(
          latitude!, longitude!, pinLatitude!, pinLongitude!);
      setState(() {});
    }
  }

  Future<void> _checkIn() async {
    if (latitude != null &&
        longitude != null &&
        pinLatitude != null &&
        pinLongitude != null &&
        distance != null) {
      if (distance! > 50) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "You're too far from pinned location",
        );
      } else {
        await BlocProvider.of<HistoryCubit>(context).insertHistory(History(
            date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            pinLocation: pinAddressName!,
            userLocation: addressName!,
            distance: distance!.floorToDouble()));

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Checkin successful!",
        );
      }
    } else {
      print("Null: $latitude, $longitude, $pinLatitude, $pinLongitude");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              BlocBuilder<PinLocationCubit, PinLocationState>(
                builder: (context, state) {
                  if (state is PinLocationLoaded) {
                    pinAddressName = state.addressName;
                    pinLongitude = state.langitude;
                    pinLatitude = state.latitude;

                    return LocationCard(
                      addressName: state.addressName,
                      longitude: state.langitude,
                      latitude: state.latitude,
                      header: 'Pinned Location',
                      isPin: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PickPinLocationPage()),
                        );
                      },
                    );
                  } else {
                    return Expanded(child: Container());
                  }
                },
              ),
              if (addressName != null &&
                  latitude != null &&
                  longitude != null &&
                  distance != null)
                LocationCard(
                  addressName: addressName!,
                  longitude: longitude!,
                  latitude: latitude!,
                  header: 'Your Location',
                  distance: distance!.floorToDouble(),
                )
              else
                SizedBox(
                    height: 150.h,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: const Center(
                          child: Text('Failed fetch location'),
                        ),
                      ),
                    )),
              const Expanded(child: HistoryCard()),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: _checkIn, child: const Text("Check In")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
