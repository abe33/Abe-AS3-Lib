/**
 * @license
 */
package aesia.com.mon.core 
{

	/**
	 * L'interface <code>Allocable</code> définie les règles que doivent respecter
	 * les objets destinés à être utilisé dans un <code>Allocator</code>. 
	 * <p>
	 * Comme les objets utilisés par un <code>Allocator</code> ne sont pas instanciés
	 * de manière traditionnelle, l'interface <code>Allocable</code> définie deux méthodes
	 * destinées à fournir aux développeurs des contrôles sur l'objet lors des phases
	 * d'allocation/désallocation de ce dernier.  
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see Allocator
	 * @see aesia.com.mon.core.impl.AllocatorImpl
	 */
	public interface Allocable 
	{
		/**
		 * Fonction appelée par un objet <code>Allocator</code> lorsque l'objet courant passe
		 * de la pile des objets inutilisés à celle des objets utilisés.
		 */
		function init () : void;
		
		/**
		 * Fonction appelée par un objet <code>Allocator</code> lorsque l'objet courant passe
		 * de la pile des objets utilisés à celle des objets inutilisés.
		 */
		function dispose () : void;
	}
}
