import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/screens/groups_user_belongs_to_screen.dart';
import 'package:provider/provider.dart';
import '../repos/group_repository.dart';
import '../utils/shared_preferences.dart';
import 'create_group_screen.dart';
import 'groups_created_by_user_screen.dart';
import 'login_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? nextToken;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureProvider<String?>(
        create: (BuildContext context) {
          return SharedPrefsUtils.instance().getUserName();
        },
        initialData: null,
        child: Consumer<String?>(builder: (_, String? username, child) {
          return username == null
              ? LoginScreen()
              : Scaffold(
                  body: Stack(
                    children: [
                      SizedBox(
                          height: size.height,
                          width: size.width,
                          child: Image.asset(
                            'assets/images/bg.jpeg',
                            fit: BoxFit.cover,
                          )),
                      SingleChildScrollView(
                        child: Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: ClipRect(
                              child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SafeArea(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  const Color(0xFFfa709a),
                                                  Theme.of(context).primaryColor
                                                  // Color(0XFFfee140)
                                                ],
                                              ),
                                              shape: BoxShape.rectangle),
                                          child: const Text("Groups"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    const Color(0xFFfa709a),
                                    Theme.of(context).primaryColor
                                    // Color(0XFFfee140)
                                  ],
                                ),
                                shape: BoxShape.rectangle),
                            child: const Text("My Groups"),
                          ),
                          //put groups created by user here
                                GroupsCreatedByUserScreen(username,nextToken),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          const Color(0xFFfa709a),
                                          Theme.of(context).primaryColor
                                          // Color(0XFFfee140)
                                        ],
                                      ),
                                      shape: BoxShape.rectangle),
                                  child: const Text("Added Groups"),
                                ),
                                GroupsUserBelongsToScreen(username,nextToken),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                  create: (_) => GroupRepository.instance()),
                            ],
                            child: CreateGroupScreen(
                              username: username,
                            ));
                      }));

/*
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(create: (_) => ChatRepository.instance()),
                              FutureProvider<UserItem?>.value(
                                  value: ProfileRepository.instance().getAUserProfile(
                            username), initialData: null,
                              catchError: (context,error) => throw error!,),

                            ],

                            child: GroupChatScreen(username));


                      }));
*/
                    },
                    child: const Icon(Icons.group_add),
                  ),
                );
        }));
  }
}
