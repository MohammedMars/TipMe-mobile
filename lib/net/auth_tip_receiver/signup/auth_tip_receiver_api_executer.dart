//lib\net\auth_tip_receiver\auth_tip_receiver_api_executer.dart
import 'package:tipme_app/net/auth_tip_receiver/model/signup/sign_up_body_request.dart';

abstract class AuthTipReceiverApiExecuter {
  Future<void> signUp(SignUpBodyRequest body);
  
}
