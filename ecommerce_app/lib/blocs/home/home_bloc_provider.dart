import 'package:ecommerce_app/blocs/home/home_bloc.dart';
import 'package:flutter/material.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider({Key key, Widget child, this.homeBloc, this.uid})
      : super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>());
  }

  @override
  bool updateShouldNotify(HomeBlocProvider old) => homeBloc != old.homeBloc;
}
