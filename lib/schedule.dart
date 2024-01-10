import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ui/model/appointment_model.dart';
import 'qr_scanner.dart';
import 'success_booking.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final int userId;

  const ScheduleAppointmentPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

enum FilterStatus { pending, complete, waiting }

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  late int userId;
  FilterStatus status_bar = FilterStatus.pending;
  List<Appointment> appointments = [];

  Future<void> getAppointmentsByStatusAndUser(String status) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.131.75.14:8080/pkums/appointment/getstatus/$status/patient/$userId'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Appointment> appointments =
        jsonResponse.map((data) => Appointment.fromJson(data)).toList();

        setState(() {
          this.appointments = appointments;
        });
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (e, stackTrace) {
      print('Error in getAppointmentsByStatusAndUser: $e');
      print('Stack trace: $stackTrace');
      throw e;
    }
  }

  Future<void> validate30mins () async{

    final DateTime currentDateTime = DateTime.now();



  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Text("Schedule"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                filterIconButton(FilterStatus.pending, "Pending"),
                filterIconButton(FilterStatus.waiting, "Waiting"),
                filterIconButton(FilterStatus.complete, "Complete"),
              ],
            ),
          ),
          Expanded(
            child: appointments.isNotEmpty && appointments.any((appointment) {
              DateTime bookingDateTime = DateTime.parse(appointment.bookingDate.split('-').map((part) {
                return part.padLeft(2, '0'); // Ensure two digits for each part
              }).join('-'));
              DateTime currentDate = DateTime.now();
              return bookingDateTime.isAfter(currentDate) || bookingDateTime.day == currentDate.day;
            })
                ? ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                DateTime bookingDateTime = DateTime.parse(appointment.bookingDate.split('-').map((part) {
                  return part.padLeft(2, '0'); // Ensure two digits for each part
                }).join('-'));
                DateTime currentDate = DateTime.now();
                bool isOnOrAfterCurrentDay = bookingDateTime.isAfter(currentDate) || bookingDateTime.day == currentDate.day;

                if (isOnOrAfterCurrentDay) {
                  return AppointmentCard(appointment: appointment, userId: userId,);
                } else {
                  return SizedBox(); // Return an empty container if not meeting the condition
                }
              },
            )
                : Center(child: Text('No Appointments')),
          ),
        ],
      ),
    );
  }

  ElevatedButton filterIconButton(FilterStatus filter, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          status_bar = filter;
          getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
        });
      },
      style: ElevatedButton.styleFrom(
        primary: status_bar == filter ? Colors.deepPurple[50] : Colors.deepPurple[300],
      ),
      child: Text(label),
    );
  }
}

class AppointmentCard extends StatefulWidget {
  late final int userId;

  final Appointment appointment;
  AppointmentCard({Key? key, required this.appointment, required this.userId}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    bool isPending = this.widget.appointment.status.toLowerCase() == "pending";
    String formattedDate = this.widget.appointment.bookingDate.split('-').map((part) {
      return part.padLeft(2, '0'); // Ensure two digits for each part
    }).join('-');

    DateTime bookingDateTime = DateTime.parse(formattedDate);
    DateTime bookingRealTime = DateTime.now();
    DateTime bookingRealDate = DateTime(bookingRealTime.year, bookingRealTime.month, bookingRealTime.day);
    DateTime currentTime = DateTime(bookingRealTime.year, bookingRealTime.month, bookingRealTime.day, bookingRealTime.hour, bookingRealTime.minute, bookingRealTime.second);

    /**
     * Current Real time
     */
    print("Booking Date Time: ${bookingDateTime}");
    print("Booking Real DateTime: ${bookingRealTime}");
    print("Booking Real Date: ${bookingRealDate}");
    String time = "${currentTime.hour}:${currentTime.minute}";
    print("Current time: $time");

    /**
     * Convert to string
     */


    /**
     * Appointment Date time
     */
    print(this.widget.appointment.bookingDate);
    print(this.widget.appointment.bookingTime);




    //print(difference.inHours);
    //print(difference.inMinutes);

    //print(difference);

    //bool canCheckIn = this.widget.appointment.status.toLowerCase() == "Waiting" && difference <= Duration(minutes: 30);

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              this.widget.appointment.serviceType,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Date: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  this.widget.appointment.bookingDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Time: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  this.widget.appointment.bookingTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (isPending)
            ElevatedButton(
              onPressed: (canCheckIn)? () {

                //Navigator.push(context, MaterialPageRoute(builder: (Context) => SuccessBookingPage(appointment.appointmentId, appointment.bookingDate, appointmnet.bookingTime.toString(), userId)));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessBookingPage(
                      appointmentId: widget.appointment.appointmentId,
                      bookingDate: bookingDateTime,
                      bookingTime: widget.appointment.bookingTime.toString(),
                      userId: widget.userId,
                    ),
                  ),
                );
              }: null,
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple[50],
              ),
              child: Text('Check-In'),
            ),
          ],
        ),
      ),
    );
  }
}
