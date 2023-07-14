import 'dart:convert';
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class GroupRepository extends ChangeNotifier {

  GroupRepository.instance();



  final nameController = TextEditingController();
  final descriptionController = TextEditingController();





  S3UploadFileOptions? options;
  bool _loading = false;
  String _userId='';

  bool _logout = false;



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

  String _groupProfilePic = "";
  String _groupProfilePicKey ="";


  String get groupProfilePic => _groupProfilePic;

  String get groupProfilePicKey => _groupProfilePicKey;

  set groupProfilePicKey(String value) {
    _groupProfilePicKey = value;
    notifyListeners();
  }

  set groupProfilePic(String value) {
    _groupProfilePic = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }


  Future<bool> createGroup(String email) async {




    loading = true;

    try {
      String graphQLDocument =
      '''
      mutation create(
            \$name: String!
            \$description: String!
            \$userId: String!
            
            \$groupProfilePicUrl:String!
           ) {
  createGroup(input: {

 name: \$name, 
 userId:\$userId,

  groupProfilePicUrl: \$groupProfilePicUrl, description: \$description}) {
    userId
    id
    groupProfilePicUrl
    name
    description
  }
}
      ''';

      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
            document: graphQLDocument,
            apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
            variables: {

              "userId":userId,


              "groupProfilePicUrl":groupProfilePic,
              "name":nameController.text,
              "description":descriptionController.text,

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

    nameController.dispose();
    descriptionController.dispose();



    super.dispose();
  }


  Future<void> uploadImage(String imageFilePath,String targetPath)async {
    /*
    var uuid =  const Uuid().v1();
    S3UploadFileOptions  options = S3UploadFileOptions(accessLevel: StorageAccessLevel.guest,);
    try {
      UploadFileResult result  =  await Amplify.Storage.uploadFile(
          key: uuid,
          local: File(imageFilePath),
          options: options
      );
      groupProfilePicKey  = result.key;
      if (kDebugMode) {
        print("the key is "+groupProfilePicKey);
      }
      GetUrlResult resultDownload =
      await Amplify.Storage.getUrl(key: groupProfilePicKey);
      if (kDebugMode) {
        print(resultDownload.url);
      }
      groupProfilePic = resultDownload.url;
      loading = false;

    } on StorageException catch (e) {
      print("error message is" + e.message);
      loading= false;
    }

     */
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