import 'dart:convert';

import 'package:driver/models/customer_booking.dart';
import 'package:driver/models/driver.dart';
import 'package:driver/providers/current_location.dart';
import 'package:driver/providers/socket_provider.dart';
import 'package:driver/screens/customer_request/customer_request_accept.dart';
import 'package:driver/screens/home_dashboard/home_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import '../../models/location.dart';
import '../../models/vehicle.dart';
import '../../providers/customer_request.dart';
import 'styles.dart';

class CustomerRequest extends ConsumerStatefulWidget {
  const CustomerRequest({Key? key}) : super(key: key);

  static String name = 'CustomerRequest';
  static String path = '/customer/request';

  @override
  ConsumerState<CustomerRequest> createState() => _CustomerRequestState();
}

class _CustomerRequestState extends ConsumerState<CustomerRequest> {
  @override
  Widget build(BuildContext context) {
    final customerRequestNotifier = ref.read(customerRequestProvider.notifier);
    final customerRequest = ref.watch(customerRequestProvider);
    final socketManager = ref.read(socketClientProvider.notifier);
    final currentLocation = ref.watch(currentLocationProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: const Image(
                  image: AssetImage("lib/assets/test/avatar.png"),
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 270,
                            child: Text(
                                customerRequest
                                    .customer_infor.user_information.name,
                                style: ThemeText.customerName,
                                overflow: TextOverflow.ellipsis)),
                        Row(
                          children: <Widget>[
                            // Image(
                            //     image: AssetImage(
                            //         'lib/assets/icons/${customerRequest.user_information.rankType}.png'),
                            //     width: 20),
                            const SizedBox(width: 20),
                            const SizedBox(width: 10),
                            Text(
                                customerRequest
                                    .customer_infor.user_information.rank,
                                style: ThemeText.ranking),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                            customerRequest.customer_infor.user_information
                                .default_payment_method,
                            style: ThemeText.bookingDetails),
                        // if (customerRequest.booking.promotion) const Text('Khuyến mãi', style: ThemeText.bookingDetails),
                        Text(
                            customerRequest
                                .customer_infor.user_information.type,
                            style: ThemeText.bookingDetails),
                        // if (!customerRequest.user_information.promotion) const SizedBox(width: 60),
                        const SizedBox(width: 60),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(FontAwesomeIcons.mapPin,
                      size: 23, color: Color(0xFFF86C1D)),
                  const SizedBox(width: 6),
                  Text('Cách bạn ${customerRequest.duration_distance}',
                      style: ThemeText.locationDurationDetails),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(FontAwesomeIcons.locationArrow,
                      size: 23, color: Color(0xFFF86C1D)),
                  const SizedBox(width: 6),
                  Text('Lộ trình ${customerRequest.customer_infor.distance}',
                      style: ThemeText.locationDurationDetails),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(FontAwesomeIcons.clock,
                      size: 21, color: Color(0xFFF86C1D)),
                  const SizedBox(width: 8),
                  Text(customerRequest.customer_infor.time,
                      style: ThemeText.locationDurationDetails),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Thông tin hành trình', style: ThemeText.headingTitle),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Image(
                        image: AssetImage('lib/assets/icons/locations.png'),
                        width: 36),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          border: Border.all(
                            color: const Color(0xFFF2F2F2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: MediaQuery.of(context).size.width - 88,
                        child: Text(
                          customerRequest
                              .customer_infor.departure_information.address,
                          style: ThemeText.locationDetails,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          border: Border.all(
                            color: const Color(0xFFF2F2F2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: MediaQuery.of(context).size.width - 88,
                        child: Text(
                          customerRequest
                              .customer_infor.arrival_information.address,
                          style: ThemeText.locationDetails,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(children: <Widget>[
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                customerRequestNotifier.cancelRequest();
                context.go(HomeDashboard.path);
              },
              style: ThemeButton.cancelButton,
              child: const Text('TỪ CHỐI', style: ThemeText.cancelButtonText),
            )),
            const SizedBox(width: 16),
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        socketManager.publish(
                            'driver-accept',
                            jsonEncode(DriverSubmit(
                                    user_id: customerRequest.customer_infor
                                        .user_information.phonenumber,
                                    driver: Driver(
                                        "https://example.com/avatar0.jpg",
                                        "Nguyễn Đức Minh",
                                        "0778568685",
                                        Vehicle(
                                            name: "Honda Wave RSX",
                                            brand: "Honda",
                                            type: "Xe máy",
                                            color: "Xanh đen",
                                            number: "68S164889"),
                                        LocationPostion(
                                            latitude: currentLocation.latitude,
                                            longitude:
                                                currentLocation.longitude),
                                        currentLocation.heading,
                                        5.0))
                                .toJson()));

                        customerRequestNotifier.acceptRequest();
                        context.go(CustomerRequestAccept.path);
                      },
                      style: ThemeButton.acceptButton,
                      child: const Text('CHẤP NHẬN',
                          style: ThemeText.acceptButtonText),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    child: Builder(builder: (context) {
                      return CircularCountDownTimer(
                        width: 24,
                        height: 24,
                        duration: 10,
                        initialDuration: 0,
                        ringColor: const Color.fromRGBO(255, 255, 255, .8),
                        fillColor: const Color.fromRGBO(94, 169, 68, .7),
                        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                        strokeWidth: 10.0,
                        strokeCap: StrokeCap.square,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFF86C1D),
                          fontWeight: FontWeight.bold,
                        ),
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: false,
                        autoStart: true,
                        onComplete: () {
                          customerRequestNotifier.cancelRequest();
                          context.go(HomeDashboard.path);
                        },
                        timeFormatterFunction:
                            (defaultFormatterFunction, duration) {
                          if (duration.inSeconds == 0) {
                            return "0";
                          } else {
                            return Function.apply(
                                defaultFormatterFunction, [duration]);
                          }
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}
