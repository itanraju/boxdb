import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_config.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final T? model;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final ValueChanged<AppLifecycleState>? appLifecycleState;
  final Function(T)? didChangeDependencies;
  final bool isConsumerAdded;
  final Function(T) onModelDispose;

  BaseView(
      {required this.builder,
      required this.onModelReady,
      this.appLifecycleState,
      this.model,
      this.didChangeDependencies,
      required this.onModelDispose,
      this.isConsumerAdded = false});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> with WidgetsBindingObserver {
  late T model;

  @override
  void initState() {
    try {
      model = appConfig<T>();
    } catch (e) {
      if (widget.model == null) {
        throw ("Either of the problem occured\n\n1. ${e.toString()}\n\n2. you have not provided the model in the parameter");
      }
      model = widget.model!;
    }

    if (widget.onModelReady != null) {
      WidgetsBinding.instance!.addObserver(this);
      widget.onModelReady(model);
    }

    if (widget.appLifecycleState != null) {
      WidgetsBinding.instance!.addObserver(this);
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.didChangeDependencies != null) {
      widget.didChangeDependencies!(model);
    }
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (widget.appLifecycleState != null) {
      widget.appLifecycleState!(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: widget.isConsumerAdded
          ? Consumer<T>(
              builder: (BuildContext context, T value, Widget? child) {
                return widget.builder(context, value, Container());
              },
            )
          : widget.builder(context, model, Container()),
    );
  }

  @override
  void dispose() {
    if (widget.appLifecycleState != null) {
      WidgetsBinding.instance!.removeObserver(this);
    }
    if (widget.onModelDispose != null) {
      widget.onModelDispose(model);
    }
    super.dispose();
  }
}
