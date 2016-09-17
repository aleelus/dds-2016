poiApp.service('busquedasService', function($http) {
    this.mandarLista = function(lista,callback) {
        $http.post('/paginas',lista).then(callback);
    }
    this.recibirPOIS = function(callback) {
        $http.get('/paginas').then(callback);
    }
});




//[{"id":2,"nombre":"Don José","direccion":"Quintana 861","latitud":10.0,"longitud":5.0,"tags":["José","Rotiseria","Barato"],"habilitado":true,"rubro":{"radioCercania":5.0,"nombre":"Rotiseria","horario":[],"diasAbierto":[]},"new":false},
//{"id":3,"nombre":"Don Yoyo","direccion":"Quintana 130","latitud":10.0,"longitud":5.0,"tags":["Yoyo","Librería","Barato"],"habilitado":true,"rubro":{"radioCercania":5.0,"nombre":"Librería","horario":[],"diasAbierto":[]},"new":false}]
