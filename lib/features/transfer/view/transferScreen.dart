import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/modern_text_field.dart';
import '../../../shared/controllers/navigation_controller.dart';
import '../../../models/currency.dart';
import '../transfer_provider.dart';
import '../../wallet/wallet_controller.dart';

final _currentRequestProvider = FutureProvider.family<bool, TransferRequest?>((ref, req) async {
  if (req == null) return false;
  return ref.read(transferProvider(req).future);
});

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  ConsumerState<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _contactController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  Currency _currency = Currency.usd;
  bool _showSuccessDialog = false;
  bool _isSubmitting = false;
  TransferRequest? _pendingRequest;

  @override
  void dispose() {
    _recipientController.dispose();
    _contactController.dispose();
    _bankController.dispose();
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSend = _pendingRequest != null 
        ? ref.watch(_currentRequestProvider(_pendingRequest!))
        : const AsyncValue.data(null);
    final isLoading = asyncSend is AsyncLoading;
    final wallet = ref.watch(walletProvider);
    
    // Show success toast and navigate to dashboard when transfer completes
    if (asyncSend is AsyncData && asyncSend.value == true && !_showSuccessDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showSuccessDialog = true;
          _isSubmitting = false; // Reset submitting flag
          _pendingRequest = null; // Clear pending request
        });
        // Show success toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Transfer successful!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        // Navigate to dashboard after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            ref.read(navigationControllerProvider.notifier).changeTab(0); // Navigate to dashboard
          }
        });
      });
    }
    
    // Show error toast and navigate to dashboard when transfer fails
    if (asyncSend is AsyncError && !_showSuccessDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSubmitting = false; // Reset submitting flag
          _pendingRequest = null; // Clear pending request
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              asyncSend.error.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        // Navigate to dashboard after showing error
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            ref.read(navigationControllerProvider.notifier).changeTab(0); // Navigate to dashboard
          }
        });
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Send Money',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Transfer money securely',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Balance',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            '${wallet.currency.code} ${wallet.balance.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Form Fields
                Text(
                  'Recipient Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 16),
                
                ModernTextField(
                  controller: _recipientController,
                  label: 'Recipient Name',
                  icon: Icons.person,
                  validator: _required,
                ),
                
                const SizedBox(height: 16),
                
                ModernTextField(
                  controller: _contactController,
                  label: 'Email or Phone',
                  icon: Icons.contact_phone,
                  validator: _required,
                ),
                
                const SizedBox(height: 16),
                
                ModernTextField(
                  controller: _bankController,
                  label: 'Bank Name',
                  icon: Icons.account_balance,
                  validator: _required,
                ),
                
                const SizedBox(height: 16),
                
                ModernTextField(
                  controller: _accountController,
                  label: 'Account Number',
                  icon: Icons.credit_card,
                  validator: _required,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Transfer Amount',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ModernTextField(
                        controller: _amountController,
                        label: 'Amount',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
            child: DropdownButton<Currency>(
              value: _currency,
              isExpanded: true,
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              items: Currency.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c.code,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null && v != _currency) {
                  print('Currency changed to: ${v.code}');
                  setState(() => _currency = v);
                }
              },
            ),
          ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Error Display
                if (asyncSend is AsyncError)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            asyncSend.error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: (isLoading || _isSubmitting)
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() {
                              _isSubmitting = true;
                              _pendingRequest = _currentRequestOrNull();
                            });
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Send Money',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  TransferRequest? _currentRequestOrNull() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return null;
    return TransferRequest(
      recipientName: _recipientController.text,
      contact: _contactController.text,
      bankName: _bankController.text,
      accountNumber: _accountController.text,
      amount: amount,
      currency: _currency,
    );
  }

}
