import 'package:laundry_customer/screens/message/model/message.dart';
import 'package:laundry_customer/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageRepo {
  final Ref ref;
  MessageRepo(this.ref);

  final dio = getDio();

  Future<List<MessageModel>> getMessages({
    required int orderId,
    required int load,
    required int perLoad,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    queryParameters['orderId'] = orderId;
    queryParameters['load'] = load;
    queryParameters['perLaod'] = perLoad;

    final response =
        await dio.get('/get/messages', queryParameters: queryParameters);

    final List<dynamic> data =
        response.data['data']['messages'] as List<dynamic>;
    final List<Map<String, dynamic>> messageMaps =
        data.cast<Map<String, dynamic>>();
    final List<MessageModel> messages =
        messageMaps.map((message) => MessageModel.fromMap(message)).toList();

    return messages;
  }
}

final messageRepo = Provider((ref) => MessageRepo(ref));
