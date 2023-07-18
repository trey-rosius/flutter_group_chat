import 'dart:convert';
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import '../utils/utils.dart';

class GroupRepository extends ChangeNotifier {

  GroupRepository.instance();



  final nameController = TextEditingController();
  final descriptionController = TextEditingController();




  bool _loading = false;
  String _userId='';

  bool _logout = false;

  String? _groupId;


  String? get groupId => _groupId;

  set groupId(String? value) {
    _groupId = value;
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


  Future<bool> createGroup(String username) async {

  print("username is $username");


    loading = true;

    try {
      String graphQLDocument =
      '''
      mutation create(
            \$name: String!
            \$description: String!
            \$userId: String!
            
            \$groupProfilePicKey:String!
           ) {
  createGroup(input: {

 name: \$name, 
 userId:\$userId,

  groupProfilePicKey: \$groupProfilePicKey, description: \$description}) {
    userId
    id
    groupProfilePicKey
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

              "userId":username,


              "groupProfilePicKey":groupProfilePicKey,
              "name":nameController.text,
              "description":descriptionController.text,

            },
          ));

      var response = await operation.response;


      if(response.data != null){
        var data = json.decode(response.data!);
        if (kDebugMode) {
          print('Mutation result is${data!}');

          groupId = data["createGroup"]['id'];
          print('Group Id is${data["createGroup"]['id']}');
          print('Group name is${data["createGroup"]['name']}');
          loading = false;

        }
        return true;
      }else{

        if (kDebugMode) {
          print('Mutation error: ${response.errors}');
        }
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

  Future<void> uploadGroupProfilePic(String imageFilePath,String targetPath) async {
    var uuid =  const Uuid().v1();
    final awsFile = AWSFilePlatform.fromFile(File(imageFilePath));
    try {
      final uploadResult =  await Amplify.Storage.uploadFile(
          key: '$uuid.png',
          localFile: awsFile,

      ).result;


      safePrint('Uploaded file: ${uploadResult.uploadedItem.key}');
      groupProfilePicKey = uploadResult.uploadedItem.key;

      groupProfilePic= await Utils.getDownloadUrl(key: groupProfilePicKey);
      if (kDebugMode) {
        print("group profile pic $groupProfilePic");
      }

      loading = false;

      if (kDebugMode) {
        print("the key is $groupProfilePicKey");
      }


    } on StorageException catch (e) {
      safePrint("error message is${e.message}");
      loading= false;
      safePrint('Error uploading file: ${e.message}');
      rethrow;
    }
  }


  Future<String> retrieveEmail() async{
    var res = await Amplify.Auth.fetchUserAttributes();
    res.forEach((element) {
      if (kDebugMode) {
        print("element is${element.value}");
      }
    });
    return res[4].value;
  }
  Future<AuthUser>retrieveCurrentUser() async{
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    return authUser;
  }


}