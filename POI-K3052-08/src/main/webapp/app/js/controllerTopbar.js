poiApp.controller('topbarController', function (serviceBusq) {

    var self = this;

    self.dameUsuarioSrv = function () {
        return serviceBusq.getUsuarioSrv();
    }

});