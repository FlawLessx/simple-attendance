import 'package:attendance/bloc/pin_location/pin_location_cubit.dart';
import 'package:attendance/pages/pick_pin_location_page.dart';
import 'package:attendance/widgets/location_card.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
  String? pinAddressName;
  double? pinLatitude;
  double? pinLongitude;

  @override
  void initState() {
    super.initState();
    _getPosition();
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
      setState(() {});
    }
  }

  void _checkIn() {
    if (latitude != null &&
        longitude != null &&
        pinLatitude != null &&
        pinLongitude != null) {
      double distanceInMeters = Geolocator.distanceBetween(
          latitude!, longitude!, pinLatitude!, pinLongitude!);

      if (distanceInMeters > 50) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text('Failed Check In'),
                  content: Text("You're too far from pinned location"),
                ));
      } else {
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
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              BlocBuilder<PinLocationCubit, PinLocationState>(
                builder: (context, state) {
                  if (state is PinLocationLoaded) {
                    pinAddressName = state.addressName;
                    pinLongitude = state.langitude;
                    pinLatitude = state.latitude;

                    return Expanded(
                      child: LocationCard(
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
                      ),
                    );
                  } else {
                    return Expanded(child: Container());
                  }
                },
              ),
              if (addressName != null && latitude != null && longitude != null)
                Expanded(
                  child: LocationCard(
                    addressName: addressName!,
                    longitude: longitude!,
                    latitude: latitude!,
                    header: 'Your Location',
                  ),
                )
              else
                Expanded(
                    child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: const Center(
                      child: Text('Failed fetch location'),
                    ),
                  ),
                )),
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
