package aesia.com.patibility.accessors 
{
	/**
	 * An <code>Accessor</code> object is responsible for providing a way to access a data somewhere.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Accessor 
	{
		function get () : *
		function set ( v : * ) : void;
		
		function get value() : *;
		function set value( v : * ) : void;
	}
}
