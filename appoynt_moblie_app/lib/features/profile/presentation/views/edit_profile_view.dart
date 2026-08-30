/*
 * File Name: edit_profile_view.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.3.0
 * Dependencies: dart:io, package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart, package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/core/utils/national_id_parser.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 31/08/2026]
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
import 'package:appoynt_mobile_app/core/utils/digit_converter_helper.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/edit_profile_body.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/profile_photo_options_dialog.dart';
import 'package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart';

class EditProfileView extends StatefulWidget {
  final String initialFirstName;
  final String initialLastName;
  final String initialPhone;
  final String? initialAddress;
  final String? initialNationalId;
  final String? initialBirthDate;
  final String initialAvatarUrl;
  final String? initialGovId;
  final String? initialCityId;
  final String? initialGovName;
  final String? initialCityName;

  const EditProfileView({
    super.key,
    this.initialFirstName = '',
    this.initialLastName = '',
    this.initialPhone = '',
    this.initialAddress,
    this.initialNationalId,
    this.initialBirthDate,
    this.initialAvatarUrl = '',
    this.initialGovId,
    this.initialCityId,
    this.initialGovName,
    this.initialCityName,
  });

  /// Factory constructor to initialize EditProfileView directly from a PatientProfile entity
  factory EditProfileView.fromProfile(PatientProfile profile, {Key? key}) {
    return EditProfileView(
      key: key,
      initialFirstName: profile.first_name,
      initialLastName: profile.last_name,
      initialPhone: profile.phone,
      initialAddress: profile.address,
      initialNationalId: profile.national_id,
      initialAvatarUrl: profile.avatar_url,
      initialGovId: profile.governorateId,
      initialCityId: profile.cityId,
      initialGovName: profile.governorateNameEn,
      initialCityName: profile.cityNameEn,
    );
  }

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _birthDateController;
  DateTime? _extractedBirthDate;
  String? _extractedGender;

  // Baseline snapshot for dirty state tracking (change detection)
  String _initialFirstName = '';
  String _initialLastName = '';
  String _initialPhone = '';
  String _initialNationalId = '';
  String? _initialGovId;
  String? _initialCityId;
  bool _snapshotInitialized = false;

  @override
  void initState() {
    super.initState();
    _applySystemOverlay();
    _initialFirstName = widget.initialFirstName.trim();
    _initialLastName = widget.initialLastName.trim();
    _initialPhone = widget.initialPhone.trim();
    _initialNationalId = (widget.initialNationalId ?? '').trim();

    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _nationalIdController =
        TextEditingController(text: widget.initialNationalId ?? '');
    _birthDateController =
        TextEditingController(text: widget.initialBirthDate ?? '');

    if (widget.initialNationalId != null) {
      _extractedGender = NationalIdParser.extractGender(widget.initialNationalId!);
      _extractedBirthDate = NationalIdParser.extractBirthDate(widget.initialNationalId!);
    } else {
      // No action needed
    }

    _nationalIdController.addListener(_onNationalIdChanged);
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);

    // Fetch governorates on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileCubit>().loadGovernorates(
            initialGovId: widget.initialGovId,
            initialCityId: widget.initialCityId,
            initialGovName: widget.initialGovName ?? widget.initialAddress,
            initialCityName: widget.initialCityName,
          );
    });
  }

  void _captureInitialSnapshot(EditProfileState state) {
    _initialFirstName = _firstNameController.text.trim();
    _initialLastName = _lastNameController.text.trim();
    _initialPhone = _phoneController.text.trim();
    _initialNationalId = _nationalIdController.text.trim();
    _initialGovId = state.selectedGovernorate?.id;
    _initialCityId = state.selectedCity?.id;
    _snapshotInitialized = true;
  }

  void _onFieldChanged() {
    if (mounted && _snapshotInitialized) {
      setState(() {});
    } else {
      // Widget not mounted or snapshot not initialized
    }
  }

  bool _hasChanges(EditProfileState state) {
    if (!_snapshotInitialized) {
      return false;
    } else {
      // Baseline snapshot ready
    }

    final bool textChanged = _firstNameController.text.trim() != _initialFirstName ||
        _lastNameController.text.trim() != _initialLastName ||
        _phoneController.text.trim() != _initialPhone ||
        _nationalIdController.text.trim() != _initialNationalId;

    final String? currentGovId = state.selectedGovernorate?.id;
    final String? currentCityId = state.selectedCity?.id;

    final bool locationChanged = currentGovId != _initialGovId || currentCityId != _initialCityId;

    final bool photoChanged = state.stagedProfileImage != null || state.isPhotoDeleted;

    return textChanged || locationChanged || photoChanged;
  }

  bool _isFormValid(EditProfileState state) {
    final bool isFirstNameValid = _firstNameController.text.trim().isNotEmpty;
    final bool isLastNameValid = _lastNameController.text.trim().isNotEmpty;
    final bool isGovSelected = state.selectedGovernorate != null;
    final bool isCitySelected = state.selectedCity != null;

    return isFirstNameValid && isLastNameValid && isGovSelected && isCitySelected;
  }

  bool _canSave(EditProfileState state) => _isFormValid(state) && _hasChanges(state);

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
      setState(() {
        _extractedBirthDate = extractedDate;
        _extractedGender = extractedGender;
      });
    } else {
      if (_extractedBirthDate != null || _extractedGender != null) {
        setState(() {
          _extractedBirthDate = null;
          _extractedGender = null;
        });
      } else {
        // No action needed
      }
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
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
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
          _captureInitialSnapshot(state);
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
        if (!_snapshotInitialized &&
            !state.isGovernoratesLoading &&
            !state.isCitiesLoading &&
            (state.governorates.isNotEmpty || state.governoratesError != null)) {
          _captureInitialSnapshot(state);
        } else {
          // Snapshot captured or loading
        }
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

        final AppLocalizations localizations = AppLocalizations.of(context);

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
                    decoration: InputDecoration(labelText: localizations.profile_first_name_label),
                    validator: (value) {
                      if (null == value || value.trim().isEmpty) {
                        return localizations.first_name_required;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: localizations.profile_last_name_label),
                    validator: (value) {
                      if (null == value || value.trim().isEmpty) {
                        return localizations.last_name_required;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      ArabicToEnglishDigitsFormatter(),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration:
                        InputDecoration(labelText: localizations.profile_phone_label),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nationalIdController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    inputFormatters: [
                      ArabicToEnglishDigitsFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.1),
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: localizations.profile_national_id_label,
                      prefixIcon: const Icon(Icons.badge_outlined, size: 20.0),
                      suffixIcon: _extractedBirthDate != null
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20.0)
                          : null,
                    ),
                  ),
                  NationalIdInfoBadges(
                    birthDate: _extractedBirthDate,
                    gender: _extractedGender,
                  ),
                  const SizedBox(height: 16.0),
                  const GovernorateCityDropdowns(),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.35),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      onPressed: (state.isLoading || !_canSave(state))
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<EditProfileCubit>().saveProfile(
                                      firstName:
                                          _firstNameController.text.trim(),
                                      lastName: _lastNameController.text.trim(),
                                      phone: _phoneController.text
                                          .trim()
                                          .toEnglishDigits(),
                                      governorateId:
                                          state.selectedGovernorate?.id,
                                      governorateName:
                                          state.selectedGovernorate?.nameEn,
                                      cityId: state.selectedCity?.id,
                                      cityName: state.selectedCity?.nameEn,
                                      nationalId: _nationalIdController.text
                                          .trim()
                                          .toEnglishDigits(),
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
                          : Text(
                              context.tr('save'),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
