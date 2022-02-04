// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'done_activity_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DoneActivityController on _DoneActivityController, Store {
  final _$generateActivityLinkAsyncAction =
      AsyncAction('_DoneActivityController.generateActivityLink');

  @override
  Future<String?> generateActivityLink(ActivityStore store) {
    return _$generateActivityLinkAsyncAction
        .run(() => super.generateActivityLink(store));
  }

  final _$openActivityAsyncAction =
      AsyncAction('_DoneActivityController.openActivity');

  @override
  Future<void> openActivity(ActivityStore store) {
    return _$openActivityAsyncAction.run(() => super.openActivity(store));
  }

  final _$loadActivitiesAsyncAction =
      AsyncAction('_DoneActivityController.loadActivities');

  @override
  Future<List<ActivityDto>> loadActivities() {
    return _$loadActivitiesAsyncAction.run(() => super.loadActivities());
  }

  final _$syncActivitiesAsyncAction =
      AsyncAction('_DoneActivityController.syncActivities');

  @override
  Future<void> syncActivities() {
    return _$syncActivitiesAsyncAction.run(() => super.syncActivities());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
