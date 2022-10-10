import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_chat/repos/login_respository.dart';
import 'package:group_chat/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  ChangeNotifierProvider(create:(_)=>LoginRepository.instance(),
    child:Consumer(builder:(_,LoginRepository loginRepo,child){
      return Scaffold(
        body:   Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(

              height: size.height,
              width: size.width,
              child: Image.asset('assets/images/bg.jpeg',fit: BoxFit.cover,),


            ),
            Container(
              padding: EdgeInsets.only(top: size.height/5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/convos.svg',height: 50,width: 50,color: Colors.white,),
                  Text("Convos",style: TextStyle(fontFamily: 'Ultra-Regular',
                      fontSize: 40,color: Colors.white),),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                height:  size.height/1.6,

                width: size.width,
                decoration: BoxDecoration(

                  color: Colors.black.withOpacity(0.1),

                ),
                child: ClipRect(
                    child: BackdropFilter(


                        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                        child:  Container(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.always,
                                  child:
                                  Column(

                                    children: [
                                      TextFormField(

                                        controller:loginRepo.emailController,
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

                                          controller:loginRepo.passwordController,
                                          obscureText: loginRepo.obscureText,
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
                                                loginRepo.obscureText ? Icons.visibility : Icons.visibility_off,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  loginRepo.obscureText = !loginRepo.obscureText;
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

                                      }, child: const Text('Continue',style: TextStyle(fontWeight:FontWeight.bold, color: Colors.black),)),
                                ),
                              ),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('or',style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                  width: size.width/1.1,
                                  height:50,

                                  child:
                                  ElevatedButton(

                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.black),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))

                                      ),
                                      onPressed: (){

                                      }, child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset('assets/images/apple.svg',height: 24,width: 24,color: Colors.white,),
                                      const Text('Continue With Apple',style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),),
                                    ],
                                  )),

                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: size.width/1.1,
                                  height:50,

                                  child: ElevatedButton(

                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.white),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))

                                      ),
                                      onPressed: ()=>loginRepo.googleSignIn(context),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset('assets/images/google.svg',height: 24,width: 24,color: Colors.red,),
                                          const Text('Continue with Google',style: TextStyle(fontWeight:FontWeight.bold, color: Colors.black),),
                                        ],
                                      )),
                                ),
                              ),

                              Row(
                                children: [
                                  const Text("Don't have an account ?",style: TextStyle(fontWeight: FontWeight.bold),),
                                  TextButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                                  }, child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)))
                                ],
                              ),


                              TextButton(onPressed: (){}, child: Text('Forgot you password ?',style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary),)),





                            ],
                          ),




                        ))),
              ),
            ),


          ],
        ),
      );
    }));
  }
}
