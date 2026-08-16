/*
 * File Name: app_router.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: routes.dart, splash_screen.dart, login_page.dart, register_page.dart,
 *   forgot_password_page.dart, home_page.dart, global_cubit.dart, otp_page.dart,
 *   account_success_page.dart, reset_password_page.dart, password_success_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Main application router for generating page transitions from route settings.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appoynt_mobile_app/core/routing/routes.dart';
import 'package:appoynt_mobile_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/register_page.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/otp_page.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/account_success_page.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:appoynt_mobile_app/features/auth/presentation/pages/password_success_page.dart';
import 'package:appoynt_mobile_app/features/home/presentation/pages/home_page.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/pages/doctor_profile_page.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/pages/choose_slots_page.dart';
import 'package:appoynt_mobile_app/core/logic/global_cubit.dart';

/// Router class responsible for parsing route settings and building views.
class AppRouter {
  // Prevent instantiation
  AppRouter._();

  /// Generates the corresponding Route for a given RouteSettings.
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case Routes.doctor_profile:
        final args = settings.arguments;
        final String doctor_id = (args is DoctorProfileArgs)
            ? args.doctor_id
            : (args is String ? args : 'doc_101');
        return MaterialPageRoute(
          builder: (_) => DoctorProfilePage(doctor_id: doctor_id),
        );
      case Routes.choose_slots:
        final args = settings.arguments;
        final ChooseSlotsArgs slot_args = (args is ChooseSlotsArgs)
            ? args
            : ChooseSlotsArgs(
                doctor_id: args is String ? args : 'doc_101',
                doctor_name: 'Dr. Sarah Jenkins',
                specialty: 'Senior Consultant Cardiologist',
                consultation_fee: 550.0,
              );
        return MaterialPageRoute(
          builder: (_) => ChooseSlotsPage(args: slot_args),
        );
      case Routes.login:
        return PageRouteBuilder(
          pageBuilder: (context, anim, secAnim) {
            return LoginPage(
              on_login_success: () {
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                } else {
                  // No action needed
                }
              },
              on_go_to_register: () {
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (reg_context) => RegisterPage(
                        on_go_to_otp: (phone) {
                          if (reg_context.mounted) {
                            Navigator.of(reg_context).push(
                              MaterialPageRoute(
                                builder: (otp_context) => OtpPage(
                                  phone: phone,
                                  on_verified: () {
                                    if (otp_context.mounted) {
                                      Navigator.of(otp_context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (success_context) => AccountSuccessPage(
                                            on_go_home: () {
                                              Navigator.of(success_context).popUntil((route) => route.isFirst);
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      // No action needed
                                    }
                                  },
                                  on_back: () {
                                    Navigator.of(otp_context).pop();
                                  },
                                  on_toggle_language: () {
                                    otp_context.read<GlobalCubit>().toggle_language();
                                  },
                                ),
                              ),
                            );
                          } else {
                            // No action needed
                          }
                        },
                        on_go_to_login: () {
                          Navigator.of(reg_context).pop();
                        },
                        on_toggle_language: () {
                          reg_context.read<GlobalCubit>().toggle_language();
                        },
                      ),
                    ),
                  );
                } else {
                  // No action needed
                }
              },
              on_forgot_password: () {
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (forgot_context) => ForgotPasswordPage(
                        on_back: () {
                          Navigator.of(forgot_context).pop();
                        },
                        on_toggle_language: () {
                          forgot_context.read<GlobalCubit>().toggle_language();
                        },
                        on_code_sent: (phone) {
                          if (forgot_context.mounted) {
                            Navigator.of(forgot_context).push(
                              MaterialPageRoute(
                                builder: (otp_context) => OtpPage(
                                  phone: phone,
                                  on_verified: () {
                                    if (otp_context.mounted) {
                                      Navigator.of(otp_context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (reset_context) => ResetPasswordPage(
                                            on_back: () {
                                              Navigator.of(reset_context).pop();
                                            },
                                            on_toggle_language: () {
                                              reset_context.read<GlobalCubit>().toggle_language();
                                            },
                                            on_password_updated: () {
                                              if (reset_context.mounted) {
                                                Navigator.of(reset_context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (pass_success_context) => PasswordSuccessPage(
                                                      on_back: () {
                                                        Navigator.of(pass_success_context).pop();
                                                      },
                                                      on_go_login: () {
                                                        Navigator.of(pass_success_context).popUntil((route) => route.isFirst);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                // No action needed
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      // No action needed
                                    }
                                  },
                                  on_back: () {
                                    Navigator.of(otp_context).pop();
                                  },
                                  on_toggle_language: () {
                                    otp_context.read<GlobalCubit>().toggle_language();
                                  },
                                ),
                              ),
                            );
                          } else {
                            // No action needed
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  // No action needed
                }
              },
              on_toggle_language: () {
                context.read<GlobalCubit>().toggle_language();
              },
            );
          },
          transitionsBuilder: (context, anim, secAnim, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        );
      default:
        return null;
    }
  }
}
