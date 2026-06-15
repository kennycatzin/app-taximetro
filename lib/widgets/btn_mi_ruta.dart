part of 'widgets.dart';

class BtnMiRuta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: CircleBorder(),
      child: IconButton(
        tooltip: 'Viajes',
        padding: EdgeInsets.all(14),
        icon: Icon(Icons.airplanemode_active_rounded, color: Colors.black87),
        onPressed: () {
          Navigator.pushNamed(context, 'viajes');
        },
      ),
    );
  }
}
