import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/repos/group_repository.dart';
import 'package:group_chat/screens/create_group_screen.dart';
import 'package:group_chat/screens/create_user_account.dart';
import 'package:group_chat/repos/profile_repository.dart';
import 'package:group_chat/screens/home_screen.dart';
import 'package:group_chat/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initializeApp() async{
    await _configureAmplify();
  }


  Future<void> _configureAmplify() async {

    try{


      await Amplify.addPlugins([

        AmplifyAuthCognito(),
        AmplifyAPI(),
        AmplifyStorageS3()
      ]);

      // Once Plugins are added, configure Amplify
      await Amplify.configure(amplifyconfig);



    } catch(e) {
      if (kDebugMode) {
        print('an error occured during amplify configuration: $e');
      }



    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeApp();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Group Chat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Montserrat',


        primaryColor: const Color(0xFFfae15f),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFd33f2b))
      ),
     home: const HomeScreen(),
     // home: CreateUserAccountScreen(email: 'email',),
/*
     home: ChangeNotifierProvider(create:(_) =>ProfileRepository.instance(),
         child:CreateUserAccountScreen(email: 'email',)),


 */

    );


  }
}

