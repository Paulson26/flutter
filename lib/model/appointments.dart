class Appointment{
  String? apptid;
  String? apptclient;
  String? assignedstaff;
  String? apptstatus;
  String? apptamount;
  String? appointmentdate;
  String? apptfromtime;
  String? appointmentcreateddate;

  Appointment({
    required this.apptid,
    required this.apptclient,
    required this.assignedstaff,
    required this.apptstatus,
    required this.apptamount,
    required this.appointmentdate,
    required this.apptfromtime,
    required this.appointmentcreateddate,
 });
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      apptid: json['appt_id'],
      apptclient: json['appt_client'],
      assignedstaff: json['assigned_staff'],
      apptstatus: json['appt_status'],
      apptamount: json['appt_amount'],
      appointmentdate: json['appointment_date'],
      apptfromtime: json['appt_from_time'],
      appointmentcreateddate: json['appointment_created_date'],
    );
  }
 
 
 }
 class Appointmentlist {
  final List<Appointment> appointments;

  Appointmentlist({
    required this.appointments,
  });

  
}