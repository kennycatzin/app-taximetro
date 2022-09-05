part of 'helpers.dart';

void Confirmacion(BuildContext context, String texto) {
  // set up the buttons
  Widget cancelButton = TextButton(onPressed: () {}, child: Text("Cancelar"));

  Widget continueButton =
      TextButton(onPressed: () {}, child: Text("Confirmar"));
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alerta de confirmación"),
    content: Text(texto),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
