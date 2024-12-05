

/*TextButton botonWidget(BuildContext context, String texto, {Function pAccion}){
  var rsBoton = TextButton(onPressed: (){
    pAccion();
  },
  child:  new ClipRRect(borderRadius: BorderRadius.circular(20.0),
        child:Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: miColorFondo,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: miColorBotones, blurRadius: 10),
                                                BoxShadow()]),
          child: new Text(texto,style: miEstiloTextButton,textAlign: TextAlign.center,),          
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width * 0.35),
          height: (MediaQuery.of(context).size.height * 0.08),
        ),
  ),
    /*style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),side: BorderSide(color: miColorFondo)),
                      ),
      )*/
      //padding: EdgeInsets.all(0.0),
    );

    return rsBoton;
}*/