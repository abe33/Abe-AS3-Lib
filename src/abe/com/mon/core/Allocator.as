/**
 * @license
 */
package abe.com.mon.core 
{
	/**
	 * An <code>Allocator</code> object manage pools of class instances
	 * intended to be reused during the program execution. It provide
	 * a way to limit the number of instanciation and destruction of
	 * instances.
	 * <p>
	 * As ActionScript don't yet support generics, the <code>Allocator</code>
	 * interface don't specify the return type of the <code>get</code> method.
	 * Instead, the <code>get</code> method take an argument whose type is
	 * <code>Class</code> to define the returned object type. An <code>Allocator</code>
	 * implementation can choose to ignore this argument. However, an implementation
	 * of the <code>Allocable</code> should always return a valid instance (neither
	 * <code>null</code> nor <code>undefined</code>), no matter the number of instances
	 * allready created.  
	 * </p>
	 * <p>
	 * Objects created by an <code>Allocator</code> can implements the <code>Allocable</code>
	 * interface, in that case the <code>Allocator</code> should use the methods defined
	 * in the <code>Allocable</code> interface when allcating or deallocating instances.
	 * </p>
	 * 
	 * <fr>
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
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 * @see Allocable
	 * @see abe.com.mon.core.impl.AllocatorImpl
	 * @see	abe.com.mon.utils.AllocatorInstance
	 */
	public interface Allocator 
	{
		/**
		 * Allocate and return an instance of the class <code>c</code>.
		 * The instance can be initialized with the data provided in
		 * the <code>defaults</code> object.
		 * 
		 * <fr>
		 * Alloue et renvoie une instance de la classe <code>c</code>. 
		 * L'instance peut être initialisée à l'aide des données transmises
		 * dans l'argument <code>defaults</code>.
		 * </fr>
		 * @param	c			the class of the object to allocate
		 * 						<fr>la classe de l'objet à allouer</fr>
		 * @param	defaults 	an object containing the default values for 
		 * 						the allocated object properties
		 * 						<fr>un objet contenant les valeurs par défaut pour les 
		 * 					   	propriétés de l'objet alloué</fr>
		 * @return	an instance of the class <code>c</code>
		 * 			<fr>une instance de la classe <code>c</code></fr>
		 */
		function get( c : Class, defaults : Object = null ) : *;
		
		/**
		 * Release the object <code>o</code> from the used instances pool.
		 * After a call to <code>release</code> the instance <code>o</code>
		 * will be available again for allocation in a call to the <code>get</code>
		 * method.
		 * <p>
		 * The <code>release</code> method takes an extra argument which
		 * allow an implementation to define in which pool the object is
		 * stored. This argument can be usefull for implementations which
		 * deals with many types of instances.
		 * </p>
		 * 
		 * <fr>
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
		 * </fr>
		 * @param	o	the object to release from the used instances pool
		 * 				<fr>l'objet à libérer de la pile d'allocation</fr>
		 * @param	c	the type of the object, it can be used by an implementation
		 * 				to retreive the pool in which storing the instance 
		 * 				<fr>le type définissant la collection d'instances 
		 * 				à laquelle appartient l'objet courant</fr>
		 */
		function release ( o : *, c : Class = null ) : void;
	}
}
