import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostModel{
  String jobId;
  String companyId;
  String companyName;
  String openJob;
  String level;
  String jobDescription;
  List<String> tags;
  List<String> applicationsId;
  List <Map<String,dynamic>> appliedApplicantsDetail;
  DateTime postedTime;
  int totalSlots;

  factory JobPostModel.fromDoc(DocumentSnapshot map) {
    List<Map<String, dynamic>> applicantInfo = (map['appliedApplicantsDetail'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();

    return JobPostModel(
      jobId: map['jobId'] as String,
      companyId: map['companyId'] as String,
      companyName: map['companyName'] as String,
      openJob: map['openJob'] as String,
      level: map['level'] as String,
      jobDescription: map['jobDescription'] as String,
      tags: (map['tags'] as List<dynamic>).map((item)=>item as String).toList(),
      applicationsId: (map['applicationsId'] as List<dynamic>).map((item)=>item as String).toList(),
      postedTime: (map['postedTime'] is Timestamp ? (map['postedTime'] as Timestamp).toDate() : DateTime.now()),
      totalSlots: map['totalSlots'] as int,
      appliedApplicantsDetail:applicantInfo,
    );
  }

//<editor-fold desc="Data Methods">
  JobPostModel({
    required this.jobId,
    required this.companyId,
    required this.companyName,
    required this.openJob,
    required this.level,
    required this.jobDescription,
    required this.tags,
    required this.applicationsId,
    required this.appliedApplicantsDetail,
    required this.postedTime,
    required this.totalSlots,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobPostModel &&
          runtimeType == other.runtimeType &&
          jobId == other.jobId &&
          companyId == other.companyId &&
          companyName == other.companyName &&
          openJob == other.openJob &&
          level == other.level &&
          jobDescription == other.jobDescription &&
          tags == other.tags &&
          applicationsId == other.applicationsId &&
          appliedApplicantsDetail == other.appliedApplicantsDetail &&
          postedTime == other.postedTime &&
          totalSlots == other.totalSlots);

  @override
  int get hashCode =>
      jobId.hashCode ^
      companyId.hashCode ^
      companyName.hashCode ^
      openJob.hashCode ^
      level.hashCode ^
      jobDescription.hashCode ^
      tags.hashCode ^
      applicationsId.hashCode ^
      appliedApplicantsDetail.hashCode ^
      postedTime.hashCode ^
      totalSlots.hashCode;

  @override
  String toString() {
    return 'JobPostModel{' +
        ' jobId: $jobId,' +
        ' companyId: $companyId,' +
        ' companyName: $companyName,' +
        ' openJob: $openJob,' +
        ' level: $level,' +
        ' jobDescription: $jobDescription,' +
        ' tags: $tags,' +
        ' applicationsId: $applicationsId,' +
        ' appliedApplicantsDetail: $appliedApplicantsDetail,' +
        ' postedTime: $postedTime,' +
        ' totalSlots: $totalSlots,' +
        '}';
  }

  JobPostModel copyWith({
    String? jobId,
    String? companyId,
    String? companyName,
    String? openJob,
    String? level,
    String? jobDescription,
    List<String>? tags,
    List<String>? applicationsId,
    List<Map<String, dynamic>>? appliedApplicantsDetail,
    DateTime? postedTime,
    int? totalSlots,
  }) {
    return JobPostModel(
      jobId: jobId ?? this.jobId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      openJob: openJob ?? this.openJob,
      level: level ?? this.level,
      jobDescription: jobDescription ?? this.jobDescription,
      tags: tags ?? this.tags,
      applicationsId: applicationsId ?? this.applicationsId,
      appliedApplicantsDetail:
          appliedApplicantsDetail ?? this.appliedApplicantsDetail,
      postedTime: postedTime ?? this.postedTime,
      totalSlots: totalSlots ?? this.totalSlots,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': this.jobId,
      'companyId': this.companyId,
      'companyName': this.companyName,
      'openJob': this.openJob,
      'level': this.level,
      'jobDescription': this.jobDescription,
      'tags': this.tags,
      'applicationsId': this.applicationsId,
      'appliedApplicantsDetail': this.appliedApplicantsDetail,
      'postedTime': this.postedTime,
      'totalSlots': this.totalSlots,
    };
  }

  factory JobPostModel.fromMap(Map<String, dynamic> map) {
    return JobPostModel(
      jobId: map['jobId'] as String,
      companyId: map['companyId'] as String,
      companyName: map['companyName'] as String,
      openJob: map['openJob'] as String,
      level: map['level'] as String,
      jobDescription: map['jobDescription'] as String,
      tags: map['tags'] as List<String>,
      applicationsId: map['applicationsId'] as List<String>,
      appliedApplicantsDetail:
          map['appliedApplicantsDetail'] as List<Map<String, dynamic>>,
      postedTime: map['postedTime'] as DateTime,
      totalSlots: map['totalSlots'] as int,
    );
  }

//</editor-fold>
}