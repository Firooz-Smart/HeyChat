import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hey_chat/core/constants.dart';
import 'package:hey_chat/core/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    // TODO: implement initState
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _messageController,
                  decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(8.0)),
                ),
              ),
              TextButton(onPressed: _submitMessage, child: const Text('Send'))
            ],
          ),
        ),
      ),
    );
  }

  void _submitMessage() async {
    final text = _messageController.text;

    if (text.isEmpty) {
      return;
    }

    final profileId = supabase.auth.currentUser!.id;

    try {
      await supabase
          .from('messages')
          .insert({'profile_id': profileId, 'content': text});

      _messageController.clear();
    } on PostgrestException catch (e) {
      context.showErrorSnackBar(message: e.message);
    } catch (e) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }
}
