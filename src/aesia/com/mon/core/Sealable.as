/**
 * @license
 */
package  aesia.com.mon.core 
{
	/**
	 * Un objet <code>Sealable</code> est un objet dont les propriétés ne
	 * sont accessibles en écriture jusqu'à ce qu'un appel à la méthode
	 * <code>seal</code> scelle l'objet et interdise l'écriture à ces
	 * propriétés.
	 */
	public interface Sealable 
	{
		/**
		 * Scelle l'objet courant. Toutes ses propriétés
		 * seront en lecture seule à la fin de l'appel.
		 */
		function seal () : void;
		/**
		 * Renvoie <code>true</code> si l'objet a été scellé suite
		 * à un appel de la méthode <code>seal</code>.
		 * 
		 * @return <code>true</code> si l'objet a été scellé suite
		 * 		   à un appel de la méthode <code>seal</code>
		 */
		function isSealed () : Boolean;
	}
}
