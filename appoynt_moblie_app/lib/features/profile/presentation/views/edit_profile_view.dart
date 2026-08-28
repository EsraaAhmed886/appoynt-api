/*
 * File Name: edit_profile_view.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: dart:io, package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart, package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: View widget for editing profile details and staging photo updates/deletions
 *   with instant local avatar preview and deferred backend submission on save.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
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

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController =
        TextEditingController(text: widget.initialAddress ?? '');
    _nationalIdController =
        TextEditingController(text: widget.initialNationalId ?? '');
    _birthDateController =
        TextEditingController(text: widget.initialBirthDate ?? '');
  }

  @override
  void dispose() {
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

        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr('updateProfilePhoto')),
          ),
          body: SingleChildScrollView(
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
        );
      },
    );
  }
}
