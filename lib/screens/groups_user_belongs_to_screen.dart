import 'package:flutter/material.dart';
import 'package:group_chat/models/groups_user_belong_to_model.dart';
import '../models/groups_created_by_user_model.dart';
import '../models/get_all_users_per_group_model.dart';
import '../repos/group_repository.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/utils.dart';

class GroupsUserBelongsToScreen extends StatelessWidget {
  const GroupsUserBelongsToScreen(this.username, this.nextToken);
  final String username;
  final String? nextToken;

  @override
  Widget build(BuildContext context) {
    return FutureProvider<GroupsUserBelongToModel?>.value(
        value: GroupRepository.instance().getGroupsUserBelongTo(username,nextToken,10),
        initialData: null,
        catchError: (context, error) {
          throw error!;
        },
        child: Consumer(builder: (BuildContext context,
            GroupsUserBelongToModel? value, Widget? child) {
          return value == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: 210,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: value.getGroupsUserBelongsTo!.items!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 140,
                          height: 210,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color(0xFFfa709a),
                                  Theme.of(context).primaryColor
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureProvider<String?>.value(
                                  value: Utils.getDownloadUrl(
                                      key: value.getGroupsUserBelongsTo!

                                          .items![index]
                                          .groupItem!.groupProfilePicKey!),
                                  catchError: (context, error) {
                                    throw error!;
                                  },
                                  initialData: null,
                                  child: Consumer(builder:
                                      (_, String? groupProfilePicUrl, child) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                          width: 140,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          imageUrl: groupProfilePicUrl ?? "",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor)),
                                          errorWidget: (context, url, ex) =>
                                              CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                radius: 40.0,
                                                child: const Icon(
                                                  Icons.account_circle,
                                                  color: Colors.white,
                                                  size: 40.0,
                                                ),
                                              )),
                                    );
                                  })),
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Text(
                                  value.getGroupsUserBelongsTo!

                                      .items![index]
                                      .groupItem!.name!,
                                 ),

                              ),
                              FutureProvider<GetAllUsersPerGroupModel?>.value(
                                  value: GroupRepository.instance()
                                      .getAllUsersPerGroup(
                                          value.getGroupsUserBelongsTo!

                                              .items![index]
                                              .groupItem!.id!,
                                          nextToken,
                                          10),
                                  initialData: null,
                                  catchError: (context, error) {
                                    throw error!;
                                  },
                                  child: Consumer(builder:
                                      (BuildContext context,
                                          GetAllUsersPerGroupModel? value,
                                          Widget? child) {
                                    return value != null
                                        ? Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),

                                            child: Wrap(

                                              alignment: WrapAlignment.start,
                                              spacing: -20,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        value
                                                            .getAllUsersPerGroup!
                                                            .items!
                                                            .length;
                                                    i++) ...[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0 + i),
                                                    child: ClipOval(
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child:
                                                                CachedNetworkImage(
                                                                    width: 30.0,
                                                                    height:
                                                                        30.0,
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                    imageUrl: value
                                                                        .getAllUsersPerGroup!
                                                                        .items![
                                                                            i]
                                                                        .userItem!
                                                                        .profilePicKey!,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            ex) =>
                                                                        CircleAvatar(
                                                                          backgroundColor: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary,
                                                                          radius:
                                                                              30.0,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.account_circle,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                30.0,
                                                                          ),
                                                                        )))),
                                                  )
                                                ]
                                              ],
                                            ),
                                          )
                                        : Container();
                                  }))
                            ],
                          ),
                        );
                      }),
                );
        }));
  }
}
