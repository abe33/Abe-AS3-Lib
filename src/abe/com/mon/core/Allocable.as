/**
 * @license
 */
package abe.com.mon.core 
{

	/**
	 * The <code>Allocable</code> interface define the methods that an object
	 * which shall be used with an <code>Allocator</code> have to implement.
	 * <p>
	 * As objects retreived from an <code>Allocator</code> are not instanciated
	 * as any other objects, the <code>Allocable</code> interface provides two
	 * methods intended for developpers to control the object during the 
	 * allocation/deallocation stage.
	 * </p>
	 * 
	 * <fr>
	 * L'interface <code>Allocable</code> définie les règles que doivent respecter
	 * les objets destinés à être utilisé dans un <code>Allocator</code>. 
	 * <p>
	 * Comme les objets utilisés par un <code>Allocator</code> ne sont pas instanciés
	 * de manière traditionnelle, l'interface <code>Allocable</code> définie deux méthodes
	 * destinées à fournir aux développeurs des contrôles sur l'objet lors des phases
	 * d'allocation/désallocation de ce dernier.  
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 * @see Allocator
	 * @see abe.com.mon.core.impl.AllocatorImpl
	 */
	public interface Allocable 
	{
		/**
		 * Function called by an <code>Allocator</code> when the current object is allocated
		 * and move to the used instances list.
		 * 
		 * <fr>
		 * Fonction appelée par un objet <code>Allocator</code> lorsque l'objet courant passe
		 * de la pile des objets inutilisés à celle des objets utilisés.
		 * </fr>
		 */
		function init () : void;
		
		/**
		 * Function called by an <code>Allocator</code> when the current object is mark as unused
		 * and deallocated.
		 * 
		 * <fr>
		 * Fonction appelée par un objet <code>Allocator</code> lorsque l'objet courant passe
		 * de la pile des objets utilisés à celle des objets inutilisés.
		 * </fr>
		 */
		function dispose () : void;
	}
}
