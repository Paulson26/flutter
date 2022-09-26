import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter/foundation.dart';
import 'package:my_thera/screens/client/payment/paypal_patment.dart';

class Billinf extends StatefulWidget {
  Billinf({Key? key}) : super(key: key);

  @override
  State<Billinf> createState() => _BillinfState();
}

class _BillinfState extends State<Billinf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('Billing'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/logo.png'),
              ),
              Container(
                child: Column(
                  children: [
                    Text('info@theralogic.app (801) 391-3676 '),
                    Text('2314 Washington Blvd, Ogden, UT 84401')
                  ],
                ),
              ),
              const Divider(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          'Clinic Information:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Clinic Name : clinic '),
                        Text('bjhhbhjbj,bhjbhh '),
                        Text('Email: c '),
                        Text('Phone: +48 444 666 3333'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          'Client / Insurance Information:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Client Name : john vvbhfh s  '),
                        Text('Insurance Id: 123456 '),
                        Text('Age : 27 '),
                        Text('Gender : Male'),
                        Text('Email: john@gmail.com'),
                        Text('Phone: 78888788878'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          'Appointment Information:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Clinician Name : clinician clinician  '),
                        Text('Appointment Date: 2022-04-01 '),
                        Text('Appointment Time: 16:33:00'),
                        Text('Email: info@webz.com.pl'),
                        Text('Phone: +48 444 666 3333'),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    "#",
                  ),
                  Text(
                    "Item",
                  ),
                  Text(
                    "Description",
                  ),
                  Text(
                    "CPTCode",
                  ),
                  Text(
                    "Cost",
                  ),
                  Text(
                    "Total",
                  )
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    "#",
                  ),
                  Text(
                    "Item",
                  ),
                  Text(
                    "Description",
                  ),
                  Text(
                    "CPTCode",
                  ),
                  Text(
                    "Cost",
                  ),
                  Text(
                    "Total",
                  )
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text("Subtotal"),
                  Text("90"),
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text("Total"),
                  Text("90"),
                ],
              ),
              const Divider(
                height: 50,
              ),
              Center(
                child: TextButton(
                    onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaypalPayment(
                                    onFinish: (number) async {
                                      // payment done
                                      print('order id: ' + number);
                                    },
                                  )))
                        },
                    child: const Text("Make Payment")),
              )
            ],
          ),
        ));
  }
}
