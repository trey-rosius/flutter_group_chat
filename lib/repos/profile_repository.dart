import 'dart:convert';
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class ProfileRepository extends ChangeNotifier {

  ProfileRepository.instance();



  final usernameController = TextEditingController();





  S3UploadFileOptions? options;
  bool _loading = false;
  String _userId='';
  String _username='';
  String _email='';
  bool _logout = false;


  String get email => _email;



  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get username => _username;

  set username(String value) {
    _username = value;
    notifyListeners();
  }
  bool get logout => _logout;

  set logout(bool value) {
    _logout = value;
    notifyListeners();
  }
  String get userId => _userId;

  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  String _profilePic = "";
  String _profilePicKey ="";


  String get profilePicKey => _profilePicKey;

  set profilePicKey(String value) {
    _profilePicKey = value;
    notifyListeners();
  }

  String get profilePic => _profilePic;

  set profilePic(String value) {
    _profilePic = value;
    notifyListeners();
  }


  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }


 Future<bool> createUserAccount(String email) async {




    loading = true;

    try {
      String graphQLDocument =
      '''
      mutation create(
            \$username: String!
            \$email: String!
    
            
            \$profilePicUrl:String!
           ) {
  createUserAccount(input: {

 email: \$email, 

  profilePicUrl: \$profilePicUrl, username: \$username}) {
    email
    id
    profilePicUrl
    username
  }
}
      ''';

      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
            document: graphQLDocument,
            apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
            variables: {

              "email":email,

              "profilePicUrl":profilePic,
              "username":usernameController.text,

            },
          ));

      var response = await operation.response;

      var data = response.data;
      if(response.data != null){
        if (kDebugMode) {
          print('Mutation result is' + data!);
          loading = false;

        }
        return true;
      }else{

        print('Mutation error: ' + response.errors.toString());
        loading = false;
        return false;
      }







    } catch (ex) {

      print(ex.toString());
      loading = false;
      return false;

    }


  }



  void showInSnackBar(BuildContext context,String value) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle( fontSize: 20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ));
  }



  @override
  void dispose() {
    // TODO: implement dispose

    usernameController.dispose();



    super.dispose();
  }


  Future<void> uploadImage(String imageFilePath,String targetPath)async {
    var uuid =  const Uuid().v1();
    S3UploadFileOptions  options = S3UploadFileOptions(accessLevel: StorageAccessLevel.guest,);
    try {
      UploadFileResult result  =  await Amplify.Storage.uploadFile(
          key: uuid,
          local: File(imageFilePath),
          options: options
      );
      profilePicKey  = result.key;
      if (kDebugMode) {
        print("the key is "+profilePicKey);
      }
      GetUrlResult resultDownload =
          await Amplify.Storage.getUrl(key: profilePicKey);
      if (kDebugMode) {
        print(resultDownload.url);
      }
      profilePic = resultDownload.url;
      loading = false;

    } on StorageException catch (e) {
      print("error message is" + e.message);
      loading= false;
    }
  }

  Future<bool>signOut() async{
    try {
      Amplify.Auth.signOut();
      return logout = true;
    } on AuthException catch (e) {

      print(e.message);
      return logout  = false;
    }
  }

  Future<String> retrieveEmail() async{
    var res = await Amplify.Auth.fetchUserAttributes();
    res.forEach((element) {
      print("element is"+element.value);
    });
    return res[4].value;
  }
  Future<AuthUser>retrieveCurrentUser() async{
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    return authUser;
  }



}