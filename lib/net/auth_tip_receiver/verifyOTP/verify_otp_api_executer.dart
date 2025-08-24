//lib\net\auth_tip_receiver\verify_otp\verify_otp_api_executer.dart

import 'package:tipme_app/net/auth_tip_receiver/model/verifyOTP/verify_otp_body_request.dart';
import 'package:tipme_app/net/auth_tip_receiver/model/verifyOTP/verify_otp_response.dart';

abstract class VerifyOtpApiExecuter {
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpBodyRequest body);
}
