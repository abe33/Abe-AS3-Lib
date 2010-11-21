/**
 * @license
 */
package aesia.com.mon.core 
{

	/**
	 * Un object <code>Allocator</code> gère des réservoirs d'instances
	 * destinés à être réutilisés afin de limiter les accès mémoire en 
	 * cas de création/destruction intensive d'objet.
	 * <p>
	 * Comme ActionScript 3 ne supporte pas les generics, l'interface 
	 * <code>Allocator</code> ne précise pas de type spécifique en retour.
	 * Au lieu de cela, la méthode <code>get</code> autorise un argument
	 * de type <code>Class</code> permettant de définir le type de l'objet
	 * à retourner. Les implémentations de l'interface <code>Allocator</code>
	 * peuvent choisir d'ignorer cet argument, ou de l'utiliser pour retourner
	 * un objet d'un type définit par l'implémentation. Cependant, une implémentation
	 * de la méthode <code>get</code> devrait toujours renvoyer une instance valide
	 * (pas de <code>null</code> ou de <code>undefined</code>), quelque soit le nombre
	 * d'instances déjà créées.
	 * </p>
	 * <p>
	 * Les objets utilisés par un <code>Allocator</code> peuvent implémenter l'interface
	 * <code>Allocable</code>. Dans ce cas, l'implémentation de <code>Allocator</code>
	 * devrait utiliser les méthodes définies par <code>Allocable</code> lors de 
	 * l'allocation ou de la désallocation de ces objets.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see Allocable
	 * @see aesia.com.mon.core.impl.AllocatorImpl
	 * @see	aesia.com.mon.utils.#AllocatorInstance
	 */
	public interface Allocator 
	{
		/**
		 * Alloue et renvoie une instance de la classe <code>c</code>. 
		 * L'instance peut être initialisée à l'aide des données transmises
		 * dans l'argument <code>defaults</code>.
		 *  
		 * @param	c			la classe de l'objet à allouer
		 * @param	defaults 	un objet contenant les valeurs par défaut pour les 
		 * 					   	propriétés de l'objet alloué. 
		 * @return	une instance de la classe <code>c</code>
		 */
		function get( c : Class, defaults : Object = null ) : *;
		
		/**
		 * Libère l'objet passé en argument de la pile des objets
		 * utilisés. Après un appel à <code>release</code>, l'instance
		 * libérée sera de nouveau allouable lors d'un appel à 
		 * la méthode <code>get</code>.
		 * <p>
		 * La fonction prend un argument optionnel en supplément. 
		 * Celui-ci permet de définir la classe de la collection
		 * à laquelle appartient l'instance. Cet argument est utile
		 * si l'implémentation courante de l'interface <code>Allocator</code>
		 * utilise des piles d'instances de types différents. 
		 * </p>
		 * 
		 * @param	o	l'objet à libérer de la pile d'allocation
		 * @param	c	[optionel] le type définissant la collection d'instances 
		 * 				à laquelle appartient l'objet courant.
		 */
		function release ( o : *, c : Class = null ) : void;
	}
}
