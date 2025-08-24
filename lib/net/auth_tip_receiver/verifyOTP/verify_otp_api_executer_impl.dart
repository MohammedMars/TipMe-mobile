//lib\net\auth_tip_receiver\verify_otp\verify_otp_api_executer_impl.dart
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/net/auth_tip_receiver/model/verifyOTP/verify_otp_body_request.dart';
import 'package:tipme_app/net/auth_tip_receiver/model/verifyOTP/verify_otp_response.dart';
import 'package:tipme_app/net/auth_tip_receiver/verifyOTP/verify_otp_api_executer.dart';

class VerifyOtpApiExecuterImpl implements VerifyOtpApiExecuter {
  final DioClient _client;

  VerifyOtpApiExecuterImpl(this._client);

  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpBodyRequest body) async {
    final response = await _client.post("VerifyOtp", data: body.toJson());
    return VerifyOtpResponse.fromJson(response.data);
  }
}
