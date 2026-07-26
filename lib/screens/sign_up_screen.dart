import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../services/auth_service.dart';
import '../theme/ladle_colors.dart';

final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

String _authErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'That email address looks invalid.';
    case 'email-already-in-use':
      return 'An account already exists for that email.';
    case 'weak-password':
      return 'Choose a stronger password.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    default:
      return e.message ?? 'Something went wrong. Please try again.';
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.chevronLeft, size: 18, color: colors.meta),
                        const SizedBox(width: 6),
                        Text(
                          'Back',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.meta,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.logoRingBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.logoRingBorder, width: 2),
                      ),
                      child: Icon(
                        LucideIcons.utensilsCrossed,
                        size: 26,
                        color: colors.logoIcon,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join Ladle',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: colors.brandFg,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create your free account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(fontSize: 13, color: colors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                _FieldLabel('Full name', colors: colors),
                const SizedBox(height: 6),
                _InputShell(
                  colors: colors,
                  child: Row(
                    children: [
                      Icon(LucideIcons.user, size: 15, color: colors.muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.dmSans(fontSize: 15, color: colors.inputFg),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Maya Chen',
                            hintStyle: GoogleFonts.dmSans(fontSize: 15, color: colors.placeholderFg),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _FieldLabel('Email', colors: colors),
                const SizedBox(height: 6),
                _InputShell(
                  colors: colors,
                  child: Row(
                    children: [
                      Icon(LucideIcons.mail, size: 15, color: colors.muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.dmSans(fontSize: 15, color: colors.inputFg),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'maya@example.com',
                            hintStyle: GoogleFonts.dmSans(fontSize: 15, color: colors.placeholderFg),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!_emailRegex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _FieldLabel('Password', colors: colors),
                const SizedBox(height: 6),
                _InputShell(
                  colors: colors,
                  child: Row(
                    children: [
                      Icon(LucideIcons.lock, size: 15, color: colors.muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: GoogleFonts.dmSans(fontSize: 15, color: colors.inputFg),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Min. 8 characters',
                            hintStyle: GoogleFonts.dmSans(fontSize: 15, color: colors.placeholderFg),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Min. 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                          size: 16,
                          color: colors.meta,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(fontSize: 12, color: colors.heartFill),
                  ),
                  const SizedBox(height: 12),
                ],

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.primaryFg,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ).copyWith(
                    shadowColor: WidgetStatePropertyAll(colors.primary.withValues(alpha: 0.27)),
                    elevation: const WidgetStatePropertyAll(6),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primaryFg,
                          ),
                        )
                      : Text(
                          'Create account',
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.primaryFg,
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: colors.inputBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => context.pop(),
                  child: Text(
                    'Already have an account?',
                    style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: colors.meta),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {required this.colors});

  final String text;
  final LadleColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: colors.labelFg,
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  const _InputShell({required this.colors, required this.child});

  final LadleColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.inputBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
      ),
      child: child,
    );
  }
}
