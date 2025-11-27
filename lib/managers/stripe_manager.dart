import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hop/managers/user_manager.dart';

part 'stripe_manager.g.dart';

class StripeManager {
  StripeManager();

  Future<String?> addPaymentMethod(Ref ref) async {
    // Add payment method
    try {
      final email = ref.read(userManagerProvider).user?.user?.email ?? "";
      PaymentMethodData paymentMethodData = PaymentMethodData(
        billingDetails: BillingDetails(
          email: email,
        ),
      );
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(paymentMethodData: paymentMethodData),
        options: const PaymentMethodOptions(
          setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
        ),
      );
      return paymentMethod.id;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }

      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
StripeManager stripeManager(Ref ref) {
  return StripeManager();
}

@riverpod
Future<String?> addPaymentMethod(AddPaymentMethodRef ref) async {
  return await ref.read(stripeManagerProvider).addPaymentMethod(ref);
}
