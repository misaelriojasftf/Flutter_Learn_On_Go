import 'package:flutter/material.dart';
import 'package:testapp/shared/maps/address_search/address_search.dart';

class TextFieldAddressExample extends StatelessWidget {
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
              exceptions: ["Lima, Peru", "Lima Province, Peru", "Peru"],
              onDone: (BuildContext _, AddressPoint point) {
                FocusScope.of(context).requestFocus(FocusNode());
                print(point.toString());
              },
            ),
          ),
        ],
      ),
    );
  }
}
