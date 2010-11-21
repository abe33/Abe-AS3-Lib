/**
 * @license
 */
package aesia.com.patibility.codecs
{

	/**
	 * L'interface <code>Codec</code> définie les méthodes qu'un en<b>co</b>deur/<b>déc</b>odeur
	 * se doit d'implémenter.
	 */
	public interface Codec
	{
		/**
		 * Le type définissant le format des données encodées.
		 */
		function get encodedType () : Class;
		/**
		 * Le type définnissant le format des données décodées.
		 */
		function get decodedType () : Class;
		/**
		 * Réalise l'encodage des données.
		 *
		 * @param	o	l'objet contenant les données à encoder.
		 * @return	les données encodées
		 */
		function encode ( o : * ) : *;
		/**
		 * Réalise le décodage des données
		 *
		 * @param	o	l'objet contenant les données à décoder
		 * @return	les données décodées
		 */
		function decode ( o : * ) : *;
	}
}