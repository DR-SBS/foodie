import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodie/http.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import './personaldetails_screen.dart';
import '../widgets/one_number.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);
  static const routeName = '/login-otp';

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isloading = false;
  bool _didnotreceive = false;
  // final otpController = TextEditingController();
  final TextEditingController _first = TextEditingController();
  final TextEditingController _second = TextEditingController();
  final TextEditingController _third = TextEditingController();
  final TextEditingController _forth = TextEditingController();
  final TextEditingController _fifth = TextEditingController();
  final TextEditingController _sixth = TextEditingController();
  String otp = '';

  Future<void> submit(String phoneNumber) async {
    try {
      // var url = Uri.http('10.0.2.2:8000', 'accounts/login/');
      otp = _first.text +
          _second.text +
          _third.text +
          _forth.text +
          _fifth.text +
          _sixth.text;

      setState(() {
        _isloading = true;
      });
      await Provider.of<Auth>(context, listen: false).signup(phoneNumber, otp);
      if (Provider.of<Auth>(context, listen: false).isAuth) {
        Navigator.of(context).pushReplacementNamed(
          PersonalDetails.routeName,
        );
        setState(() {
          _isloading = false;
        });
      } else {
        setState(() {
          _isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid OTP"),
        ));
      }
    } catch (error) {
      print("error3");
      print(error);
    }
    // // ignore: unused_local_variable
    // final http.Response response = await http.post(
    //   url,
    //   body: json.encode(
    //     {
    //       'mobile': phoneNumber,
    //       'otp': _first.text +
    //           _second.text +
    //           _third.text +
    //           _forth.text +
    //           _fifth.text +
    //           _sixth.text,
    //     },
    //   ),
    // );
    // var status = response;
    // if (status == 200) {
    //   // Navigator.of(context).pushAndRemoveUntil(
    //   //   MaterialPageRoute(
    //   //       builder: (BuildContext context) => const TabScreen()),
    //   //   ModalRoute.withName(TabScreen.routeName),
    //   // );
    //   Navigator.of(context).pushNamed(PersonalDetails.routeName);
    //   // print(response.body);
    // } else {
    setState(() {
      _isloading = false;
    });
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text("Invalid OTP"),
    //   ));
    // }
    // } catch (e) {
    // print(e);
  }

  void enableResendButton() {
    Future.delayed(const Duration(seconds: 30),
        () => setState(() => {_didnotreceive = true}));
  }

  @override
  void initState() {
    super.initState();
    enableResendButton();
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = ModalRoute.of(context)!.settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('OTP Vertifcation'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'We have sent a verification code to ',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                '$phoneNumber',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OneNumber(_first, true),
                  OneNumber(_second, false),
                  OneNumber(_third, false),
                  OneNumber(_forth, false),
                  OneNumber(_fifth, false),
                  OneNumber(_sixth, false),
                ],
              ),
              // Container(
              //     margin: EdgeInsets.symmetric(
              //         horizontal: MediaQuery.of(context).size.width * 0.2),
              //     child: TextField(
              //       decoration: const InputDecoration(
              //           hintText: 'Enter OTP', border: OutlineInputBorder()),
              //       autofocus: true,
              //       maxLength: 6,
              //       keyboardType: TextInputType.number,
              //       controller: otpController,
              //       onChanged: (string) => {
              //         if (string.length == 6)
              //           {
              //             setState(
              //               () {
              //                 _isEnabled = true;
              //               },
              //             )
              //           }
              //         else
              //           {
              //             setState(() {
              //               _isEnabled = false;
              //             })
              //           }
              //       },
              //     )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive a code ?"),
                  TextButton(
                      onPressed: _didnotreceive
                          ? () {
                              submitNumber(phoneNumber as String, context);
                            }
                          : null,
                      child: const Text('Resend'))
                ],
              ),
              _isloading
                  ? const CircularProgressIndicator(
                      strokeWidth: 3,
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: _sixth.text.isEmpty
                            ? null
                            : () => submit(phoneNumber.toString()),
                        child: const Text('Proceed'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
