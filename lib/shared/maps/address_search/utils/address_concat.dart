part of '../address_search.dart';

class AddressLocationUtils {
  static String concatenateAddress(num latitude, num longitude) =>
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
}
