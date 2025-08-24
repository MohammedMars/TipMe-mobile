//lib\net\auth_tip_receiver\auth_tip_receiver_api_executer_impl.dart
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/net/auth_tip_receiver/model/signup/sign_up_body_request.dart';
import 'package:tipme_app/net/auth_tip_receiver/signup/auth_tip_receiver_api_executer.dart';

class AuthTipReceiverApiExecuterImpl implements AuthTipReceiverApiExecuter {
  final DioClient _client;
  AuthTipReceiverApiExecuterImpl(this._client);
  @override
  Future<void> signUp(SignUpBodyRequest body) async {
    await _client.post("Signup", data: body.toJson());
  }
}
