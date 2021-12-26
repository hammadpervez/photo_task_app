import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:photo_taking/pods.dart';
import 'package:photo_taking/src/resources/constants.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  final _russianNumberFormat = MaskTextInputFormatter(
      mask: '+92 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      ref.read(authController).verifyPhoneNumber(_controller.text);
    }
  }

  String? _phoneFieldValidator(String? value) {
    var totalCharInField = 19;
    if (value!.length != totalCharInField) {
      print("$value");
      return 'Please Enter a valid number';
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.enterPhNo, style: textTheme.headline5),
            const SizedBox(height: 10),
            _buildNumField(),
            ElevatedButton(onPressed: _onTap, child: Text('Sign In')),
          ],
        ),
      ),
    );
  }

  Widget _buildNumField() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          controller: _controller,
          validator: _phoneFieldValidator,
          inputFormatters: [_russianNumberFormat],
        ),
      ),
    );
  }

  void _showDialog(BuildContext ctx, String title, {List<Widget>? actions}) {
    showDialog(
        context: ctx,
        builder: (_) {
          return AlertDialog(
            content: Text(title),
            actions: actions ??
                [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text('Close'))
                ],
          );
        });
  }

  void showLodaerDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(AppStrings.loading)
              ],
            ),
          );
        });
  }
}
