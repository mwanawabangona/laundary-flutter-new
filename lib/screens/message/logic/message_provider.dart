import 'package:laundry_customer/screens/message/logic/message_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider =
    StateNotifierProvider<MessageStateNotifier, bool>((ref) {
  return MessageStateNotifier(ref);
});
