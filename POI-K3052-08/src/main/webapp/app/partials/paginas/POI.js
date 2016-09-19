function POI(){

    this.nombre = "";
    this.direccion = "";
    this.id= 0;
    this.rubro = {};
    this.servicios = [];
    this.lineas = [];

}


POI.asPOI = function (jsonTarea) {
    return angular.extend(new POI(), jsonTarea);
};