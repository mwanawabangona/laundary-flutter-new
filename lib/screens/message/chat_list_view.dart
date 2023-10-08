import 'package:laundry_customer/screens/message/logic/socket.dart';
import 'package:laundry_customer/screens/message/receiver_row.dart';
import 'package:laundry_customer/screens/message/sender_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListView extends ConsumerWidget {
  final int customerId;
  final int orderId;
  const ChatListView({
    super.key,
    required this.customerId,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      physics: const BouncingScrollPhysics(),
      controller: ref.watch(socketProvider).scrollController,
      itemCount: ref.watch(socketProvider).getMessagesByOrderId(orderId).length,
      itemBuilder: (context, index) {
        final message =
            ref.watch(socketProvider).getMessagesByOrderId(orderId)[index];
        return (message.senderId == customerId)
            ? SenderRowView(senderMessage: message.message)
            : ReceiverRowView(receiverMessage: message.message);
      },
    );
  }
}
