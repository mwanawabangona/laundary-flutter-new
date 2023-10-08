import 'package:laundry_customer/screens/message/logic/message_repo.dart';
import 'package:laundry_customer/screens/message/model/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  MessageStateNotifier(this.ref) : super(false);

  Future<List<MessageModel>> getMessages({
    required int orderId,
    required int load,
    required int perLoad,
  }) async {
    state = true;
    final messageList = await ref
        .read(messageRepo)
        .getMessages(orderId: orderId, load: load, perLoad: perLoad);
    state = false;
    return messageList;
  }
}
