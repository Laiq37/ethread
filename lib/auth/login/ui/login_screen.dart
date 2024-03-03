import 'package:ethread_app/auth/forgot_password/ui/forgot_password_screen.dart';
import 'package:ethread_app/auth/login/controller/login_screen_controller.dart';
import 'package:ethread_app/utils/config/custom_height.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_radius.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/custom_widgets/gradient_button.dart';
import 'package:ethread_app/utils/helpers/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  ///use to validate form fields errors

  final TextEditingController _emailController = TextEditingController();

  ///use to hold username field text
  final TextEditingController _passwordController = TextEditingController();

  ///Login controller
  final _loginController = LoginScreenController();

  ///use to hold password status
  bool _obscureText = true;

// Be sure to cancel subscription after you are done

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
          child: ConstrainedBox(
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
                          Stack(
                            children: [
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                enableSuggestions: false,
                                validator: FormValidator.validatePassword,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.visiblePassword,
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
                                    hintText: "Password",
                                    errorMaxLines: 3,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                        color: Colors.black.withOpacity(0.35)),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(CustomRadius.customRadius32))),
                              ),
                              Positioned(
                                right: 5,
                                child: Center(
                                  child: IconButton(
                                    onPressed: _toggle,
                                    icon: SvgPicture.asset(
                                        _obscureText ? 'assets/images/eye.svg' : 'assets/images/eye_icon.svg',
                                        width: CustomWidth.width20,
                                        height: 20,
                                        color: Theme.of(context).iconTheme.color,
                                        fit: BoxFit.scaleDown),
                                  ),
                                ),
                              )
                            ],
                          ),
                           SizedBox(height: CustomHeight.height32),
                          GradientButton(
                            width: double.infinity,
                            child: Text(
                              'Login',
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
                            onPressed: loginValidationFunction,
                            key: const Key("login_button"),
                          ),
                           SizedBox(height: CustomHeight.height50),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                //Navigate to forgot password screen
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                              },
                              child: Text("Forgot Password?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                    color:
                                    Theme.of(context).splashColor,
                                    decoration:
                                    TextDecoration.underline,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Toggle function is used for setting the password eye icon
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  loginValidationFunction(){
    // If all fields are filled
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text.trim();
      var password = _passwordController.text.trim();

      //Api call for login
      _loginController.login(email, password,context);
    }
  }
}
