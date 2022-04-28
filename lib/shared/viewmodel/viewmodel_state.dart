import 'package:flutter/material.dart';

import 'utils_viewmodel.dart';
import 'viewmodel_state_type.dart';

abstract class ViewmodelState<TWidget extends StatefulWidget,
    TBind extends IViewmodel> extends State<TWidget> {
  final TBind viewmodel;

  ViewmodelState(this.viewmodel);

  bool get rebuildOnError => false;
  late var _stateType = ViewmodeStateType.isState;

  @override
  void initState() {
    super.initState();
    viewmodel.onError((event) {
      if (rebuildOnError) {
        setState(() {
          _stateType = ViewmodeStateType.isError;
        });
      }
    });

    viewmodel.onLoading((event) {
      setState(() {
        _stateType = ViewmodeStateType.isLoading;
      });
    });
  }

  ViewmodeStateType get stateType => _stateType;

  Widget builder(BuildContext context, ViewmodeStateType type);

  @override
  Widget build(BuildContext context) {
    return this.builder(context, _stateType);
  }

  @override
  void dispose() {
    viewmodel.dispose();
    super.dispose();
  }
}
