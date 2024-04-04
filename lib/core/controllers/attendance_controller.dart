import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/attendance_model.dart';
import '../../repository/attendance_repository.dart';

class AttendanceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxList<Attendance> listAttendances = <Attendance>[].obs;

  // MASTER DATA -- HASHMICRO LOCATION
  final masterData = const LatLng(-6.1707388, 106.8133555);

  Position? currentPosition;

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // PERMISSION SERVICE LOKASI DITOLAK
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // PERMISSION LOKASI DITOLAK
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // PERMISSION LOKASI DITOLAK PERMANEN
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // PERMISSION DITERIMA USER, LANJUTKAN EKSEKUSI.
    try {
      currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      return Future.error('Location service are disbled.');
    }
  }

  Future getListAttendances() async {
    isLoading.value = true;

    try {
      final response = await AttendanceRepository.readAllAttendances();

      listAttendances.clear();
      listAttendances.addAll(response);

      isError.value = false;
    } catch (e) {
      isError.value = true;
      log('error read list: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future submitAttendance(String name) async {
    if (currentPosition == null) {
      Fluttertoast.showToast(msg: 'Location not detected');
      return;
    }

    try {
      final distance = Geolocator.distanceBetween(
        masterData.latitude,
        masterData.longitude,
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      log('distance from center: $distance');

      // KETENTUAN DISTANCE / JARAK POSISI ATTENDANCE DENGAN MASTERDATA
      if (distance > 50) {
        Fluttertoast.showToast(
            msg: 'Attendance must be less or 50 meters from center point');
        return;
      }

      await AttendanceRepository.create(
        Attendance(
          name: name,
          latitude: currentPosition!.latitude,
          longitude: currentPosition!.longitude,
          createdAt: DateTime.now(),
        ),
      );

      getListAttendances();

      Fluttertoast.showToast(msg: 'Success submit attendance');
      Get.back();
    } catch (e) {
      log('error submit: ${e.toString()}');
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
