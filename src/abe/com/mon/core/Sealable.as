/**
 * @license
 */
package  abe.com.mon.core 
{
	/**
	 * A <code>Sealable</code> object is an object whose properties
	 * can be sealed by calling the <code>seal</code> method. All the
	 * properties of a sealed object become read-only after the call.
	 * <p>
	 * A sealed object can't be unsealed. If you need to allow
	 * a change on a sealed object, make your class implements 
	 * <code>Cloneable</code> and modify the unsealed clone of
	 * the sealed object. 
	 * </p>
	 * 
	 * <fr>
	 * Un objet <code>Sealable</code> est un objet dont les propriétés ne
	 * sont accessibles en écriture jusqu'à ce qu'un appel à la méthode
	 * <code>seal</code> scelle l'objet et interdise l'écriture à ces
	 * propriétés.
	 * </fr>
	 */
	public interface Sealable 
	{
		/**
		 * Seal the current object. All its properties will
		 * become read-only after the call.
		 *  
		 * <fr>
		 * Scelle l'objet courant. Toutes ses propriétés
		 * seront en lecture seule à la fin de l'appel.
		 * </fr>
		 */
		function seal () : void;
		/**
		 * Returns <code>true</code> if the object was sealed
		 * by a call to the <code>seal</code> method.
		 * <fr>
		 * Renvoie <code>true</code> si l'objet a été scellé suite
		 * à un appel de la méthode <code>seal</code>.
		 * </fr>
		 * @return	<code>true</code> if the object was sealed
		 * 			by a call to the <code>seal</code> method
		 * 			<fr><code>true</code> si l'objet a été scellé suite
		 * 		 	à un appel de la méthode <code>seal</code></fr>
		 */
		function isSealed () : Boolean;
	}
}
