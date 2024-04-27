import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zohoclone/screens/forget_password_screen.dart';
import 'package:zohoclone/screens/login_screen.dart';
import 'package:zohoclone/utils/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String route = AppConstants.registerRoute ;


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance ;

  User? currentUser ;


  var formKey = GlobalKey<FormState>();

  bool isObscure = true ;
  bool isObscure2 = true ;
  bool isRegisterLoading = false ;

  void register () async{
    isRegisterLoading = true ;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text).then((auth) async{
          if(auth.user != null){
            currentUser = auth.user ;
            Map <String , dynamic> userMap = {
              "id" : currentUser!.uid ,
              "name" : nameController.text ,
              "email" : emailController.text ,
              "address" : addressController.text,
              "phone" : phoneController.text
            };

            DatabaseReference ref = FirebaseDatabase.instance.ref().child("users");
            await ref.set(userMap).then((value) {
              Fluttertoast.showToast(msg: "register successfully");
            });

          }
    }
    );
    isRegisterLoading = false ;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark ;
    return SafeArea(
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
                Text("register" , style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 20
                ),),
               const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "name" ,
                      hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isDarkMode ? Colors.black12 : Colors.grey
                      ),
                      border: InputBorder.none ,
                      filled: true ,
                      fillColor: isDarkMode ? Colors.white : Colors.grey.shade200
                    ),
                    validator: (input){
                      if (input == null || input.trim().isEmpty){
                        return "please name is required";
                      }
                      if (input.length < 2){
                        return "name is too short" ;
                      }
                      if (input.length > 50 ){
                        return "name can't be longer than 50 character" ;
                      }else {
                        return null ;
                      }
                    },
                    onChanged: (input) {
                      nameController.text = input ;
                      setState(() {

                      });
                    },
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: InputDecoration(
                        hintText: "phone" ,
                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isDarkMode ? Colors.black12 : Colors.grey
                        ),
                        border: InputBorder.none ,
                        filled: true ,
                        fillColor: isDarkMode ? Colors.white : Colors.grey.shade200
                    ),
                    validator: (input){
                      if (input == null || input.trim().isEmpty){
                        return "please phone is required";
                      }
                      if (input.length < 2){
                        return "phone is too short" ;
                      }
                      if (input.length > 50 ){
                        return "phone can't be longer than 50 character" ;
                      }else {
                        return null ;
                      }
                    },
                    onChanged: (input) {
                      phoneController.text = input ;
                      setState(() {

                      });
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        hintText: "address" ,
                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isDarkMode ? Colors.black12 : Colors.grey
                        ),
                        border: InputBorder.none ,
                        filled: true ,
                        fillColor: isDarkMode ? Colors.white : Colors.grey.shade200
                    ),
                    validator: (input){
                      if (input == null || input.trim().isEmpty){
                        return "please address is required";
                      }
                      if (input.length < 2){
                        return "address is too short" ;
                      }else {
                        return null ;
                      }
                    },
                    onChanged: (input) {
                      addressController.text = input ;
                      setState(() {

                      });
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    obscureText: !isObscure,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: isObscure ? InkWell(
                        onTap: (){
                          isObscure = !isObscure ;
                          setState(() {

                          });
                        },
                          child: const Icon(Icons.visibility)) : InkWell(
                        onTap: () {
                          isObscure = !isObscure ;
                          setState(() {

                          });
                        },
                          child:const Icon(Icons.visibility_off)),
                        hintText: "password" ,
                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isDarkMode ? Colors.black12 : Colors.grey
                        ),
                        border: InputBorder.none ,
                        filled: true ,
                        fillColor: isDarkMode ? Colors.white : Colors.grey.shade200
                    ),
                    validator: (input){
                      if (input == null || input.trim().isEmpty){
                        return "please password is required";
                      }
                      if (input.length < 2){
                        return "address is too short" ;
                      }else {
                        return null ;
                      }
                    },
                    onChanged: (input) {
                      passwordController.text = input ;
                      setState(() {

                      });
                    }
                  ),
                ),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                      obscureText: !isObscure2,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                          suffixIcon: isObscure ? InkWell(
                              onTap: (){
                                isObscure2 = !isObscure2 ;
                                setState(() {

                                });
                              },
                              child: const Icon(Icons.visibility)) : InkWell(
                              onTap: () {
                                isObscure2 = !isObscure2 ;
                                setState(() {

                                });
                              },
                              child:const Icon(Icons.visibility_off)),
                          hintText: "confirm password" ,
                          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: isDarkMode ? Colors.black12 : Colors.grey
                          ),
                          border: InputBorder.none ,
                          filled: true ,
                          fillColor: isDarkMode ? Colors.white : Colors.grey.shade200
                      ),
                      validator: (input){
                        if (input == null || input.trim().isEmpty){
                          return "please confirm password is required";
                        }
                        if (input.length < 2){
                          return "password is too short" ;
                        }
                        if (passwordController.text != confirmPasswordController.text){
                          return "password not matching" ;
                        }else {
                          return null ;
                        }
                      },
                      onChanged: (input) {
                        confirmPasswordController.text = input ;
                        setState(() {

                        });
                      }
                  ),
                ),
                const SizedBox(height: 20,),
                Builder(builder: (context){
                  if (isRegisterLoading){
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
                          register();
                        }
                      },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.white : Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ), child: Text("Register" ,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: isDarkMode ? Colors.black : Colors.white
                          ),) ,),
                    ) ;
                  }
                }),
                const SizedBox(height: 5,),
                TextButton(onPressed: () {
                   Navigator.pushNamed(context, ForgetPasswordScreen.route);
                }, child: Text("Forget password ? " ,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 16
                ),)),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: () {

                    }, child: Text("Have an account ? " ,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 14 ,
                        color: isDarkMode ? Colors.white : Colors.black
                      ),)) ,
                    TextButton(onPressed: () {
                       Navigator.pushNamed(context, LoginScreen.route);
                    }, child: Text("Log in" ,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16
                      ),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
