function POI(){

    this.nombre = "";
    this.direccion = "";
    this.id= 0;
}

function Comentario(){

    this.usuario="";
    this.detalle = "";
    this.calificacion="";

}


POI.asPOI = function (jsonTarea) {
    return angular.extend(new POI(), jsonTarea);
};

POI.asComentario= function (jsonTarea) {
    return angular.extend(new Comentario(), jsonTarea);
};