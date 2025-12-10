// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isOnline = false,
    this.lastSeen,
    this.fcmToken,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      photoUrl: map['photoUrl'],
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'])
          : null,
      fcmToken: map['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'fcmToken': fcmToken,
    };
  }

  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isOnline,
    DateTime? lastSeen,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

// lib/models/call_model.dart

enum CallStatus {
  ringing,
  active,
  ended,
  missed,
  rejected,
}

enum CallType {
  voice,
  pushToTalk,
}

class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final CallStatus status;
  final CallType type;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration; // in seconds
  final String? sdpOffer;
  final String? sdpAnswer;
  final List<Map<String, dynamic>>? iceCandidates;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.receiverId,
    required this.receiverName,
    required this.status,
    this.type = CallType.voice,
    required this.startTime,
    this.endTime,
    this.duration,
    this.sdpOffer,
    this.sdpAnswer,
    this.iceCandidates,
  });

  factory CallModel.fromMap(Map<String, dynamic> map, String callId) {
    return CallModel(
      callId: callId,
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? 'Unknown',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? 'Unknown',
      status: CallStatus.values.firstWhere(
        (e) => e.toString() == 'CallStatus.${map['status']}',
        orElse: () => CallStatus.ended,
      ),
      type: CallType.values.firstWhere(
        (e) => e.toString() == 'CallType.${map['type']}',
        orElse: () => CallType.voice,
      ),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'])
          : null,
      duration: map['duration'],
      sdpOffer: map['sdpOffer'],
      sdpAnswer: map['sdpAnswer'],
      iceCandidates: map['iceCandidates'] != null
          ? List<Map<String, dynamic>>.from(map['iceCandidates'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'duration': duration,
      'sdpOffer': sdpOffer,
      'sdpAnswer': sdpAnswer,
      'iceCandidates': iceCandidates,
    };
  }

  CallModel copyWith({
    CallStatus? status,
    DateTime? endTime,
    int? duration,
    String? sdpOffer,
    String? sdpAnswer,
    List<Map<String, dynamic>>? iceCandidates,
  }) {
    return CallModel(
      callId: callId,
      callerId: callerId,
      callerName: callerName,
      receiverId: receiverId,
      receiverName: receiverName,
      status: status ?? this.status,
      type: type,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      sdpOffer: sdpOffer ?? this.sdpOffer,
      sdpAnswer: sdpAnswer ?? this.sdpAnswer,
      iceCandidates: iceCandidates ?? this.iceCandidates,
    );
  }

  String get durationString {
    if (duration == null) return '00:00';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
