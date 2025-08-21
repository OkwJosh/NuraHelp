class NotificationModel{
  final bool appointmentReminders;
  final bool messageAlerts;

  NotificationModel({required this.appointmentReminders, required this.messageAlerts});


  Map<dynamic,dynamic> toJson(){
    return
      {
      'appointmentReminders':appointmentReminders,
        'messageAlerts':messageAlerts,
    };
  }

  factory NotificationModel.fromJson(json){
    return NotificationModel(
      appointmentReminders: json['appointmentReminders'],
      messageAlerts: json['messageAlerts']
    );
  }

}