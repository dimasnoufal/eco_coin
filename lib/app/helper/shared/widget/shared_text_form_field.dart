import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool showCounter;
  final bool isReadOnly;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.showCounter = false,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppColor.medium.copyWith(
              fontSize: 16,
              color: enabled ? AppColor.neutralBlack : AppColor.neutral40,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          readOnly: isReadOnly,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: showCounter ? maxLength : null,
          textCapitalization: textCapitalization,
          decoration: _buildInputDecoration(),
          style: AppColor.regular.copyWith(
            color: enabled ? AppColor.neutralBlack : AppColor.neutral40,
          ),
          validator: validator,
          onChanged: onChanged,
          buildCounter: _buildCounter,
        ),
        if (!showCounter && maxLength != null) _buildCustomCounter(),
      ],
    );
  }

  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    int? maxLength,
  }) {
    if (!showCounter) return null;

    return Text(
      '$currentLength${maxLength != null ? '/$maxLength' : ''}',
      style: AppColor.regular.copyWith(fontSize: 12, color: AppColor.neutral40),
    );
  }

  Widget _buildCustomCounter() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        "Max. $maxLength Karakter",
        style: AppColor.regular.copyWith(
          fontSize: 12,
          color: AppColor.neutral40,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppColor.regular.copyWith(color: AppColor.neutral30),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      prefixStyle: prefixText != null
          ? AppColor.regular.copyWith(
              color: enabled ? AppColor.neutralBlack : AppColor.neutral40,
            )
          : null,
      filled: true,
      fillColor: enabled
          ? (isReadOnly ? AppColor.neutral10 : AppColor.neutralWhite)
          : AppColor.neutral10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: enabled ? AppColor.neutral20 : AppColor.neutral10,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isReadOnly ? AppColor.neutral20 : AppColor.neutral20,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isReadOnly ? AppColor.neutral20 : AppColor.emeraldDefault,
          width: isReadOnly ? 1 : 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.neutral10, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.rubyDefault, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.rubyDefault, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: maxLines > 1 ? 16 : 16,
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const PasswordFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      obscureText: !_isPasswordVisible,
      enabled: widget.enabled,
      validator: widget.validator,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        onPressed: widget.enabled
            ? () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }
            : null,
        icon: Icon(
          _isPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: widget.enabled ? AppColor.neutral40 : AppColor.neutral30,
        ),
      ),
    );
  }
}

class PhoneFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final String countryCode;

  const PhoneFormField({
    super.key,
    this.controller,
    this.hintText = "Masukkan nomor telepon",
    this.labelText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.countryCode = "+62",
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      keyboardType: TextInputType.phone,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      prefixIcon: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          countryCode,
          style: AppColor.regular.copyWith(
            color: enabled ? AppColor.neutralBlack : AppColor.neutral40,
          ),
        ),
      ),
    );
  }
}

class BioFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLength;
  final bool showCounter;

  const BioFormField({
    super.key,
    this.controller,
    this.hintText = "Masukkan bio",
    this.labelText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLength = 100,
    this.showCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      maxLines: 4,
      maxLength: maxLength,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      showCounter: showCounter,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}

class CustomDivider extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  const CustomDivider({
    super.key,
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: color ?? AppColor.neutral20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: AppColor.regular.copyWith(
              fontSize: 14,
              color: textColor ?? AppColor.neutral40,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: color ?? AppColor.neutral20),
        ),
      ],
    );
  }
}

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak sama';
    }
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 9 || value.length > 13) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  static String? bio(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > 100) {
      return 'Bio maksimal 100 karakter';
    }
    return null;
  }
}
