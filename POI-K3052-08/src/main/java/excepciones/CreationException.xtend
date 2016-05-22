package excepciones

import java.lang.Exception

class CreationException extends Exception {
	new(String msj){
		super(msj)
	}
}