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

import '../models/user_item.dart';
import '../models/user_profile_model.dart';
import '../utils/shared_preferences.dart';
import '../utils/utils.dart';

class ProfileRepository extends ChangeNotifier {
  ProfileRepository.instance();

  final usernameController = TextEditingController();

  S3UploadFileOptions? options;
  bool _loading = false;
  String _userId = '';
  String _username = '';
  String _email = '';
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
  String _profilePicKey = "";

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

    print("email is $email");
    loading = true;

    try {
      String graphQLDocument = '''
      mutation create(
            \$username: String!
            \$email: String!
    
            
            \$profilePicKey:String!
           ) {
  createUserAccount(input: {

 email: \$email, 

  profilePicKey: \$profilePicKey, username: \$username}) {
    email
    id
    profilePicKey
    username
  }
}
      ''';

      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
        document: graphQLDocument,
        apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
        variables: {
          "email": email,
          "profilePicKey": profilePicKey,
          "username": usernameController.text,
        },
      ));

      var response = await operation.response;

      var data = response.data;
      if (response.data != null) {

        SharedPrefsUtils.instance().saveUsername(usernameController.text).then((value){
          if (kDebugMode) {
            print('username saved');

          }});

        if (kDebugMode) {
          print('Mutation result is${data!}');
          loading = false;
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Mutation error: ${response.errors}');
        }
       // showInSnackBar(BuildContext context, String value)
        loading = false;
        return false;
      }
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
      loading = false;
      return false;
    }
  }

  void showInSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20.0),
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

  Future<UserItem> getAUserProfile(String username) async{

    String graphQLDocument =
    '''query getUser(\$userId: String!) {
  getUserAccount(userId: \$userId) {
    email
    id
    profilePicKey
    username
  }
}
''';

    var operation = Amplify.API.query(


        request: GraphQLRequest<String>(document: graphQLDocument, apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
          variables: {
            "userId": username

          },));



    var response = await operation.response;

    final responseJson = json.decode(response.data!);
    if (kDebugMode) {
      print("here$responseJson['getUserAccount");
    }
    return UserItem.fromJson(responseJson['getUserAccount']);

  }

  Future<UserProfileModel> getUserProfiles() async{

    String graphQLDocument =
    '''query get {
  getAllUserAccounts {
    items {
      email
      id
      username
      profilePicKey
    }
    nextToken
  }
}''';

    var operation = Amplify.API.query(


        request: GraphQLRequest<String>(document: graphQLDocument, apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",));



    var response = await operation.response;

    final responseJson = json.decode(response.data!);
    if (kDebugMode) {
      print("here$responseJson");
    }
    return UserProfileModel.fromJson(responseJson);

  }

  Future<void> uploadProfilePicture(
      String imageFilePath, String targetPath) async {
    var uuid = const Uuid().v1();
    final awsFile = AWSFilePlatform.fromFile(File(imageFilePath));
    try {
      final uploadResult = await Amplify.Storage.uploadFile(
        key: '$uuid.png',
        localFile: awsFile,
      ).result;

      safePrint('Uploaded file: ${uploadResult.uploadedItem.key}');
      profilePicKey = uploadResult.uploadedItem.key;

      final resultDownload = await Utils.getDownloadUrl(key: profilePicKey);
      if (kDebugMode) {
        print(resultDownload);
      }
      profilePic = resultDownload;

      loading = false;

      if (kDebugMode) {
        print("Download Url is $resultDownload");
        print("the key is $profilePicKey");
      }
    } on StorageException catch (e) {
      safePrint("error message is${e.message}");
      loading = false;
      safePrint('Error uploading file: ${e.message}');
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      Amplify.Auth.signOut();
      return logout = true;
    } on AuthException catch (e) {
      print(e.message);
      return logout = false;
    }
  }

  Future<String> retrieveEmail() async {
    var res = await Amplify.Auth.fetchUserAttributes();
    res.forEach((element) {
      if (kDebugMode) {
        print("element is${element.value}");
      }
    });
    return res[4].value;
  }

  Future<AuthUser> retrieveCurrentUser() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    return authUser;
  }
}
