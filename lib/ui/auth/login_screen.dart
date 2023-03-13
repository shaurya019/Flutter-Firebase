import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const  InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter email';
                        }
                        return null ;
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const  InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter password';
                        }
                        return null ;
                      },
                    ),

                  ],
                )
            ),
            const SizedBox(height: 50,),
            RoundButton(
              title: 'Login',
              // loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  // login();
                }
              },
            ),
          ],
        ),
      )
    );
  }
}
