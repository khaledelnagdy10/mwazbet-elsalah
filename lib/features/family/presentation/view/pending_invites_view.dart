import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/family/presentation/controller/family_cubit/family_cubit.dart';

class PendingRequestsView extends StatefulWidget {
  const PendingRequestsView({super.key});

  @override
  State<PendingRequestsView> createState() => _PendingRequestsViewState();
}

class _PendingRequestsViewState extends State<PendingRequestsView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FamilyCubit>().loadPendingRequests();
    });
  }

  Future<void> _refresh() async {
    await context.read<FamilyCubit>().loadPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyCubit, FamilyState>(
      listener: (context, state) {
        if (state is FamilyFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is FamilyLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is FamilyFailure) {
          return Scaffold(
            appBar: AppBar(title: Text('Pending Requests'.tr())),
            body: Center(
              child: ElevatedButton(
                onPressed: _refresh,
                child: Text('Retry'.tr()),
              ),
            ),
          );
        }

        if (state is FamilyRequestsLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Pending Requests'.tr()),
              actions: [
                IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _refresh,
              child: state.requests.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 250),
                        Center(child: Text('No pending requests'.tr())),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.requests.length,
                      itemBuilder: (context, index) {
                        final request = state.requests[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              request.senderName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(request.senderEmail),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    await context
                                        .read<FamilyCubit>()
                                        .acceptRequest(requestId: request.id);
                                  },
                                  child: Text('Accept'.tr()),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await context
                                        .read<FamilyCubit>()
                                        .rejectRequest(requestId: request.id);
                                  },
                                  child: Text('Reject'.tr()),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        }

        return const Scaffold(body: SizedBox());
      },
    );
  }
}
