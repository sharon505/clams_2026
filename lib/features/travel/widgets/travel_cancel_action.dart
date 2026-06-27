import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../authentication/viewModels/auth_provider.dart';
import '../viewModels/cancelTravelRequestViewModel.dart';
import '../viewModels/myTravelRequisitionViewModel.dart';

class TravelCancelAction extends StatelessWidget {
  final int trId;

  const TravelCancelAction({
    super.key,
    required this.trId,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 20.sp),
      onSelected: (value) async {
        if (value == "cancel") {
          await _cancelRequest(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "cancel",
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 18.sp),
              SizedBox(width: 8.w),
              const Text("Cancel Request"),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _cancelRequest(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Cancel travel request?'),
        content: Text('This will cancel TR #$trId.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dCtx, true),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final authProvider = context.read<AuthProvider>();
    final employeeCode = authProvider.userData?.employeeCode.toString() ?? '';

    final ok = await context
        .read<CancelTravelRequestViewModel>()
        .cancel(trId, employeeCode);

    if (!context.mounted) return;

    final cancelVm = context.read<CancelTravelRequestViewModel>();

    final msg = cancelVm.lastMessage ??
        (ok ? 'Cancelled successfully' : cancelVm.error ?? 'Failed');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );

    if (ok) {
      await context.read<MyTravelRequisitionViewModel>().fetch(context);
    }
  }
}