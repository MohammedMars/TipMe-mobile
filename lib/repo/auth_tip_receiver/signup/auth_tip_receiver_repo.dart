//lib\repo\auth_tip_receiver_repo.dart
import 'package:tipme_app/net/auth_tip_receiver/model/signup/sign_up_body_request.dart';

abstract class AuthTipReceiverRepo {
  Future<void> signUp(String mobileNumber);
}
