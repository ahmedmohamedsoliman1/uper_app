import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zohoclone/utils/app_constants.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  static String route = AppConstants.forgetPasswordRoute ;

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isResetPasswordLoading = false ;


  void resetPassword () async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance ;
    await firebaseAuth.sendPasswordResetEmail(email: emailController.text).then((value) {
      Fluttertoast.showToast(msg: "Check your email");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }


  @override
  Widget build(BuildContext context) {

    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark ;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                isDarkMode ? const Image(image: AssetImage("assets/images/car1.jpg") ,
                  width: double.infinity,
                  height: 200, fit: BoxFit.fill,) : const Image(image: AssetImage("assets/images/car2.webp") ,
                  width: double.infinity, height: 200, fit: BoxFit.fill,),
                const SizedBox(height: 15,),
                Text("forget password" , style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 20
                ),),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "email" ,
                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isDarkMode ? Colors.black12 : Colors.grey
                        ),
                        border: InputBorder.none ,
                        filled: true ,
                        fillColor: isDarkMode ? Colors.white : Colors.grey.shade200
                    ),
                    validator: (input){
                      if (input == null || input.trim().isEmpty){
                        return "please email is required";
                      }
                      if (input.length < 2){
                        return "email is too short" ;
                      }
                      if (input.length > 50 ){
                        return "email can't be longer than 50 character" ;
                      }else {
                        return null ;
                      }
                    },
                    onChanged: (input) {
                      emailController.text = input ;
                      setState(() {

                      });
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                Builder(builder: (context){
                  if (isResetPasswordLoading){
                    return SizedBox(
                      width: 300 ,
                      child: ElevatedButton(onPressed: null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.white : Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ), child: const SizedBox() ,),
                    );
                  }else {
                    return SizedBox(
                      width: 300 ,
                      child: ElevatedButton(onPressed: (){
                        if (formKey.currentState!.validate()){
                          resetPassword();
                        }
                      },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.white : Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ), child: Text("Send reset password" ,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: isDarkMode ? Colors.black : Colors.white
                          ),) ,),
                    ) ;
                  }
                }),
                const SizedBox(height: 5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
