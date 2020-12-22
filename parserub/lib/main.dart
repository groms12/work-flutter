import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:xml/xml.dart';
// import 'package:xml/xml_events.dart';
// import 'dart:io';
import 'dart:ui';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:intl/intl.dart' as intl;
import 'dart:async';
import 'package:http/http.dart' as http;

void main() async {
  int count = 0;
  var now = new DateTime.now();
  String dateReq = new intl.DateFormat("dd/MM/yyyy").format(now);
  String data = "http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=" +
      dateReq +
      "&date_req2=" +
      dateReq +
      "&VAL_NM_RQ=R01235";
  String txt = '';

  Timer.periodic(Duration(seconds: 10), (timer) async {
    txt = await getRub(data, txt);
    if (txt != '')
      count++;
    else
      txt = 'ok';
    runApp(
      Container(
        padding: EdgeInsets.only(top: 300, left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Text(
              "Курс рубля: $txt",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              "Счетчик: $count",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 26,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  });

  // runApp(
  //   Container(
  //     padding: EdgeInsets.only(top: 300, left: 10, right: 10),
  //     child: Column(
  //       children: <Widget>[
  //         Text(
  //           "$txt",
  //           textDirection: TextDirection.ltr,
  //           style: TextStyle(
  //             fontSize: 30,
  //           ),
  //         ),
  //         Text(
  //           "$count",
  //           textDirection: TextDirection.ltr,
  //           style: TextStyle(
  //             fontSize: 26,
  //             color: Colors.blue,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}

Future<String> getRub(String data, String txt) async {
  // await new Future.delayed(const Duration(seconds: 5));
  http.Response response = await http.get(data);
  var xml = response.body;
  final Xml2Json xml2Json = Xml2Json();
  xml2Json.parse(xml);
  var jsonString = xml2Json.toParker();
  var dict = jsonDecode(jsonString);
  txt = dict["ValCurs"]["Record"]["Value"];
  return Future.value(txt);
}
