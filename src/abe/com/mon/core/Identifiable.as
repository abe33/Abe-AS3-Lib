/**
 * @license
 */
package abe.com.mon.core 
{
	/**
	 * An <code>Identifiable</code> object has an <code>id</code> 
	 * property of the type <code>String</code>.
	 * 
	 * <fr>
	 * Un objet <code>Identifiable</code> possède une propriété 
	 * <code>id</code> de type <code>String</code>.
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Identifiable 
	{
		/**
		 * The identifier for this instance.
		 * 
		 * <fr>L'identifiant de cet instance.</fr>
		 */
		function get id() : String;
		function set id( s : String ) : void;
	}
}
