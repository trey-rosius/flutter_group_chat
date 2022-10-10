import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(

      body:   Stack(
alignment: Alignment.topCenter,
        children: [
          SizedBox(

            height: size.height,
            width: size.width,
            child: Image.asset('assets/images/bg.jpeg',fit: BoxFit.cover,),


          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 40,left: 10),
              child: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.white,), onPressed: () {
                Navigator.of(context).pop();
              },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: size.height/5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/convos.svg',height: 50,width: 50,color: Colors.white,),
                const Text("Convos",style: TextStyle(fontFamily: 'Ultra-Regular',
                    fontSize: 40,color: Colors.white),),
              ],
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                height:  size.height/1.8,

                decoration: BoxDecoration(

                  color: Colors.black.withOpacity(0.1),

                ),
                child: ClipRect(
                    child: BackdropFilter(


                        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                        child:  Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.always,
                                  child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        padding:EdgeInsets.only(bottom: 20,top: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text("Looks like you don't have an account.",
                                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                            Text("Let's create one for you ",
                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),

                                          ],
                                        ),

                                      ),
                                      TextFormField(

                                        controller:emailController,
                                        validator: (value) {

                                          if (value == null) {
                                            return "Email";
                                          }
                                        },

                                        // enabled: false,
                                        // keyboardType: TextInputType.number,
                                        decoration:  InputDecoration(
                                          fillColor: Colors.white,
                                          labelText: "email",
                                          contentPadding: new EdgeInsets.all(18.0),
                                          filled: true,
                                          floatingLabelStyle: const TextStyle(color: Colors.black),
                                          border:  OutlineInputBorder(
                                              borderSide:  const BorderSide(
                                                  width: 2.0, color: Colors.white),
                                              borderRadius: BorderRadius.circular(100)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: (Colors.grey.withOpacity(0.2)), width: 2),
                                              borderRadius: BorderRadius.circular(10)
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 2),

                                              borderRadius: BorderRadius.circular(10)


                                          ),

                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        child: TextFormField(

                                          controller:passwordController,
                                          obscureText: obscureText,
                                          validator: (value) {

                                            if (value == null) {
                                              return "password";
                                            }
                                          },


                                          // enabled: false,
                                          // keyboardType: TextInputType.number,

                                          decoration:  InputDecoration(
                                            fillColor: Colors.white,

                                            labelText: "password",
                                            contentPadding: new EdgeInsets.all(18.0),
                                            filled: true,
                                            floatingLabelStyle: TextStyle(color: Colors.black),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obscureText ? Icons.visibility : Icons.visibility_off,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  obscureText = !obscureText;
                                                });


                                              },
                                            ),
                                            border:  OutlineInputBorder(
                                                borderSide:  BorderSide(
                                                    width: 2.0, color: Colors.white),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: (Colors.grey.withOpacity(0.2)), width: 2),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 2),

                                                borderRadius: BorderRadius.circular(10)


                                            ),),


                                        ),
                                      ),

                                    ],
                                  )),

                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("By Selecting Agree and Continue below, you agree to",style: TextStyle(
                                      fontWeight: FontWeight.bold,color: Colors.white
                                    ),),

                                        TextButton(onPressed: (){}, child: Text('Terms of Service and Privacy Policy',
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),))


                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: SizedBox(
                                  width: size.width/1.1,
                                  height:50,

                                  child: ElevatedButton(

                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))

                                      ),
                                      onPressed: (){

                                      }, child: const Text('Agree and Continue',style: TextStyle(fontWeight:FontWeight.bold, color: Colors.black),)),
                                ),
                              ),








                            ],
                          ),




                        ))),
              ),
            ),


        ],
      ),
    );
  }
}
