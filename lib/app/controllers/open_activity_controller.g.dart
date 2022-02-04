// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_activity_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OpenActivityController on _OpenActivityControllerBase, Store {
  final _$stateAtom = Atom(name: '_OpenActivityControllerBase.state');

  @override
  bool get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(bool value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$_OpenActivityControllerBaseActionController =
      ActionController(name: '_OpenActivityControllerBase');

  @override
  dynamic finishLoad() {
    final _$actionInfo = _$_OpenActivityControllerBaseActionController
        .startAction(name: '_OpenActivityControllerBase.finishLoad');
    try {
      return super.finishLoad();
    } finally {
      _$_OpenActivityControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
