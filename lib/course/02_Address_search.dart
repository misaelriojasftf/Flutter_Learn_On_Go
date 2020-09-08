import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:testapp/shared/maps/address_search/address_search.dart';
import 'package:testapp/shared/utils/launcher.dart';

class TextFieldAddressExample extends StatefulWidget {
  @override
  _TextFieldAddressExampleState createState() =>
      _TextFieldAddressExampleState();
}

class _TextFieldAddressExampleState extends State<TextFieldAddressExample> {
  num _lat;
  num _long;
  final _controller = TextEditingController();

  Future<void> onUpdate(num lat, num long) async {
    setState(() {
      _lat = lat;
      _long = long;
    });
  }

  Future<void> onTouch(num lat, num long) async {
    _controller.text = await AddressUtils.getFromCoordenates(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AddressTextField(
              country: "Peru",
              city: "Lima",
              hintText: "Dirección",
              controller: _controller,
              exceptions: ["Lima, Peru", "Lima Province, Peru", "Peru"],
              onDone: (BuildContext _, Address point) {
                FocusScope.of(context).requestFocus(FocusNode());
                print(point.toString());
                onUpdate(
                    point.coordinates.latitude, point.coordinates.longitude);
              },
            ),
          ),
          GoogleMaps(
            lat: _lat,
            long: _long,
            callback: (num lat, num long) => onTouch(lat, long),
          ),
        ],
      ),
    );
  }
}

class GoogleMaps extends StatefulWidget {
  final num lat;
  final num long;
  final Function(num, num) callback;
  const GoogleMaps({
    Key key,
    this.lat,
    this.long,
    this.callback,
  }) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget?.lat?.toString() ?? 'HOLA'),
              SizedBox(
                width: 20,
              ),
              Text(widget?.long?.toString() ?? 'MUNDO'),
            ],
          ),
          FlatButton(
            color: Colors.amber,
            onPressed: () {
              if (widget.callback is Function) {
                LauncherURL.onWeb(
                    url: AddressLocationUtils.concatenateAddress(widget.lat, widget.long));
                widget.callback(-12.111061999999999, -77.0315913);
              }
            },
            child: Text("MY PRIMER BOTON"),
          )
        ],
      ),
    );
  }
}

class AddressUtils {
  static Future<String> getFromCoordenates(num lat, num long) async {
    if ((lat is num && lat != 0) && (long is num && long != 0)) {
      final coordinates = new Coordinates(lat, long);

      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");

      return "${first.featureName} : ${first.addressLine}";
    }
    return "No found ";
  }
}
