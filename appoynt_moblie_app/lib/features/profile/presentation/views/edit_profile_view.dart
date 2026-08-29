/*
 * File Name: edit_profile_view.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.1.0
 * Dependencies: dart:io, package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart, package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/core/utils/national_id_parser.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: View widget for editing profile details and staging photo updates/deletions
 *   with auto-calculated read-only gender from Egyptian National ID.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
import 'package:appoynt_mobile_app/core/utils/national_id_parser.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart';

class EditProfileView extends StatefulWidget {
  final String initialFirstName;
  final String initialLastName;
  final String initialPhone;
  final String? initialAddress;
  final String? initialNationalId;
  final String? initialBirthDate;
  final String initialAvatarUrl;

  const EditProfileView({
    super.key,
    this.initialFirstName = '',
    this.initialLastName = '',
    this.initialPhone = '',
    this.initialAddress,
    this.initialNationalId,
    this.initialBirthDate,
    this.initialAvatarUrl = '',
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _birthDateController;
  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    _applySystemOverlay();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController =
        TextEditingController(text: widget.initialAddress ?? '');
    _nationalIdController =
        TextEditingController(text: widget.initialNationalId ?? '');
    _birthDateController =
        TextEditingController(text: widget.initialBirthDate ?? '');

    if (widget.initialNationalId != null) {
      final String? gender = NationalIdParser.extractGender(widget.initialNationalId!);
      if (gender != null) {
        _selectedGender = gender;
      } else {
        // No action needed
      }
    } else {
      // No action needed
    }

    _nationalIdController.addListener(_onNationalIdChanged);
  }

  void _onNationalIdChanged() {
    final String value = _nationalIdController.text.trim();
    if (value.length == 14 && RegExp(r'^\d+$').hasMatch(value)) {
      // 1. Auto-extract Birth Date
      final extractedDate = NationalIdParser.extractBirthDate(value);
      if (extractedDate != null) {
        _birthDateController.text =
            "${extractedDate.year}-${extractedDate.month.toString().padLeft(2, '0')}-${extractedDate.day.toString().padLeft(2, '0')}";
      } else {
        // No action needed
      }

      // 2. Auto-extract Gender
      final extractedGender = NationalIdParser.extractGender(value);
      if (extractedGender != null) {
        setState(() {
          _selectedGender = extractedGender; // 'male' or 'female'
        });
      } else {
        // No action needed
      }
    } else {
      // No action needed
    }
  }

  void _applySystemOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _nationalIdController.removeListener(_onNationalIdChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nationalIdController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentRemoteAvatarUrl = widget.initialAvatarUrl;

    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.isSuccess) {
          CustomSnackBar.success(
            context,
            AppLocalizations.of(context).profile_change_success_msg,
          );
          Navigator.of(context).pop();
        } else if (null != state.errorMessage) {
          CustomSnackBar.error(
            context,
            state.errorMessage!,
          );
        } else {
          // No action needed
        }
      },
      builder: (context, state) {
        ImageProvider? avatarProvider;

        if (state.isPhotoDeleted) {
          avatarProvider = null;
        } else if (null != state.stagedProfileImage) {
          avatarProvider = FileImage(state.stagedProfileImage!);
        } else if (currentRemoteAvatarUrl.isNotEmpty) {
          avatarProvider = NetworkImage(currentRemoteAvatarUrl);
        } else {
          avatarProvider = null;
        }

        final bool is_dark =
            Theme.of(context).brightness == Brightness.dark;
        final SystemUiOverlayStyle overlay_style = SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness:
              is_dark ? Brightness.light : Brightness.dark,
          statusBarBrightness:
              is_dark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor:
              is_dark ? AppColors.background_dark : AppColors.white,
          systemNavigationBarIconBrightness:
              is_dark ? Brightness.light : Brightness.dark,
        );

        return Scaffold(
          backgroundColor:
              is_dark ? AppColors.background_dark : AppColors.white,
          appBar: AppBar(
            backgroundColor:
                is_dark ? AppColors.background_dark : AppColors.white,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            systemOverlayStyle: overlay_style,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: is_dark
                      ? AppColors.surface_dark
                      : AppColors.slate100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.slate800,
                  size: 18.0,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              context.tr('editProfile'),
              style: TextStyle(
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.slate900,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 54.0,
                          backgroundColor: AppColors.slate200,
                          backgroundImage: avatarProvider,
                          child: null == avatarProvider
                              ? const Icon(
                                  Icons.person,
                                  size: 54.0,
                                  color: AppColors.slate400,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => ProfilePhotoOptionsDialog.show(
                              context,
                              hasExistingPhoto: !state.isPhotoDeleted &&
                                  (null != state.stagedProfileImage ||
                                      currentRemoteAvatarUrl.isNotEmpty),
                              onGalleryTap: () => context
                                  .read<EditProfileCubit>()
                                  .pickImage(ImageSource.gallery),
                              onCameraTap: () => context
                                  .read<EditProfileCubit>()
                                  .pickImage(ImageSource.camera),
                              onDeleteTap: () => context
                                  .read<EditProfileCubit>()
                                  .stagePhotoDeletion(),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColors.white,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (null == value || value.trim().isEmpty) {
                        return 'First name is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (null == value || value.trim().isEmpty) {
                        return 'Last name is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nationalIdController,
                    decoration: const InputDecoration(labelText: 'National ID'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(labelText: 'Birth Date'),
                  ),
                  const SizedBox(height: 16.0),
                  // Gender Field (Dimmed & Read-Only)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('gender'),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: is_dark ? AppColors.darkTextPrimary : AppColors.slate700,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Opacity(
                        opacity: 0.65, // Dimmed look
                        child: IgnorePointer(
                          ignoring: true, // Prevents user interaction
                          child: Container(
                            height: 48.0,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: is_dark
                                  ? AppColors.darkSurfaceElevated
                                  : AppColors.slate100, // Disabled grey background
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: is_dark ? AppColors.darkBorder : AppColors.slate200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _selectedGender == 'female'
                                      ? Icons.female_rounded
                                      : Icons.male_rounded,
                                  color: is_dark ? AppColors.darkTextSecondary : AppColors.slate600,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  _selectedGender == 'female'
                                      ? context.tr('female')
                                      : context.tr('male'),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: is_dark ? AppColors.darkTextPrimary : AppColors.slate800,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.lock_outline_rounded,
                                  color: is_dark ? AppColors.darkTextMuted : AppColors.slate400,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<EditProfileCubit>().saveProfile(
                                      firstName:
                                          _firstNameController.text.trim(),
                                      lastName: _lastNameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      address: _addressController.text.trim(),
                                      nationalId:
                                          _nationalIdController.text.trim(),
                                      birthDate:
                                          _birthDateController.text.trim(),
                                    );
                              } else {
                                // Form validation failed
                              }
                            },
                      child: state.isLoading
                          ? const CircularProgressIndicator.adaptive(
                              backgroundColor: AppColors.white,
                            )
                          : Text(context.tr('save')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
}
