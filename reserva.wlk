object reserva{
    var areas = []
    var property valorLimite 
    

    method expandirse() {
        const animalesVigorosos = areas.flatMap({ a => a.animalMasVigoroso()})
        self.quitarAnimales()
        areas.agregarArea( const nuevaArea = new Area(agua=1000, refugios=800, animales=animalesVigorosos ) ) 
    }
    method quitarAnimales(){
        areas.forEach { a=> a.quitarMasVigoroso()}
    }

    method agregarArea(area) = areas.add(area)

    method areasEnDesequilibrio() = areas.count{a=> not a.estaEnEquilibrio()}

}

class Animal{


    method energia() {}

    method reaccion() {}

    method recuperarse(){}

    method consumirRecursos(area){}

    method estaSatisfecho(area){
    return area.agua() > 3 * self.energia() or self.condicionAdicional(area)
  }
    method condicionAdicional(area) {}
}

class Ciervo inherits Animal {
    var property nivelAlerta = 20

    override method energia() {
        if (nivelAlerta <= 30) 300 else self.dobleAlerta()
    }

    method dobleAlerta() = nivelAlerta * 2

    override method reaccion () {  nivelAlerta *= 2}

    override method consumirRecursos(area) = area.agua() -= 4

    override method recuperarse() { nivelAlerta += 20}

    override method condicionAdicional(area)= area.agua() >= 10
}

class CiervoDeMontaña inherits Ciervo{

    override method energia() = super() + 15

    override method recuperarse() {  super() + nivelAlerta+=1 }
}

class Felino inherits Animal{
    var peso
    var ferocidad

    override method energia() {
        if (peso < 90) return ferocidad else ferocidad/2
    }

    override method reaccion() { peso += 20}

    method afilarGarras(){
        peso -= 10
        ferocidad += 10
    }

    override method consumirRecursos(area) = area.agua() -= 8

    override method recuperarse() {
        peso += 15
        ferocidad += 15
    }
    override method condicionAdicional(area){
     return area.hayAlgunoMasDebil(self.energia())
    }
    
}

class FelinoDeManchas inherits Felino{
    var property manchas

    override method energia() = super() + self.energiaAdicional()

    method energiaAdicional() = manchas * 2

    override method reaccion() = super() + self.agregarMancha()

    method agregarMancha() {manchas += 1}

    override method condicionAdicional(area){
      return area.refugios() >= manchas
    } 
}

class AveRapaz inherits Animal {
    var altura

    override method energia()= altura * 3

    override method reaccion() {altura += 50}

    method vueloReconocimiento() { altura = 5 }

    override method consumirRecursos() {}

    override method condicionAdicion(area) = false
}
class Area{
    var property agua
    var property refugios
    var animales = []

    method debiles() = animales.filter { a => a.energia() < reserva.valorLimite() }


    method esHabitable() = self.aguaSuficiente() && self.refugiosSuficientes()

    method aguaSuficiente() = agua >= 700

    method refugiosSuficientes() = refugios.between(200,300)

    method agregarAnimal(animal) = animales.add(animal)


    method animalMasVigoroso() = animales.max{a=>a.energia()}

    method quitarMasVigoroso() {
        animales.remove( self.animalMasVigoroso() )
    }

    method sufrirAmenaza(amenaza) { 
         animales.forEach{a=>a.reaccion()}
         self.consecuencias()
    }

    method consecuencias() {
        agua *= 0.9
    }


    method intervencionDeProfesionales() {
        animales.forEach{a=>a.recuperarse()}
        animales.forEach{a=>a.consumirRecursos(self)}
    }

    method estaEnEquilibrio() {
        if self.esHabitable() && self.animalesSatisfechos()
    }

    method animalesSatisfechos() = animales.all( { a=> a.estaSatisfecho(self)})
        
    method hayAlgunoMasDebil(valor){
        return animales.any { a=> a.energia() > valor}
    }

}

class Amenaza{
    const nombre = ''
}

