import 'package:flutter/material.dart';
import 'package:ui/booking_appointment_page.dart';
import 'package:ui/feedback.dart';
import 'package:ui/profile.dart';
import 'package:ui/schedule.dart';

class MenuPage extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  const MenuPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState(userId: userId);
}


class _MenuPageState extends State<MenuPage> {
  late final int userId;
  _MenuPageState({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title:
          const Text("Home", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.black,
          ),
          ),
          actions: [
            Padding(padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (){},
                child: const Icon(Icons.search, size: 26.0,),
            ),)
          ],
        ),
        body: MyGridView(userId: userId),
      ),
    );

  }
}


class MyGridView extends StatelessWidget {
  final int userId; // Assuming userId is of type int
  const MyGridView({Key? key, required this.userId}) : super(key: key);

  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 20, 200),
      color: Colors.deepPurple[100],
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 2,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Appointment", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                IconButton.filledTonal(icon: const Icon(Icons.local_hospital), iconSize: 50,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingPage(userId: userId)),);
                  },),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Schedule", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                IconButton.filledTonal(icon: const Icon(Icons.calendar_month), iconSize: 50,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleAppointmentPage(userId: userId)),);
                    },),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
            ),
            child: Column(
              children: [
                const Text("Feedback", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                IconButton.filledTonal(
                    iconSize: 50,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedbackPage()),);
                    },
                    icon: const Icon(Icons.feedback_rounded)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Profile", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                IconButton.filledTonal(
                    iconSize: 50 ,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(userId: userId)),);
                    },
                    icon: const Icon(Icons.people)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

