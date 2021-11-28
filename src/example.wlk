/* EL ASADITO */
import wollok.game.*

class Persona {
	const property objetosQueTieneCerca = []
	const posiciones = []
	var property criterioParaPasarLaComida = sordo
	var property criterioParaComer = vegetariano
	var property comidas = []
	
	method posicion(nuevaPosicion){
		posiciones.add(nuevaPosicion)
	}
	
	method posicion() = posiciones.last()
	
	method primerElementoCercano() = objetosQueTieneCerca.head()
	
	method tieneElemento(elemento) = objetosQueTieneCerca.contains(elemento)
	
	method agregarElementos(_elementos){
		objetosQueTieneCerca.addAll(_elementos)
	}
	
	method quitarElementos(elementos) {
		objetosQueTieneCerca.removeAllSuchThat{ elementoCercano => elementos.contains(elementoCercano)}
	}
	
	method darElemento(elemento, personaQuePide){
		if(!self.tieneElemento(elemento)){
			throw new DomainException(message= "No tengo cerca el elemento " + elemento)
		}
		criterioParaPasarLaComida.pasarElemento(elemento, self, personaQuePide)
	}
	
	method comer(comida){
		if(criterioParaComer.puedeComer(comida)) comidas.add(comida)
	}
	
	method pipon() = comidas.any({comida => comida.esPesada()})
	
	method comioAlgo() = !comidas.isEmpty()
	
	method laEstaPasandoBien() = self.comioAlgo() && self.criterioParaPasarlaBien()
	
	method criterioParaPasarlaBien()
}

class CriterioAPasarElementos {
	method pasarElemento(elemento, personaQueDa, personaQuePide){
		const elementosAPasar = self.elementosAPasar(elemento, personaQueDa)
		personaQuePide.agregarElementos(elementosAPasar)
		personaQueDa.quitarElementos(elementosAPasar)
	}
	
	method elementosAPasar(elemento, personaQueDa)
}

object sordo inherits CriterioAPasarElementos {
	override method elementosAPasar(elemento, personaQueDa) = [personaQueDa.primerElementoCercano()]
}

object quiereComerTranquilo inherits CriterioAPasarElementos {
	override method elementosAPasar(elemento, personaQueDa) = [personaQueDa.objetosQueTieneCerca()]
}

object movedizo {
	method pasarElemento(elemento, personaQueDa, personaQuePide) {
		const posicionDeLaQuePide = personaQuePide.posicion()
		personaQuePide.posicion(personaQueDa.posicion())
		personaQueDa.posicion(posicionDeLaQuePide)
		
	}
}

object obediente inherits CriterioAPasarElementos {
	override method elementosAPasar(elemento, personaQueDa) = [elemento]
}

class Comida {
	const property calorias
	const property esCarne
	
	method esPesada() = calorias > 500
}


object vegetariano {
	method puedeComer(comida) = !comida.esCarne()
}

object dietetico {
	var property caloriasRecomendadas = 500
	method puedeComer(comida) = comida.calorias() < caloriasRecomendadas
}

class Alternado {
	var quiero = false
	
	method puedeComer(comida) {
		quiero = !quiero
		return !quiero
	}
}

class Combinado {
	const property criteriosDeAceptacion = []
	
	method agregarCriterios(_criterios) = criteriosDeAceptacion.addAll(_criterios)
	
	method puedeComer(comida) = criteriosDeAceptacion.all({criterio => criterio.puedeComer(comida)})
}

object osky inherits Persona{
	override method criterioParaPasarlaBien() = true
}

object moni inherits Persona{
	override method criterioParaPasarlaBien() = self.posicion() == "1@1"
}

object facu inherits Persona{
	override method criterioParaPasarlaBien() = self.comidas().any({comida => comida.esCarne()})
}

object vero inherits Persona{
	override method criterioParaPasarlaBien() = self.objetosQueTieneCerca().size() <= 3
}
