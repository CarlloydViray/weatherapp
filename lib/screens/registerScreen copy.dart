import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, String> regions = {};
  Map<String, String> provinces = {};
  bool isRegionsLoaded = false;
  bool isProvincesLoaded = false;

  Future<void> callAPI() async {
    //https://psgc.gitlab.io/api/island-groups/

    var url = Uri.https('psgc.gitlab.io', 'api/island-groups');
    var response = await http.get(url);
    print(response.statusCode);
    print(response.body);

    List decodedResponse = jsonDecode(response.body);
    decodedResponse.forEach((element) {
      Map item = element;
      print(item['name']);
    });
  }

  Future<void> loadRegions() async {
    var url = Uri.https('psgc.gitlab.io', 'api/regions/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List decodedResponse = jsonDecode(response.body);

      decodedResponse.forEach((element) {
        Map item = element;
        // print(item['code'] + " " + item['regionName']);
        regions.addAll({item['code']: item['regionName']});
      });
    } else {
      print("Error : $response.statusCode");
    }
    setState(() {
      isRegionsLoaded = true;
    });
    print(regions);
  }

  Future<void> loadProvinces(String regionCode) async {
    var url = Uri.https('psgc.gitlab.io', 'api/regions/$regionCode/provinces/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List decodedResponse = jsonDecode(response.body);

      provinces.clear();
      decodedResponse.forEach((element) {
        Map item = element;
        provinces.addAll({item['code']: item['name']});
      });
    } else {
      var error = response.statusCode;
      print("Error : $error");
    }
    setState(() {
      isProvincesLoaded = true;
    });
    print(provinces);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRegions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(onPressed: loadRegions, child: Text('Call API')),
          if (isRegionsLoaded)
            DropdownMenu(
              label: Text('Regions'),
              width: MediaQuery.of(context).size.width,
              enableSearch: true,
              //enableFilter: true,
              dropdownMenuEntries: regions.entries.map((item) {
                return DropdownMenuEntry(value: item.key, label: item.value);
              }).toList(),
              onSelected: (value) {
                print(value);
                loadProvinces(value!);
                setState(() {
                  isProvincesLoaded = false;
                });
              },
            )
          else
            Center(child: CircularProgressIndicator()),
          SizedBox(
            height: 12,
          ),
          if (isProvincesLoaded)
            DropdownMenu(
              label: Text('Provinces'),
              width: MediaQuery.of(context).size.width,
              enableSearch: true,
              //enableFilter: true,
              dropdownMenuEntries: provinces.entries.map((item) {
                return DropdownMenuEntry(value: item.key, label: item.value);
              }).toList(),
              onSelected: (value) {
                print(value);
                loadProvinces(value!);
              },
            )
          else
            DropdownMenu(
              label: Text('Provinces'),
              width: MediaQuery.of(context).size.width,
              dropdownMenuEntries: [],
            ),
        ]),
      ),
    );
  }
}
