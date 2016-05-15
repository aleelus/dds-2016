package interfazUsuario

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ElementoReporteTerminal {
	String nombreTerminal
	List<Integer> resultadosParciales = new ArrayList<Integer>
	
	new(){
		super()
	}
	
	new(String nombre){
		this()
		this.nombreTerminal = nombre
	}	
}