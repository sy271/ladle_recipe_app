import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../services/auth_service.dart';
import '../theme/ladle_colors.dart';

final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

String _authErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'That email address looks invalid.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
      return 'No account found for that email.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    default:
      return e.message ?? 'Something went wrong. Please try again.';
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'maya@example.com');
  final _passwordController = TextEditingController(text: 'ladle2024');
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  bool _isGoogleSubmitting = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleSubmitting = true;
      _errorMessage = null;
    });
    try {
      await _authService.signInWithGoogle();
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (e.code != 'popup-closed-by-user' && e.code != 'cancelled-popup-request') {
        setState(() => _errorMessage = _authErrorMessage(e));
      }
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        setState(() => _errorMessage = 'Google sign-in failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isGoogleSubmitting = false);
    }
  }

  @override
  void dispose() {
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
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.logoRingBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.logoRingBorder, width: 2),
                      ),
                      child: Icon(
                        LucideIcons.utensilsCrossed,
                        size: 30,
                        color: colors.logoIcon,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ladle',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        letterSpacing: -0.5,
                        color: colors.brandFg,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Big flavour for small kitchens.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: colors.taglineFg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

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
                      Icon(LucideIcons.checkCircle2, size: 16, color: colors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

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
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
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
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => context.push('/forgot-password'),
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.meta,
                      ),
                    ),
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
                  onPressed: (_isSubmitting || _isGoogleSubmitting) ? null : _submit,
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
                          'Sign in',
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: colors.primaryFg,
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: Divider(color: colors.border, height: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: GoogleFonts.dmSans(fontSize: 11, color: colors.muted),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.border, height: 1)),
                  ],
                ),
                const SizedBox(height: 12),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.chipBg,
                    side: BorderSide(color: colors.inputBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: (_isSubmitting || _isGoogleSubmitting) ? null : _signInWithGoogle,
                  child: _isGoogleSubmitting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: colors.body),
                        )
                      : Text(
                          'Continue with Google',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.body,
                          ),
                        ),
                ),
                const SizedBox(height: 28),

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'New here? ',
                        style: GoogleFonts.dmSans(fontSize: 13, color: colors.muted),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/sign-up'),
                        child: Text(
                          'Join Ladle.',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colors.meta,
                          ),
                        ),
                      ),
                    ],
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
