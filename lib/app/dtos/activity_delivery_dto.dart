import 'activity_delivery_content_dto.dart';

class ActivityDeliveryDto {
  String? id;
  List<ActivityDeliveryContentDto>? contents;
  String? contentAnnotation;
  String? date;
  String? feedback;
  String? feedbackDate;
  String? status;
  bool? shouldRedo;
  bool? checked;
  String? checkedDate;
  String? score;
  ActivityDeliveryDto({
    this.id,
    this.contents,
    this.contentAnnotation,
    this.date,
    this.feedback,
    this.feedbackDate,
    this.status,
    this.shouldRedo,
    this.checked,
    this.checkedDate,
    this.score,
  });
}
