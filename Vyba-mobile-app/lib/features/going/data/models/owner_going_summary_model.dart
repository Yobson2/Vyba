import 'package:flutter_templates/features/going/domain/entities/owner_going_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_going_summary_model.freezed.dart';
part 'owner_going_summary_model.g.dart';

@freezed
abstract class OwnerGoingSummaryModel with _$OwnerGoingSummaryModel {
  const OwnerGoingSummaryModel._();

  const factory OwnerGoingSummaryModel({
    @Default(0) int count,
    @Default([]) List<int> partySizes,
  }) = _OwnerGoingSummaryModel;

  factory OwnerGoingSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerGoingSummaryModelFromJson(json);

  OwnerGoingSummary toEntity() =>
      OwnerGoingSummary(count: count, partySizes: partySizes);
}
