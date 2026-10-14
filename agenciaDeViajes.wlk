class Pack {
    const property duracion 
    const property precioBase
    const property beneficios = []
    var property coordinador

    method beneficiosVigentes() = beneficios.filter({ beneficio => beneficio.vigente() })
    method costoBeneficiosVigentes() = self.beneficiosVigentes().sum({ beneficio => beneficio.costo() })
    method subtotal() = precioBase + self.costoBeneficiosVigentes()
    method valorFinal() = self.subtotal() + self.recargo()

    method recargo()
    
    method esPremium()
}

class Nacional inherits Pack {
    const property actividades = []
    const property provinciaDestino 

    override method esPremium() = duracion > 10 && coordinador.altamenteCalificado() 
}

class Internacional inherits Pack {
    const property paisDestino 
    const property cantEscalas
    const property esDeInteres 

    override method recargo() = self.subtotal() * 0.2

    override method esPremium() = esDeInteres && duracion > 20 && cantEscalas == 0
}

class Provincial inherits Nacional {
    const property ciudadesAVisitar
    
    override method esPremium() = actividades.size() >= 4  && ciudadesAVisitar > 5 &&  self.beneficiosVigentes() >= 3

    override method recargo() = if(self.esPremium()) self.subtotal() * 0.5 else 0
}

class Coordinador {
    var property rolesPermitidos = [guia, asistente, acompañante]
    var property cantViajes
    var property estaMotivado
    var property añosExp
    var rolActual

    method rolDelCoordinador(unRol){
        if(!rolesPermitidos.contains(unRol)){
            throw new DomainException(message = "Rol inválido")
        }
        rolActual = unRol
    }
    method rol() = rolActual

    method altamenteCalificado() = self.cantViajes() > 20 && rolActual.cumpleCondicion(self)
}
object guia {
    method cumpleCondicion(coordinador) = coordinador.estaMotivado()
}
object asistente {
    method cumpleCondicion(coordinador) = coordinador.añosExp() >= 3
}
object acompañante {
    method cumpleCondicion(coordinador) = true
}

class Beneficios {
    var property costo 
    var property estaVigente = true
    var property tipo

}
