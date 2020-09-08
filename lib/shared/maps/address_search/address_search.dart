/// An address search box that gets nearby addresses by typing a reference,
/// returns an object with place primary data. The object can also find an
/// address using coordinates.
library address_search_field;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

part './service/location_service.dart';
part './model/address_model.dart';
part './components/address_textfield.dart';
part './utils/address_concat.dart';
