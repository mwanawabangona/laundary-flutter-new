// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/screens/message/chat_list_view.dart';
import 'package:laundry_customer/screens/message/logic/message_provider.dart';
import 'package:laundry_customer/screens/message/logic/socket.dart';
import 'package:laundry_customer/screens/message/model/message.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final MessageScreenArgument messageScreenArgument;
  const MessageScreen({
    super.key,
    required this.messageScreenArgument,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(socketProvider)
          .valueSet(orderID: widget.messageScreenArgument.orderId, show: false);
      ref
          .read(socketProvider)
          .getMessage(orderID: widget.messageScreenArgument.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text('Contact'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(socketProvider).valueSet(orderID: 0, show: true);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.warning))
        ],
      ),
      body: ref.watch(messageProvider)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ChatListView(
                    customerId: widget.messageScreenArgument.senderId,
                    orderId: widget.messageScreenArgument.orderId,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.gray,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ).copyWith(left: 8, right: 30),
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          color: AppColors.lightgray,
                          child: TextFormField(
                            controller:
                                ref.read(socketProvider).messageController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 6,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Enter your message...',
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final MessageModel message = MessageModel(
                            orderId: widget.messageScreenArgument.orderId,
                            senderId: widget.messageScreenArgument.senderId,
                            receiverId: widget.messageScreenArgument.receiverId,
                            message:
                                ref.read(socketProvider).messageController.text,
                          );
                          ref.read(socketProvider).sendMessage(
                                message: message,
                              );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class MessageScreenArgument {
  int orderId;
  int senderId;
  int receiverId;
  MessageScreenArgument({
    required this.orderId,
    required this.senderId,
    required this.receiverId,
  });
}
