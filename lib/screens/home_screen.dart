import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/repos/chat_repository.dart';
import 'package:group_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/group_model.dart';
import '../models/user_item.dart';
import '../models/user_profile_model.dart';
import '../repos/group_repository.dart';
import '../repos/profile_repository.dart';
import '../utils/shared_preferences.dart';
import '../utils/utils.dart';
import 'create_group_screen.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
                                FutureProvider<GroupModel?>.value(
                                    value: GroupRepository.instance()
                                        .getUserGroups(username),
                                    initialData: null,
                                    catchError: (context, error) {
                                      throw error!;
                                    },
                                    child: Consumer(builder:
                                        (BuildContext context,
                                            GroupModel? value, Widget? child) {
                                      return value == null
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Container(
                                              child: Expanded(
                                                  child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverWovenGridDelegate.count(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 8,
                                                crossAxisSpacing: 8,
                                                pattern: [
                                                  const WovenGridTile(1),
                                                  const WovenGridTile(
                                                    5 / 7,
                                                    crossAxisRatio: 0.9,
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerEnd,
                                                  ),
                                                ],
                                              ),
                                              itemCount: value
                                                  .getAllGroupsCreatedByUser!
                                                  .items!
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  //color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      FutureProvider<
                                                              String?>.value(
                                                          value: Utils.getDownloadUrl(
                                                              key: value
                                                                  .getAllGroupsCreatedByUser!
                                                                  .items![index]
                                                                  .groupProfilePicKey!),
                                                          catchError:
                                                              (context, error) {
                                                            throw error!;
                                                          },
                                                          initialData: null,
                                                          child: Consumer(
                                                              builder: (_,
                                                                  String?
                                                                      groupProfilePicUrl,
                                                                  child) {
                                                            return ClipRRect(
                                                              borderRadius: BorderRadius.circular(100),
                                                              
                                                              child: CachedNetworkImage(
                                                                  width: 100,
                                                                  height: 100.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl:
                                                                      groupProfilePicUrl ??
                                                                          "",
                                                                  placeholder: (context,
                                                                          url) =>
                                                                       CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                                                  errorWidget:
                                                                      (context,
                                                                              url,
                                                                              ex) =>
                                                                          CircleAvatar(
                                                                            backgroundColor: Theme.of(context)
                                                                                .colorScheme
                                                                                .secondary,
                                                                            radius:
                                                                                40.0,
                                                                            child:
                                                                                const Icon(
                                                                              Icons.account_circle,
                                                                              color:
                                                                                  Colors.white,
                                                                              size:
                                                                                  40.0,
                                                                            ),
                                                                          )),
                                                            );
                                                          })),
                                                      Container(
                                                        margin:const EdgeInsets.only(top: 10),
                                                        padding:const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              begin: Alignment.topRight,
                                                              end: Alignment.bottomLeft,
                                                              colors: [
                                                                const Color(0xFFfa709a),
                                                                Theme.of(context).primaryColor

                                                              ],
                                                            ),
                                                            shape: BoxShape.rectangle),
                                                        child: Text(value
                                                            .getAllGroupsCreatedByUser!
                                                            .items![index]
                                                            .name!),
                                                      ),




                                                    ],
                                                  ),
                                                );
                                              },
                                            )

                                                  ));
                                    }))
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
                              ChangeNotifierProvider(create: (_) => ChatRepository.instance()),
                              FutureProvider<UserItem?>.value(
                                  value: ProfileRepository.instance().getAUserProfile(
                            username), initialData: null,
                              catchError: (context,error) => throw error!,),

                            ],

                            child: GroupChatScreen(username));
                            /*
                            child: CreateGroupScreen(
                              username: username,
                            ));

                             */
                      }));


                    },
                    child: const Icon(Icons.group_add),
                  ),
                );
        }));
  }
}
