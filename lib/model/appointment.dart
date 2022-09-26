import 'dart:convert';

List<Employees> employeesFromJson(String str) =>
    List<Employees>.from(json.decode(str).map((x) => Employees.fromJson(x)));

String employeesToJson(List<Employees> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employees {
  Employees({
    required this.apptid,
    required this.assignedstaff,
    required this.apptstatus,
    required this.appointmentdate,
    required this.apptfromtime,
  });
  String apptid;
  String assignedstaff;
  String apptstatus;
  String appointmentdate;
  String apptfromtime;

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        apptid: json['appt_id'],
        assignedstaff: json['assigned_staff'],
        apptstatus: json['appt_status'],
        appointmentdate: json['appointment_date'],
        apptfromtime: json['appt_from_time'],
      );

  Map<String, dynamic> toJson() => {
        "appt_id": apptid,
        "appt_status": apptstatus,
        "assigned_staff": assignedstaff,
        "appointment_date": appointmentdate,
        "appt_from_time": apptfromtime,
      };
}
