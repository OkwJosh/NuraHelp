class NotificationModel{
  bool appointmentReminders;
  bool messageAlerts;

  NotificationModel({required this.appointmentReminders, required this.messageAlerts});


  Map<dynamic,dynamic> toJson(){
    return
      {
      'appointmentReminders':appointmentReminders,
        'messageAlerts':messageAlerts,
    };
  }

  static NotificationModel empty() =>
      NotificationModel(
        messageAlerts: false,
        appointmentReminders: false,
      );

  factory NotificationModel.fromJson(json){
    return NotificationModel(
      appointmentReminders: json['appointmentReminders'],
      messageAlerts: json['messageAlerts']
    );
  }

}