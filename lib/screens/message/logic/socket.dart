import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/main.dart';
import 'package:laundry_customer/screens/message/logic/message_provider.dart';
import 'package:laundry_customer/screens/message/model/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvieder extends ChangeNotifier {
  final Ref ref;
  SocketProvieder(this.ref);

  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  io.Socket? socket;

  bool isNotificationShow = true;

  List<MessageModel> globalMessageList = [];

  int orderId = 0;

  Future<void> initSocketConnection() async {
    final Box userBox = Hive.box(AppHSC.userBox);
    if (userBox.isNotEmpty) {
      final userID = userBox.get('id');
      socket =
          io.io('https://laundryrunnerz.createaapp.net:8100', <String, dynamic>{
        'transports': ['websocket'],
        'query': {'userId': userID},
        'autoConnect': false,
      });
      socket!.connect();
      // Set up the onConnect event handler
      socket!.onConnect((data) {
        if (kDebugMode) {
          print('Connected');
        }
        receiveMessage();
      });

      // Set up the onDisconnect event handler
      socket!.onDisconnect((data) {
        if (kDebugMode) {
          print('Disconnected');
        }
      });

      catchError();
    } else {
      if (kDebugMode) {
        print('User not found!');
      }
    }
  }

  void catchError() {
    socket!.on('error', (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void showLocalNotification({required MessageModel messageData}) {
    final String combinedPayload =
        '${messageData.orderId}_${messageData.senderId}_${messageData.receiverId}';

    if ((isNotificationShow && orderId != messageData.orderId) ||
        orderId != messageData.orderId) {
      flutterLocalNotificationsPlugin.show(
        messageData.orderId,
        'Order ${messageData.orderId}',
        messageData.message,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_stat_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: combinedPayload,
      );
    } else {
      print('notification not showing');
    }
  }

  void sendMessage({required MessageModel message}) {
    socket!.emit('message', message.toMap());
    globalMessageList.add(message);
    scrollAnimation();
    messageController.clear();
    notifyListeners();
  }

  void receiveMessage() {
    socket!.on('message', (message) {
      print('Message event: $message');
      final Map<String, dynamic> data = message as Map<String, dynamic>;
      final messageData = MessageModel.fromMap(data);
      globalMessageList.add(messageData);
      notifyListeners();
      showLocalNotification(messageData: messageData);
      if (isNotificationShow && orderId == messageData.orderId) {
        scrollAnimation();
      } else if (!isNotificationShow) {
        scrollAnimation();
      }
    });
  }

  Future<void> getMessage({required int orderID}) async {
    globalMessageList.clear();
    ref
        .read(messageProvider.notifier)
        .getMessages(
          orderId: orderID,
          load: 1,
          perLoad: 5,
        )
        .then((messages) {
      globalMessageList.addAll(messages);
      scrollAnimation();
    });
  }

  List<MessageModel> getMessagesByOrderId(int orderId) {
    return globalMessageList
        .where((message) => message.orderId == orderId)
        .toList();
  }

  Future<void> scrollAnimation() async {
    return Future.delayed(
      const Duration(milliseconds: 100),
      () => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      ),
    );
  }

  void valueSet({required int orderID, required bool show}) {
    isNotificationShow = show;
    orderId = orderID;
    notifyListeners();
  }
}

final socketProvider = ChangeNotifierProvider((ref) => SocketProvieder(ref));
