// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_activity_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PendingActivityController on _PendingActivityControllerBase, Store {
  final _$loadActivitiesAsyncAction =
      AsyncAction('_PendingActivityControllerBase.loadActivities');

  @override
  Future<List<ActivityDto>> loadActivities({bool isManual = false}) {
    return _$loadActivitiesAsyncAction
        .run(() => super.loadActivities(isManual: isManual));
  }

  final _$syncActivitiesAsyncAction =
      AsyncAction('_PendingActivityControllerBase.syncActivities');

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
