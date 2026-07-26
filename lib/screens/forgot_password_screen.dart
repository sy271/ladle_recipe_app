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
    case 'user-not-found':
      return 'No account found for that email.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    default:
      return e.message ?? 'Something went wrong. Please try again.';
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'maya@example.com');
  bool _sent = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) setState(() => _sent = true);
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                        'Back to sign in',
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
              const SizedBox(height: 32),

              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(LucideIcons.mail, size: 26, color: colors.primary),
              ),
              Text(
                'Reset password',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: colors.heading,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your email and we'll send a link to reset your password.",
                style: GoogleFonts.dmSans(fontSize: 13, height: 1.4, color: colors.muted),
              ),
              const SizedBox(height: 28),

              if (_sent)
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colors.successBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.inputBorder),
                  ),
                  child: Column(
                    children: [
                      Icon(LucideIcons.checkCircle2, size: 32, color: colors.primary),
                      const SizedBox(height: 12),
                      Text(
                        'Link sent!',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.heading,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check your inbox at ${_emailController.text}',
                        style: GoogleFonts.dmSans(fontSize: 13, color: colors.muted),
                      ),
                    ],
                  ),
                )
              else
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'EMAIL ADDRESS',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: colors.labelFg,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: colors.inputBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.inputBorder),
                        ),
                        child: Row(
                          children: [
                            Icon(LucideIcons.mail, size: 15, color: colors.muted),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.dmSans(fontSize: 15, color: colors.inputFg),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
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
                      const SizedBox(height: 20),
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
                                'Send reset link',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primaryFg,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),

              Center(
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    _sent ? 'Back to sign in' : 'Remember it? Sign in →',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.meta,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
