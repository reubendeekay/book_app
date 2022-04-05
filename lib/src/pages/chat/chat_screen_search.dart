import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/helpers/my_loader.dart';
import 'package:bookapp/screens/providers/chat_provider.dart';
import 'package:bookapp/src/pages/chat/widgets/chat_tile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChatScreenSearch extends StatefulWidget {
  static const routeName = '/chat-screen-search';

  const ChatScreenSearch({Key? key}) : super(key: key);

  @override
  _ChatScreenSearchState createState() => _ChatScreenSearchState();
}

class _ChatScreenSearchState extends State<ChatScreenSearch> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final contacts = Provider.of<ChatProvider>(context)
        .contactedUsers
        .where((element) =>
            element.user!.fullName!.contains(searchController.text))
        .toList();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: TextField(
            controller: searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
          ),
        ),
        body: searchController.text.isNotEmpty
            ? FutureBuilder<List<ChatTileModel>>(
                future: Provider.of<ChatProvider>(context)
                    .searchUser(searchController.text),
                builder: (ctx, data) => !data.hasData
                    ? const MyLoader()
                    : ListView(
                        children: [
                          ...List.generate(
                              data.data!.length,
                              (index) => ChatTile(
                                    roomId: data.data![index].chatRoomId!,
                                    chatModel: data.data![index],
                                  ))
                        ],
                      ),
              )
            : null);
  }
}
