import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/mutations/verification.dart';
import 'package:clinic/widgets/auth/auth_layout.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends HookWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final verification = useAccountVerification(context);
    final resend = useResendOTP();

    return AuthLayout(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.tr('page_verification_title'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              context.tr('page_verification_desc'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            gapH24,
            Form(
              key: verification.key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Pinput(
                    controller: verification.otp,
                    length: 6,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    validator: (pin) {
                      if ((pin ?? '').isEmpty || (pin ?? '').length < 6) {
                        return context.tr('verification_invalid');
                      }
                      return null;
                    },
                    onCompleted: (pin) => verification.handleSubmit(
                      context,
                      pin: pin,
                    ),
                  ),
                  gapH24,
                  SubmitButton(
                    onSubmit: () => verification.handleSubmit(context),
                    disabled: verification.isLoading,
                    loading: verification.isLoading,
                    child: Text(context.tr('verify')),
                  ),
                ],
              ),
            ),
            gapH32,
            Center(
              child: Text.rich(
                TextSpan(
                  text: context.tr('page_verification_resend_notice'),
                  children: [
                    TextSpan(
                      text: ' ${context.tr("resend")}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = resend.enabled
                            ? () => resend.handleSubmit(context)
                            : null,
                      style: TextStyle(
                        color: resend.enabled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!resend.enabled) ...[
                      TextSpan(
                        text: ' (${resend.cooldown} s)',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
