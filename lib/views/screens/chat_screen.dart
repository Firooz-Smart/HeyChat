import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/core/helpers.dart';
import 'package:hey_chat/main.dart';
import 'package:hey_chat/views/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/message.dart';
import '../../data/profile.dart';

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
        .order('create_at')
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: currentUserId))
            .toList());
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
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final messages = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? const Center(
                            child: Text('Start Your Conversation Now :)'))
                        : ListView.builder(
                            itemBuilder: (context, index) => Text(''),
                          ),
                  )
                ],
              );
            } else {
              return preloader;
            }
          },
        ));
  }
}
