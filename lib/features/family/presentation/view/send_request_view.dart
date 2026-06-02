import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/family/presentation/controller/family_cubit/family_cubit.dart';

class SendRequestView extends StatefulWidget {
  const SendRequestView({super.key});

  @override
  State<SendRequestView> createState() => _SendRequestViewState();
}

class _SendRequestViewState extends State<SendRequestView> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyCubit, FamilyState>(
      listener: (context, state) {
        if (state is FamilyRequestSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request sent successfully'.tr())),
          );
          Navigator.pop(context);
        }

        if (state is FamilyFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is FamilyLoading;

        return Scaffold(
          appBar: AppBar(title: Text('Send Request'.tr())),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'User Email'.tr(),
                    hintText: 'Enter user email'.tr(),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final email = emailController.text.trim();

                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Enter user email'.tr()),
                                ),
                              );
                              return;
                            }

                            await context.read<FamilyCubit>().sendRequest(
                              receiverEmail: email,
                            );
                          },
                    child: Text(
                      isLoading ? 'Loading...'.tr() : 'Send Request'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
