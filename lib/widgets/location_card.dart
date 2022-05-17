import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationCard extends StatelessWidget {
  const LocationCard(
      {Key? key,
      required this.addressName,
      required this.longitude,
      required this.latitude,
      required this.header,
      this.onTap,
      this.isPin = false})
      : super(key: key);

  final String addressName;
  final double longitude;
  final double latitude;
  final bool isPin;
  final String header;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    addressName,
                    maxLines: 2,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
            Text("($longitude, $latitude)"),
            SizedBox(
              height: 10.h,
            ),
            if (isPin)
              Container(
                width: double.maxFinite,
                child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text('Change')),
              )
          ],
        ),
      ),
    );
  }
}
