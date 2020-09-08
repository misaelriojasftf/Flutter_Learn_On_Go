part of '../address_search.dart';

/// Widget based in an [AlertDialog] with a search bar and list of results,
/// all in one box.
class AddressTextField extends StatefulWidget {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  /// Country where look for an address.
  final String country;

  /// City where look for an address.
  final String city;

  /// Hint text for [AddressTextField].
  final String hintText;

  /// Resulting addresses to be ignored.
  final List<String> exceptions;

  /// If it finds coordinates, they will be set to the reference.
  final bool coordForRef;

  /// Callback to run when search ends.
  final Function(BuildContext dialogContext, Address point) onDone;

  /// Constructs an [AddressTextField] widget from a concrete [country].
  AddressTextField({
    TextEditingController controller,
    @required this.country,
    this.city = "",
    @required this.hintText,
    this.exceptions = const <String>[],
    this.coordForRef = false,
    this.onDone,
  })  : assert(country.isNotEmpty, "Country can't be empty"),
        assert(country != null),
        assert(hintText != null),
        this.controller = controller ?? TextEditingController();

  @override
  _AddressTextFieldState createState() => _AddressTextFieldState(
        controller,
        country,
        city,
        hintText,
        exceptions,
        coordForRef,
        onDone,
      );
}

/// State of [AddressTextField].
class _AddressTextFieldState extends State<AddressTextField> {
  final TextEditingController controller;
  final String country;
  final String city;
  final String hintText;
  final List<String> exceptions;
  final bool coordForRef;
  final Function(BuildContext context, Address point) onDone;
  final AddressPoint _addressPoint = AddressPoint._();
  List<Address> _address = List();

  BuildContext _dialogContext;
  Size _size = Size(0.0, 0.0);
  bool _loading;
  bool _waiting;

  /// Creates the state of an [AddressTextField] widget.
  _AddressTextFieldState(
    this.controller,
    this.country,
    this.city,
    this.hintText,
    this.exceptions,
    this.coordForRef,
    this.onDone,
  ) {
    initLocationService();
  }

  @override
  void initState() {
    super.initState();
    _addressPoint._country = country;
    _loading = false;
    _waiting = false;
  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    _size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _waiting
            ? _loadingIndicator
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _textFieldAddressSearchBar,
                    _textFieldAddressSearchResult,
                  ],
                ),
              ),
      ],
    );
  }

  /// Returns the address search bar widget to write an address reference.
  Widget get _textFieldAddressSearchBar => Container(
        height: 60.0,
        width: _size.width * 0.80,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              width: _size.width * 0.80 - 70.0,
              child: TextField(
                onEditingComplete: () async => await _searchAddress(),
                // onChanged: (_) async => await _searchAddress(),
                controller: controller,
                autofocus: true,
                autocorrect: false,
                decoration: InputDecoration(
                    prefix: Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 8.0),
                      child: Icon(Icons.location_on),
                    ),
                    hintText: hintText),
              ),
            ),
          ],
        ),
      );

  /// Returns a [Widget] depending on the state of the search
  /// process and its result.
  ///
  /// Returns [CircularProgressIndicator] while it's searching the address.
  /// Returns [ListView] if search found places.
  Widget get _textFieldAddressSearchResult => Container(
        constraints: BoxConstraints(
          // maxHeight: _size.height * 0.28,
          maxWidth: _size.width * 0.80,
        ),
        alignment: Alignment.centerLeft,
        child: Center(
          child: _loading
              ? CircularProgressIndicator()
              : ((_address.isNotEmpty)
                  ? Container(
                      height: 200,
                      child: Card(
                        child: ListView.separated(
                          padding: EdgeInsets.all(10.0),
                          itemCount: _address.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              (index != _address.length - 1)
                                  ? Divider()
                                  : Container(),
                          itemBuilder: (BuildContext context, int index) {
                            print(_address[index].coordinates.longitude);
                            return GestureDetector(
                              child: ListTile(
                                title: Text(_address[index].addressLine),
                                trailing: Icon(Icons.chevron_right),
                              ),
                              onTap: () async {
                                controller.text = _address[index].addressLine;
                                await _asyncFunct(_address[index]);
                              },
                            );
                          },
                        ),
                      ),
                    )
                  : Container()),
        ),
      );

  /// Returns a [CircularProgressIndicator] while [onDone] function is processing.
  Widget get _loadingIndicator => Container(
        height: _size.height * 0.28 + 60.0,
        width: _size.width * 0.80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  /// It uses the user's reference to search for nearby addresses
  /// and places to obtain coordinates.
  Future<void> _searchAddress() async {
    _loading = true;
    try {
      setState(() {});
    } catch (_) {}
    final int length = controller.text.length;
    await Future.delayed(Duration(seconds: 2), () async {
      if (controller.text.isEmpty) {
        _address.clear();
        _loading = false;
        try {
          setState(() {});
        } catch (_) {}
      } else if (length == controller.text.length) {
        try {
          List<Placemark> placeMarks;
          if (controller.text.isNotEmpty) {
            final String address = (city.isEmpty)
                ? controller.text + ", " + country
                : controller.text + ", " + city + ", " + country;

            Geolocator geolocator = Geolocator()
              ..forceAndroidLocationManager = true;

            placeMarks = await geolocator.placemarkFromAddress(address);

            // placeMarks.forEach((element) {
            //   print(element.position.longitude);
            // });
          }
          if (placeMarks.isNotEmpty) {
            _addressPoint._latitude = placeMarks[0].position.latitude;
            _addressPoint._longitude = placeMarks[0].position.longitude;

            final Coordinates coordinates =
                Coordinates(_addressPoint._latitude, _addressPoint._longitude);
            final List<Address> addresses =
                await Geocoder.local.findAddressesFromCoordinates(coordinates);
            if (_address.isNotEmpty) {
              _address.clear();
              setState(() {});
            }
            addresses.asMap().forEach((index, value) {
              final String place = value.addressLine;

              // Checks if place is not duplicated, if it's a country place and if it's not into exceptions
              if (!_address.contains(place) &&
                  place.endsWith("Perú") &&
                  !exceptions.contains(place))
                setState(() {
                  _address.add(value);
                });
            });
          }
        } on NoSuchMethodError catch (_) {} on PlatformException catch (_) {} catch (_) {
          debugPrint("ERROR CATCHED: " + _.toString());
        }
        _loading = false;
        try {
          setState(() {});
        } catch (_) {}
      }
    });
  }

  /// If the user runs an asynchronous process in [onDone] function
  /// it will display an [CircularProgressIndicator] (changing [_waiting]
  /// vairable) in the [AddressTextField] until the process ends.
  Future<void> _asyncFunct(Address address, {bool notFound = false}) async {
    setState(() {
      _waiting = true;
    });
    if (notFound) {
      _addressPoint._latitude = 0.0;
      _addressPoint._longitude = 0.0;
    }
    if (onDone != null) await onDone(_dialogContext, address);
    _waiting = false;
    _address.clear();
    try {
      setState(() {});
    } catch (_) {}
  }
}
