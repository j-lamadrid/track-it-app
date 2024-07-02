import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:track_it/pages/custom_route.dart';
import 'package:track_it/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreen();

  static bool loggedIn = false;
}

class _LoginScreen extends State<LoginScreen> {


  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name,
          password: data.password,
        );
        if (credential.user?.emailVerified == false) {
          await credential.user?.sendEmailVerification();
          return 'Please verify your email';
        }
        LoginScreen.loggedIn = true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found');
          return 'No user found';
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user');
          return 'Wrong password provided for that user';
        }
        return e.toString();
      } catch (e) {
        print(e);
        return 'An error occurred: ${e.toString()}';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name!,
          password: data.password!,
        );
        await credential.user?.sendEmailVerification();
        LoginScreen.loggedIn = false;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Signup Successful'),
            content: const Text('User successfully created. Please verify your email before logging in.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email';
        }
      } catch (e) {
        return e.toString();
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String email) {
    return Future.delayed(loginTime).then((_) {
      try {
        FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } catch (e) {
        return e.toString();
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FlutterLogin(
              title: 'Autism Center of Excellence',
              userType: LoginUserType.email,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              logo: const AssetImage('lib/images/health_logo.png',),
              navigateBackAfterRecovery: true,
              loginAfterSignUp: false,
              userValidator: (value) {
                if ((!value!.contains('@')) || (!value.endsWith('.com') && !value.endsWith('.edu'))) {
                  return "Email must contain '@' and end with '.com' or '.edu'";
                }
                return null;
              },
              passwordValidator: (value) {
                if (value!.isEmpty) {
                  return 'Password is empty';
                }
                return null;
              },
              onLogin: (loginData) {
                debugPrint('Login info');
                debugPrint('Email: ${loginData.name}');
                debugPrint('Password: ${loginData.password}');
                return _loginUser(loginData);
              },
              onSignup: (signupData) {
                debugPrint('Signup info');
                debugPrint('Email: ${signupData.name}');
                debugPrint('Password: ${signupData.password}');

                if (signupData.termsOfService.isNotEmpty) {
                  debugPrint('Terms of service: ');
                  for (final element in signupData.termsOfService) {
                    debugPrint(
                      ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}',
                    );
                  }
                }
                return _signupUser(signupData);
              },
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(
                  FadePageRoute(
                    builder: (context) => const MyHomePage(title: "Home Page"),
                  ),
                );
              },
              onRecoverPassword: (name) {
                debugPrint('Recover password info');
                debugPrint('Name: $name');
                return _recoverPassword(name);
                // Show new password dialog
              },
              headerWidget: const IntroWidget(),
              theme: LoginTheme(
                  textFieldStyle: const TextStyle(
                      color: Colors.black
                  ),
                  inputTheme: const InputDecorationTheme(
                    fillColor: Colors.white10,
                    iconColor: Colors.black,
                  ),
                  accentColor: Colors.white,
                  switchAuthTextColor: Colors.black,
                  pageColorLight: Colors.blueAccent[400]!,
                  primaryColor: Colors.black,
                  pageColorDark: Colors.yellow[400]!,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  cardTheme: const CardTheme(
                      color: Colors.white
                  )
              ),
            )
        )
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ],
    );
  }
}