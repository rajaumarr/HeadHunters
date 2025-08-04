import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:head_hunter/models/job-post-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/view/companyView/job/post-job-view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/loading-provider.dart';
import '../utils/constants/colors.dart';
import '../utils/extensions/global-functions.dart';
import '../view/job/apply-job-view.dart';

class JobServices {
  static var auth = FirebaseAuth.instance;
  static var currentUser = auth.currentUser!.uid;
  static final _storage = FirebaseStorage.instance;
  static final _jobCollection = FirebaseFirestore.instance.collection('jobs');

  static Future<String?> uploadCV(String filePath, String fileName) async {
    try {
      File file = File(filePath);
      String fileExtension =
          fileName.split('.').last; // Extracts "pdf", "doc", "docx"

      // Determine MIME type based on file extension
      String? contentType;
      switch (fileExtension) {
        case 'pdf':
          contentType = 'application/pdf';
          break;
        case 'doc':
          contentType = 'application/msword';
          break;
        case 'docx':
          contentType =
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
        default:
          print("Unsupported file type.");
          return null;
      }
      // Extract the file extension

      // Ensure filename has its extension
      String finalFileName = "${fileName.replaceAll(' ', '_')}.$fileExtension";

      Reference storageRef =
      FirebaseStorage.instance.ref().child('cv/$finalFileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: contentType, // Set correct metadata
      );

      UploadTask uploadTask = storageRef.putFile(file, metadata);
      TaskSnapshot snapshot = await uploadTask;

      // Get and return the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      customPrint("Error uploading file: $e");
      return null;
    }
  }

  static Future<void> addJob(JobPostModel model, BuildContext context) async {
    final backendProvider =
    Provider.of<LoadingProvider>(context, listen: false);
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    final docRef = _jobCollection.doc().id;
    try {
      backendProvider.setLoading(true);
      _jobCollection.doc(docRef).set(model.toMap()).then((value) async {
        updateJob(docRef, {'jobId': docRef});
        backendProvider.setLoading(false);
        customPrint("Job Added");
        if (context.mounted) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const Dialog(
                    backgroundColor: whiteColor, child: PostSuccessDialog());
              });
        }
      });
    } catch (e) {
      backendProvider.setLoading(false);
      customPrint(e.toString());
    }
  }

  static Future<void> updateJob(String id, Map<String, dynamic> map) async {
    try {
      _jobCollection.doc(id).update(map).then((value) {
        customPrint('Job updated');
      });
    } catch (e) {
      customPrint(e.toString());
    }
  }

  static Stream<List<JobPostModel>> fetchAllJobForSpecificStream() {
    return _jobCollection
        .where('companyId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
        if (doc.exists) {
          try {
            return JobPostModel.fromDoc(doc);
          } catch (e) {

        return null; // Return null if parsing fails
        }
        }
        return null;
      })
          .where((data) => data != null)
          .cast<JobPostModel>()
          .toList();
    });
  }

  static Stream<List<JobPostModel>> fetchAllJobStream() {
    return _jobCollection.snapshots().map((snapshot) {
      print("Firestore snapshot received. Number of documents: ${snapshot.docs.length}");
      return snapshot.docs
          .map((doc) {
        if (doc.exists) {
          print("Document ID: ${doc.id}, Data: ${doc.data()}");
          try {
            return JobPostModel.fromDoc(doc);
          } catch (e) {
            print("Error parsing document ${doc.id}: $e");
            return null; // Return null if parsing fails
          }
        }
        print("Document ${doc.id} does not exist.");
        return null;
      })
          .where((data) => data != null)
          .cast<JobPostModel>()
          .toList();
    });
  }

  static Stream<List<JobPostModel>> fetchAllJobStreamForUserApplied(
      String userId) {
    return _jobCollection
        .where('applicationsId', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
        if (doc.exists) {
          return JobPostModel.fromDoc(doc);
        }
        return null;
      })
          .where((data) => data != null)
          .cast<JobPostModel>()
          .toList();
    });
  }

  static Future<List<JobPostModel>> fetchAllJobOnce() async {
    try {
      QuerySnapshot snapshot = await _jobCollection.get();
      return snapshot.docs
          .map((doc) {
        if (doc.exists) {
          return JobPostModel.fromDoc(doc);
        }
        return null;
      })
          .where((data) => data != null)
          .cast<JobPostModel>()
          .toList();
    } catch (e) {
      customPrint("Error fetching Job: $e");
      return [];
    }
  }

  static Future<List<JobPostModel>> fetchAllJob(String type) async {
    try {
      QuerySnapshot snapshot = await _jobCollection.get();
      return snapshot.docs
          .map((doc) {
        if (doc.exists) {
          return JobPostModel.fromDoc(doc);
        }
        return null;
      })
          .where((data) => data != null)
          .cast<JobPostModel>()
          .toList();
    } catch (e) {
      customPrint("Error fetching Job: $e");
      return [];
    }
  }

  static Future<void> addToJobList(String id, String userId,
      Map<String, dynamic> applicantData, BuildContext context) async {
    final docRef = _jobCollection.doc(id);
    final snapshot = await docRef.get();
    List<dynamic> applicationsId = snapshot.data()?['applicationsId'] ?? [];
    if (applicationsId.contains(userId)) {
      showSnackbar(context, "You already applied to this job", color: redColor);
      return;
    }

    await _jobCollection.doc(id).update({
      'applicationsId': FieldValue.arrayUnion([userId])
    }).then((v) async {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);

      await addApplicantData(
          documentId: id, applicantData: applicantData, context: context)
          .then((v) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const Dialog(
                backgroundColor: whiteColor,
                child: AppliedSuccessDialog(),
              );
            });
      });
    });
  }

  static Future<void> addApplicantData({
    required String documentId,
    required Map<String, dynamic> applicantData,
    required BuildContext context,
  }) async {
    try {
      final docRef = _jobCollection.doc(documentId);
      // Fetch user data to ensure userName and email are present
      final userDoc = await FirebaseFirestore.instance.collection('job-seekers').doc(applicantData['userId']).get();
      final userData = userDoc.data() ?? {};
      applicantData['userName'] = userData['userName'] ?? '';
      applicantData['email'] = userData['email'] ?? '';
      applicantData['status'] = 'Applied';

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          List<dynamic> currentList =
              snapshot.data()?['appliedApplicantsDetail'] ?? [];

          currentList.add(applicantData);

          // Update the document
          transaction.update(docRef, {'appliedApplicantsDetail': currentList});
        } else {
          Provider.of<LoadingProvider>(context, listen: false)
              .setLoading(false);

          // Document does not exist; create a new one
          transaction.set(docRef, {
            'appliedApplicantsDetail': [applicantData],
          });
        }
      });
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);

      customPrint('Applicant data added successfully!');
    } catch (e) {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);

      customPrint('Failed to add applicant data: $e');
    }
  }

  static Future<void> removeFromJobList(String id, String userId) async {
    await _jobCollection.doc(id).update({
      'applicationsId': FieldValue.arrayRemove([userId])
    }).then((v) {});
  }

  static Future<JobPostModel?> fetchJobData(String id) async {
    DocumentSnapshot data = await _jobCollection.doc(id).get();
    if (data.exists) {
      log(JobPostModel.fromDoc(data).toString());
      return JobPostModel.fromDoc(data);
    }
    return null;
  }

  static Stream<JobPostModel?> fetchJobStream(String id) {
    return _jobCollection.doc(id).snapshots().map((data) {
      if (data.exists) {
        return JobPostModel.fromDoc(data);
      } else {
        return null;
      }
    });
  }

  static Future<void> downloadAndSaveFile(
      String fileUrl, String fileName) async {
    try {
      String fileExtension = fileName.split('.').last.toLowerCase();

      // Validate the file extension
      if (!['pdf', 'doc', 'docx', 'txt'].contains(fileExtension)) {
        throw Exception("Unsupported file type: $fileExtension");
      }
      // Fetch the file from the URL
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        Uint8List fileBytes = response.bodyBytes;

        // Detect file MIME type dynamically

        // Extract file extension from the file name
        String? mimeType;
        switch (fileExtension) {
          case 'pdf':
            mimeType = 'application/pdf';
            break;
          case 'doc':
            mimeType = 'application/msword';
            break;
          case 'docx':
            mimeType =
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            break;
          case 'txt':
            mimeType = 'text/plain';
            break;
          default:
            throw Exception("Unsupported file type: $fileExtension");
        }


        // Save file with correct extension & MIME type
        await FileSaver.instance.saveAs(
          name: fileName,
          bytes: fileBytes,
          ext: fileExtension,
          mimeType: _getMimeTypeEnum(mimeType),
        );

        print("File saved successfully.");
      } else {
        print("Failed to download file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while downloading file: $e");
    }
  }

  // Function to determine file extension based on MIME type
  static String _getFileExtension(String mimeType) {
    switch (mimeType) {
      case 'application/pdf':
        return 'pdf';
      case 'application/msword':
        return 'doc';
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return 'docx';
      case 'application/vnd.ms-excel':
        return 'xls';
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return 'xlsx';
      default:
        return 'bin'; // Fallback for unknown types
    }
  }

  // Function to map MIME type to FileSaver MimeType
  static MimeType _getMimeTypeEnum(String mimeType) {
    switch (mimeType) {
      case 'application/pdf':
        return MimeType.pdf;
      case 'application/msword':
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return MimeType.microsoftWord;
      case 'application/vnd.ms-excel':
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return MimeType.microsoftExcel;
      default:
        return MimeType.other; // Default case
    }
  }

  // --- NEW: Update applicant status and manage slots ---
  static Future<void> updateApplicantStatus({
    required String jobId,
    required String applicantUserId,
    required String newStatus,
    required BuildContext context,
  }) async {
    final jobDoc = _jobCollection.doc(jobId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(jobDoc);
      if (!snapshot.exists) return;

      List<dynamic> applicantsRaw = List.from(snapshot['appliedApplicantsDetail'] ?? []);
      // Deep copy each applicant map
      List<Map<String, dynamic>> applicants = applicantsRaw.map((a) => Map<String, dynamic>.from(a)).toList();
      int totalSlots = int.tryParse(snapshot['totalSlots'].toString()) ?? 0;
      final data = snapshot.data();
      String jobStatus = (data != null && data.containsKey('jobStatus')) ? data['jobStatus'] : 'Open';

      int idx = applicants.indexWhere((a) => a['userId'] == applicantUserId);
      if (idx == -1) {
        customPrint('Applicant not found in array');
        return;
      }

      String prevStatus = applicants[idx]['status'] ?? 'Applied';

      if (newStatus == 'Accepted' && prevStatus != 'Accepted') {
        if (totalSlots > 0 && jobStatus == 'Open') {
          applicants[idx]['status'] = 'Accepted';
          totalSlots -= 1;
          if (totalSlots == 0) jobStatus = 'Full';
        } else {
          showSnackbar(context, "No slots available", color: Colors.red);
          return;
        }
      } else if (newStatus == 'Rejected') {
        applicants[idx]['status'] = 'Rejected';
        if (prevStatus == 'Accepted') {
          totalSlots += 1;
          jobStatus = 'Open';
        }
      }

      transaction.update(jobDoc, {
        'appliedApplicantsDetail': applicants,
        'totalSlots': totalSlots,
        'jobStatus': jobStatus,
      });
    });
  }
}
