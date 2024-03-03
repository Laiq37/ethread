import 'package:ethread_app/auth/forgot_password/controller/forgot_password_controller.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/custom_widgets/gradient_button.dart';
import 'package:ethread_app/utils/helpers/form_validator.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  ///use to validate form fields errors

  final TextEditingController _emailController = TextEditingController();

  ///Forgot Password controller
  final _forgotPasswordController = ForgotPasswordController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Positioned(
                top: 32,
                left: 16,
                child: Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CustomRadius.customRadius20)),
                    child: InkWell(
                        onTap: () {
                            Navigator.pop(context);
                        },
                        child:   Padding(
                            padding: EdgeInsets.symmetric(horizontal: CustomPadding.padding16W, vertical: CustomPadding.padding16H),
                            child: const Icon(
                              Icons.arrow_back,
                            )
                        ))),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: CustomPadding.padding64W),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                          width: CustomWidth.width300,
                        ),
                        SizedBox(height: CustomHeight.height50),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                validator: FormValidator.validateEmail,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Theme.of(context).splashColor,
                                decoration: InputDecoration(
                                    contentPadding:  EdgeInsets.symmetric(
                                        horizontal: CustomPadding.padding20W),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(CustomRadius.customRadius32),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(CustomRadius.customRadius32),
                                    ),
                                    filled: true,
                                    hintText: "Email Address",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                        color: Colors.black.withOpacity(0.35)),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(CustomRadius.customRadius32))),
                              ),
                               SizedBox(height: CustomHeight.height32),
                              GradientButton(
                                width: double.infinity,
                                child: Text(
                                  'Forgot Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.white),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: <Color>[
                                    ThemeConfig().gradientDark,
                                    ThemeConfig().gradientLight
                                  ],
                                ),
                                onPressed: forgotPasswordValidationFunction,
                                key: const Key("forgot_password_button"),
                              ),
                               SizedBox(height: CustomHeight.height32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  forgotPasswordValidationFunction() async{
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text.trim();

      //Api call for login
      _forgotPasswordController.forgotPassword(email,context);
    }
  }
}
