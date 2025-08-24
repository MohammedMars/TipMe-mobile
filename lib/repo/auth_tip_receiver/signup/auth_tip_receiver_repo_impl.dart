//lib\repo\auth_tip_receiver_repo_impl.dart
import 'package:tipme_app/net/auth_tip_receiver/model/signup/sign_up_body_request.dart';
import 'package:tipme_app/net/auth_tip_receiver/signup/auth_tip_receiver_api_executer.dart';
import 'package:tipme_app/repo/auth_tip_receiver/signup/auth_tip_receiver_repo.dart';

class AuthTipReceiverRepoImpl implements AuthTipReceiverRepo {
  final AuthTipReceiverApiExecuter _authTipReceiverApiExecuter;

  AuthTipReceiverRepoImpl(this._authTipReceiverApiExecuter);
  @override
  Future<void> signUp(String mobileNumber) async {
    await _authTipReceiverApiExecuter
        .signUp(SignUpBodyRequest(mobileNumber: mobileNumber));
  }
}
