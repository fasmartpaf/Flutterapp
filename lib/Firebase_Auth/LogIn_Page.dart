import 'package:flutter/material.dart';

import 'Models_Class.dart';
import 'Sign_UP.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController Passwordcontroller=TextEditingController();

  String get deviceid => '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 200,left: 45,right: 45),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height:15,),
            TextFormField(
              controller: emailcontroller,
              decoration: InputDecoration(
                  fillColor: Color(0xffDCE6FF),
                  filled: true,
                  hintText: 'Email',
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            TextFormField(
              obscureText: true,
              controller: Passwordcontroller,
              decoration: InputDecoration(
                fillColor: Color(0xffDCE6FF),
                  filled: true,
                  hintText: 'Passwort',
                  border: OutlineInputBorder()),
            ),
             SizedBox(height: 20,),
            Container(
              height: 50,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FlatButton(
                onPressed: () {
                  Firebases().Loginauth(emailcontroller.text, Passwordcontroller.text, context);
                },
                child: Center(
                    child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60,right: 20),
              child: Row(
                children: [
                  Text("Kein Konto?",style: TextStyle(fontWeight: FontWeight.bold),),
                  TextButton(
                      onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>
                 SignUp()
                 ));
                      },
                      child: Text(
                        'Registrieren',
                        style: TextStyle(fontSize: 15,color: Colors.pink,fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
