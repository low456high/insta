// ignore_for_file: prefer_const_constructors, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var baseUrl = 'http://192.168.1.11:8000/api/';

var cancelResponse = {'type': 'danger', 'msg': 'Try Again...'};

class App {
  navigator(context, route) async {
    var data =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return route;
    }));
    return data;
  }

  replaceNavigator(context, route) async {
    var data = await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return route;
    }));
    return data;
  }

  api(url, Map<String, dynamic> body, context) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl + url.toString()),
        body: body,
        headers: {
          // 'Authorization': 'Bearer ${UserData().getUserToken}',
        },
      );
      print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
      var data = json.decode(response.body);
      if (data is List) {
        return data[0];
      } else {
        return data;
      }
    } on SocketException {
      print('No Internet connection');

      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await api(url, body, context);
        return data;
      } else {
        return cancelResponse;
      }
    } on TimeoutException catch (e) {
      print('Time Out ' + e.toString());
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Time Out, plz check your connection.',
      );
      if (retry) {
        var data = await api(url, body, context);
        return data;
      } else {
        return cancelResponse;
      }
    } catch (e) {
      print('Error in Api: $e');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Some Error Occur, plz check your connection.',
      );
      if (retry) {
        var data = await api(url, body, context);
        return data;
      } else {
        return cancelResponse;
      }
    }
  }

  getApi(url, context) async {
    try {
      var response = await http.get(
        Uri.parse(baseUrl + url.toString()),
        headers: {
          "Content-Type": "application/json",
          // 'Authorization': 'Bearer ${UserData().getUserToken}',
        },
      );
      var data = json.decode(response.body);
      if (data is List) {
        return data[0];
      } else {
        return data;
      }
    } on SocketException {
      print('No Internet connection');

      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Internet connection issue, try to reconnect.',
      );
      if (retry) {
        var data = await getApi(
          url,
          context,
        );
        return data;
      } else {
        return cancelResponse;
      }
    } on TimeoutException catch (e) {
      // ignore: avoid_print
      print('Time Out ' + e.toString());
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Time Out, plz check your connection.',
      );
      if (retry) {
        var data = await getApi(url, context);
        return data;
      } else {
        return cancelResponse;
      }
    } catch (e) {
      print('Error in Api: $e');
      var retry = await apiDialogue(
        context,
        'Alert  !!!',
        'Some Error Occur, plz check your connection.',
      );
      if (retry) {
        var data = await getApi(url, context);
        return data;
      } else {
        return cancelResponse;
      }
    }
  }

// getApi(url,context)
// async {
//   try{
//     var response = await http.get(
//       Uri.parse(baseUrl+url),
//     );
//     var data = json.decode(response.body);
//     // print(data);
//     if(data is List){
//       return data[0];
//     }
//     else{
//       return data;
//     }
//
//   }
//   on SocketException {
//     print('No Internet connection');
//     var retry=await apiDialogue(context, 'Alert  !!!', 'Internet connection issue, try to reconnect.',
//     );
//     if(retry){
//       var data= await getApi(url,context);
//       return data;
//     }
//     else{
//       return cancelResponse;
//     }
//   }
//   on TimeoutException catch (e) {
//     print('Time Out '+e.toString());
//     var retry=await apiDialogue(context, 'Alert  !!!', 'Time Out, plz check your connection.',
//     );
//     if(retry){
//       var data= await getApi(url,context);
//       return data;
//     }
//     else{
//       return cancelResponse;
//     }
//   }
//   catch (e) {
//     print('Error in Api: $e');
//     var retry=await apiDialogue(context, 'Alert  !!!', 'Some Error Occur, plz check your connection.',
//     );
//     if(retry){
//       var data= await getApi(url,context);
//       return data;
//     }
//     else{
//       return cancelResponse;
//     }
//   }
// }

// tabletOrAndroidView(widget)
// {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       isTablet?
//       SizedBox(
//         width: 600,
//         child:   widget,)
//           :
//       Expanded(
//         child:   widget,
//       ),
//     ],
//   );
// }
//
//
// tabletOrAndroidViewHeight(h)
// {
//   return isTablet? (h+(h/3)).toDouble():h.toDouble();
// }
//
// tabletOrAndroidViewTextSize(s)
// {
//   return  isTablet? (s*2).toDouble():s.toDouble();
// }

}

apiDialogue(context, alert, msg) {
  var canPressOk = true;
  var retry = false;
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(builder: (context, setState) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                border:
                                    Border.all(color: Colors.red, width: 2)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            msg.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            padding: EdgeInsets.all(8),
                                          ),
                                          onPressed: () {
                                            if (canPressOk) {
                                              canPressOk = false;
                                              Navigator.pop(context);
                                              retry = false;
                                            }
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            padding: EdgeInsets.all(8),
                                          ),
                                          onPressed: () {
                                            if (canPressOk) {
                                              canPressOk = false;
                                              Navigator.pop(context);
                                              retry = true;
                                            }
                                          },
                                          child: Text(
                                            'Retry',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      }).then((val) {
    canPressOk = false;
    return retry;
  });
}
