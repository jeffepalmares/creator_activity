class ActivityScormDto {
  Core? core;
  Interactions? interactions;

  ActivityScormDto({this.core, this.interactions});

  ActivityScormDto.fromJson(Map<String, dynamic> json) {
    core = json['core'] != null ? Core.fromJson(json['core']) : null;
    interactions = json['interactions'] != null
        ? Interactions.fromJson(json['interactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (core != null) {
      data['core'] = core?.toJson();
    }
    if (interactions != null) {
      data['interactions'] = interactions?.toJson();
    }
    return data;
  }
}

class Core {
  String? studentId;
  String? studentName;
  String? lessonLocation;
  String? credit;
  String? lessonStatus;
  String? entry;
  String? totalTime;
  String? lessonMode;
  String? exit;
  String? sessionTime;
  Score? score;

  Core(
      {this.studentId,
      this.studentName,
      this.lessonLocation,
      this.credit,
      this.lessonStatus,
      this.entry,
      this.totalTime,
      this.lessonMode,
      this.exit,
      this.sessionTime,
      this.score});

  Core.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    studentName = json['student_name'];
    lessonLocation = json['lesson_location'];
    credit = json['credit'];
    lessonStatus = json['lesson_status'];
    entry = json['entry'];
    totalTime = json['total_time'];
    lessonMode = json['lesson_mode'];
    exit = json['exit'];
    sessionTime = json['session_time'];
    score = json['score'] != null ? new Score.fromJson(json['score']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = studentId;
    data['student_name'] = studentName;
    data['lesson_location'] = lessonLocation;
    data['credit'] = credit;
    data['lesson_status'] = lessonStatus;
    data['entry'] = entry;
    data['total_time'] = totalTime;
    data['lesson_mode'] = lessonMode;
    data['exit'] = exit;
    data['session_time'] = sessionTime;
    if (score != null) {
      data['score'] = score?.toJson();
    }
    return data;
  }
}

class Score {
  int? raw;
  String? min;
  String? max;

  Score({this.raw, this.min, this.max});

  Score.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}

class Interactions {
  List<Interaction>? childArray;

  Interactions({childArray});

  Interactions.fromJson(Map<String, dynamic> json) {
    if (json['childArray'] != null) {
      childArray = [];
      json['childArray'].forEach((v) {
        childArray?.add(Interaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (childArray != null) {
      data['childArray'] = childArray?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Interaction {
  String? id;
  String? time;
  String? type;
  String? weighting;
  String? studentResponse;
  String? result;
  String? latency;
  List<String>? objectives;
  CorrectResponses? correctResponses;

  Interaction(
      {this.id,
      this.time,
      this.type,
      this.weighting,
      this.studentResponse,
      this.result,
      this.latency,
      this.objectives,
      this.correctResponses});

  Interaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    type = json['type'];
    weighting = json['weighting'];
    studentResponse = json['student_response'];
    result = json['result'];
    latency = json['latency'];
    objectives = [];
    correctResponses = json['correct_responses'] != null
        ? CorrectResponses.fromJson(json['correct_responses'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time;
    data['type'] = type;
    data['weighting'] = weighting;
    data['student_response'] = studentResponse;
    data['result'] = result;
    data['latency'] = latency;
    if (objectives != null) {
      data['objectives'] = objectives;
    }
    if (correctResponses != null) {
      data['correct_responses'] = correctResponses?.toJson();
    }
    return data;
  }
}

class CorrectResponses {
  List<CorrectResponse>? childArray;

  CorrectResponses({this.childArray});

  CorrectResponses.fromJson(Map<String, dynamic> json) {
    if (json['childArray'] != null) {
      childArray = [];
      json['childArray'].forEach((v) {
        childArray?.add(CorrectResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (childArray != null) {
      data['childArray'] = childArray?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CorrectResponse {
  String? pattern;

  CorrectResponse({this.pattern});

  CorrectResponse.fromJson(Map<String, dynamic> json) {
    pattern = json['pattern'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pattern'] = pattern;
    return data;
  }
}
