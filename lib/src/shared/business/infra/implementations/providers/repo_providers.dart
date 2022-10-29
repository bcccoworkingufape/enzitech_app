// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/auth_repo.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/enzymes_repo.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/experiments_repo.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/treatments_repo.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/user_repo.dart';

class RepoProviders {
  static List<SingleChildWidget> init(BuildContext context) {
    return [
      //* AUTH REPO
      Provider(
        create: (context) => AuthRepo(context.read()),
        lazy: true,
      ),
      //* USER REPO
      Provider(
        create: (context) => UserRepo(context.read()),
        lazy: true,
      ),
      //* ENZYMES REPO
      Provider(
        create: (context) => EnzymesRepo(context.read()),
        lazy: true,
      ),
      //* TREATMENTS REPO
      Provider(
        create: (context) => TreatmentsRepo(context.read()),
        lazy: true,
      ),
      //* EXPERIMENTS REPO
      Provider(
        create: (context) => ExperimentsRepo(context.read()),
        lazy: true,
      ),
    ];
  }
}
