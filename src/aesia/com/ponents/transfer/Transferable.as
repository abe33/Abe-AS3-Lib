/**
 * @license
 */
package  aesia.com.ponents.transfer 
{

	/**
	 * Les objets <code>Transferable</code> interviennent en tant
	 * que container de donnée dans les opérations de copier/coller
	 * et de glissé/déposé de l'interface. 
	 * <p>
	 * Chaque objet <code>Transferable</code> possède un certain 
	 * nombre de <i>saveurs</i> (<code>flavors</code>) qui définissent
	 * la nature des données transférées et les possibilités de
	 * conversion qu'il supporte.
	 * </p>
	 */
	public interface Transferable 
	{
		/**
		 * Renvoie les données transférées convertit au format
		 * définit par <code>flavor</code>.
		 * 
		 * @return les données transférées convertit au format
		 * 		   définit par <code>flavor</code>
		 */
		function getData ( flavor : DataFlavor ) : *;
		/**
		 * Renvoie un tableau des saveurs supportés par cette
		 * instance de <code>Transferable</code>.
		 * 
		 * @return un tableau des saveurs supportés par cette
		 * 		   instance de <code>Transferable</code>
		 */
		function get flavors () : Array;
		/**
		 * 
		 */
		function get mode () : String;
		/**
		 * 
		 */
		function transferPerformed () : void;
	}
}
