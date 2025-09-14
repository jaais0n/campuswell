import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isValidEmail(_emailController.text);

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required for health account access';
    }
    if (!_isValidEmail(value)) {
      return 'Please enter a valid campus email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required to protect your health data';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate() &&
        _isFormValid &&
        !widget.isLoading) {
      HapticFeedback.lightImpact();
      widget.onLogin(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Campus Email',
              hintText: 'Enter your campus email address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'local_hospital',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),
              errorMaxLines: 2,
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),

          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your secure password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                onPressed: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
              ),
              errorMaxLines: 2,
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) => _handleLogin(),
          ),

          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      // Navigate to forgot password screen
                      Navigator.pushNamed(context, '/forgot-password');
                    },
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            height: 7.h,
            child: ElevatedButton(
              onPressed:
                  _isFormValid && !widget.isLoading ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.12),
                foregroundColor: _isFormValid
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withValues(alpha: 0.38),
                elevation: _isFormValid ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login to CampusWell',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
