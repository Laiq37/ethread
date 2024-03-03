import 'package:ethread_app/utils/helpers/form_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Login Screen Tests', () {
    test('Empty email test', () {
      var result = FormValidator.validateEmail('');
      expect(result, "Please enter an email!");
    });

    test('Invalid email test', () {
      var result = FormValidator.validateEmail('test');
      expect(result, "Please enter a valid email");
    });

    test('Valid email test', () {
      var result = FormValidator.validateEmail('admin@gmail.com');
      expect(result, null);
    });

    test('Empty password test', () {
      var result = FormValidator.validatePassword('');
      expect(result, 'Please enter a password.');
    });

    test('Invalid password test', () {
      var result = FormValidator.validatePassword('12345');
      expect(result, 'Password must contain at least 8 characters.');
    });

    test('Valid password test', () {
      var result = FormValidator.validatePassword('Adobe110#');
      expect(result, null);
    });

    test('login Api Success Test', () async{
      var mockClient = MockClient((request) async => http.Response('''{
    "message": "You have successfully logged in",
    "data": {
        "remember_me": null,
        "user": {
            "id": 5,
            "first_name": "Gt",
            "last_name": "Driver",
            "email": "gt_driver@yopmail.com",
            "active": true,
            "created_at": "2022-09-21T07:55:13.000000Z",
            "updated_at": "2022-11-29T12:36:20.000000Z",
            "deleted_at": null
        },
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDRkMGI3MWZjZmY3MTY1ZTZiM2I0YmM2NTZkODQ3OTk0ZDU5MzI1NmMzZWI4MGExNjUwNGIxZGVkZDk0OWVmNjcxOWE3YWM2YjRhMDM0OTUiLCJpYXQiOjE2Nzc1ODE2MjcuNDIzMDQxLCJuYmYiOjE2Nzc1ODE2MjcuNDIzMDQ1LCJleHAiOjE2Nzc2NjgwMjcuNDAwMjI1LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.vy-oRoQ43SbfXdadDSmMz8yu9qfxZjAErvjxRYAwjj1VYvijv9TdT3MpTCzwseYIlZlE9VGLsz-0OfjNOO2gY464s0JNqGpk3opojTpxoKIh6MZAZM16XL6xKyeS_97TdFfJSGDKMTWUXnbX0c7nhh7QIjOJ0U4WdLKBINTaqcyfFm-FIs71fsomqmBpJpXFGRg1_Ga2RIAtJ0rBSGBifAeTHljfOHgrdJkL6Kexqiiop5XF9hZ3fmCHTEWJjd8zj9dKax6Ybso6IAvbbhmNF6bpjSS2c8-VvFLN_vWz-xT62WuAofS2ZUVukyb59BI_RPnddOz0v0bozk6Zh3KAca8dfvorJfIzDaLvkC7eg1Uj-XP_KDtM06w8Xywjgianx0i0xs9jY121ZO5-fAE6F4_e_g97DCC7tUXYTeTsnYqsaov4MGbjGJ15U2lxKiOpbuu0pUXxxzIyeN8v5-DaGnSXy2SLV-c7sjmGIpecdvHV4tvirq25FtEGdLBXqQrPFHRH4olOQjLEX35b9H4YIDJztfByFVVPN3HrkGb45SuExsz-0OVh8AeqLA8dp5u-V8vbqy7m_heJonDXwaSgH4zkKc-Aj-hyFg1e1YswU2zm3RKGs8dvT-tu93P9-q8YBD_3uw5tYYm1w_LLEjkKZ3sEjwrybc5xB0_Rg2djC0A",
        "contract_type": "Contractual",
        "token_type": "Bearer",
        "expires_at": "2023-03-01 10:53:47"
    }
}''', 200));
final response = await mockClient.get(Uri.parse('http://ethread.laravel.genetechz.com/api/auth/mobilelogin'));
expect(response.body, '''{
    "message": "You have successfully logged in",
    "data": {
        "remember_me": null,
        "user": {
            "id": 5,
            "first_name": "Gt",
            "last_name": "Driver",
            "email": "gt_driver@yopmail.com",
            "active": true,
            "created_at": "2022-09-21T07:55:13.000000Z",
            "updated_at": "2022-11-29T12:36:20.000000Z",
            "deleted_at": null
        },
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDRkMGI3MWZjZmY3MTY1ZTZiM2I0YmM2NTZkODQ3OTk0ZDU5MzI1NmMzZWI4MGExNjUwNGIxZGVkZDk0OWVmNjcxOWE3YWM2YjRhMDM0OTUiLCJpYXQiOjE2Nzc1ODE2MjcuNDIzMDQxLCJuYmYiOjE2Nzc1ODE2MjcuNDIzMDQ1LCJleHAiOjE2Nzc2NjgwMjcuNDAwMjI1LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.vy-oRoQ43SbfXdadDSmMz8yu9qfxZjAErvjxRYAwjj1VYvijv9TdT3MpTCzwseYIlZlE9VGLsz-0OfjNOO2gY464s0JNqGpk3opojTpxoKIh6MZAZM16XL6xKyeS_97TdFfJSGDKMTWUXnbX0c7nhh7QIjOJ0U4WdLKBINTaqcyfFm-FIs71fsomqmBpJpXFGRg1_Ga2RIAtJ0rBSGBifAeTHljfOHgrdJkL6Kexqiiop5XF9hZ3fmCHTEWJjd8zj9dKax6Ybso6IAvbbhmNF6bpjSS2c8-VvFLN_vWz-xT62WuAofS2ZUVukyb59BI_RPnddOz0v0bozk6Zh3KAca8dfvorJfIzDaLvkC7eg1Uj-XP_KDtM06w8Xywjgianx0i0xs9jY121ZO5-fAE6F4_e_g97DCC7tUXYTeTsnYqsaov4MGbjGJ15U2lxKiOpbuu0pUXxxzIyeN8v5-DaGnSXy2SLV-c7sjmGIpecdvHV4tvirq25FtEGdLBXqQrPFHRH4olOQjLEX35b9H4YIDJztfByFVVPN3HrkGb45SuExsz-0OVh8AeqLA8dp5u-V8vbqy7m_heJonDXwaSgH4zkKc-Aj-hyFg1e1YswU2zm3RKGs8dvT-tu93P9-q8YBD_3uw5tYYm1w_LLEjkKZ3sEjwrybc5xB0_Rg2djC0A",
        "contract_type": "Contractual",
        "token_type": "Bearer",
        "expires_at": "2023-03-01 10:53:47"
    }
}''');
    });
  });
}
