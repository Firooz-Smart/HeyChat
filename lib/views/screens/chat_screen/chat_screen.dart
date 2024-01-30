import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/views/screens/chat_screen/components/chat_bubble.dart';
import 'package:hey_chat/views/screens/chat_screen/components/message_bar.dart';

import '../../../data/message.dart';
import '../../../data/profile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static Route<void> route({isRegistering = false}) {
    return MaterialPageRoute(builder: (context) => const ChatScreen());
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};
  @override
  void initState() {
    // TODO: implement initState
    final currentUserId = supabase.auth.currentUser!.id;
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: currentUserId))
            .toList());

    print('message stream started');
    super.initState();
  }

  Future<Profile?> _loadProfile(String profileId) async {
    if (_profileCache[profileId] != null) {
      return _profileCache[profileId];
    }

    final data =
        await supabase.from('profiles').select().eq('id', profileId).single();

    final profile = Profile.fromMap(data);
    _profileCache[profileId] = profile;

    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start Your Conversation Now :)'),
                        )
                      : ListView.builder(
                          itemCount: messages.length,
                          reverse: true,
                          itemBuilder: (context, index) => ChatBubble(
                            message: messages[index],
                            // profile: _profileCache[messages[index].profileId],
                          ),
                        ),
                ),
                const MessageBar()
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}
