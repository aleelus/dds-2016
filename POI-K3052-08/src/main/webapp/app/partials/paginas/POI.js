function POI(){

    this.nombre = "";
    this.direccion = "";
    this.id= 0;

}


POI.asPOI = function (jsonTarea) {
    return angular.extend(new POI(), jsonTarea);
};