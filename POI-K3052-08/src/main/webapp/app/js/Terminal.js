function Terminal (){

    this.nombreTerminal= "";
    this.contraseña = "";
    this.listaFavoritos = [];
    this.latitud = 0;
    this.longitud = 0;

};


Terminal.prototype.esFavoritoDe = function (usuario,poi,poiFavorito) {

    if(poiFavorito(poi.id)){
        _.remove(usuario.listaFavoritos,function (num) {
            return num===poi.id;
        });
        return false;
    }else{
        usuario.listaFavoritos.push(poi.id);
        return true;
    }

};



Terminal.asTerminal = function (json) {
    return angular.extend(new Terminal(), json);
};