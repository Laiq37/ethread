import 'package:ethread_app/auth/login/ui/login_screen.dart';
import 'package:ethread_app/utils/config/custom_padding.dart';
import 'package:ethread_app/utils/config/custom_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    navigate();
    super.initState();
  }

  void navigate() async{
    await Future.delayed(const Duration(seconds: 3), (){
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      Get.offAll(() => const LoginScreen());
    });
  }

}
