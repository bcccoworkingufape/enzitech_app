// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/home_controller.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({Key? key}) : super(key: key);

  @override
  State<TreatmentsPage> createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    if (mounted) {
      controller.addListener(() {
        if (controller.state == HomeState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.failure!.message),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthMQ = MediaQuery.of(context).size.width;
    var heightMQ = MediaQuery.of(context).size.height;
    final controller = context.watch<HomeController>();

    return Container(
      color: Colors.red,
      height: heightMQ,
      width: widthMQ,
    );
  }
}
