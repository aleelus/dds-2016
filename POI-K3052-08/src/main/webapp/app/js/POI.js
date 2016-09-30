function POI(){

    this.nombre = "";
    this.direccion = "";
    this.id= 0;
    this.listaComentarios = [];
}

function Comentario(){

    this.usuario="";
    this.detalle = "";
    this.calificacion="";

}


POI.prototype.agregarComentario = function (poi) {
    var nuevo = _.find(poisList,function (dato) {
        return dato.id===poi.id;
    });
    nuevo.listaComentarios = listaOpinion;
};

POI.prototype.calcularCalificacion = function (poi) {
    if(poi.listaComentarios.length>0){
        var sumatoria = _.sumBy(poi.listaComentarios, function (comment) {
            return _.toInteger(comment.calificacion);
        });
        return ( sumatoria / poi.listaComentarios.length );
    }else{
        return "no hay calificación";
    }

    
};

POI.prototype.calcularDistanciaPOI = function (poi,usuario) {

    poiPuntos = new Point(poi.latitud,poi.longitud);
    return poiPuntos.distance(new Point(usuario.latitud,usuario.longitud));
    
};






POI.asPOI = function (jsonTarea) {
    return angular.extend(new POI(), jsonTarea);
};

Comentario.asComentario= function (jsonTarea) {
    return angular.extend(new Comentario(), jsonTarea);
};