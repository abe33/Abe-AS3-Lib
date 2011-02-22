/**
 * @license
 */
package abe.com.ponents.core 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.ponents.core.focus.FocusGroup;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.layouts.components.ComponentLayout;

	/**
	 * Un objet <code>Container</code> est un <code>Component</code> pouvant contenir
	 * d'autre <code>Component</code> en tant que sous-composants. Un <code>Container</code>
	 * assure le positionnement et le dimensionnement des sous-composants à l'aide d'un
	 * objet <code>ComponentLayout</code>.
	 * <p>
	 * Un objet <code>Container</code> sera en règle général le <code>focusParent</code>
	 * des sous-composants qu'il possède, c'est pour celà que l'interface <code>Container</code>
	 * étend l'interface <code>FocusGroup</code>. 
	 * </p>
	 * <p>
	 * L'interface <code>Container</code> définie des méthodes spécifiques pour l'ajout 
	 * de sous-composants, permettant ainsi de pouvoir ajouter des enfants dans la chaîne
	 * graphique indépendamment de la gestion des sous-composants.
	 * </p>
	 * @author Cédric Néhémie
	 * @see abe.com.ponents.core.focus.FocusGroup
	 */
	public interface Container extends Component, 
									   Focusable,
									   FocusGroup, 
									   IDisplayObject, 
									   IDisplayObjectContainer, 
									   IInteractiveObject
	{
		/**
		 * Une référence une copie du vecteur contenant les composants enfants
		 * de ce <code>Container</code>.
		 * <p>
		 * Un <code>Container</code> ne renvoie qu'une copie du vecteur, 
		 * et non pas une référence vers le vecteur, afin de prévenir tout
		 * risque de transformation de ce vecteur par du code extérieur 
		 * au <code>Container</code>.
		 * </p>
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		function get children(): Array;		
		TARGET::FLASH_10		function get children(): Vector.<Component>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		function get children(): Vector.<Component>;
		/**
		 * Le nombre de sous-composants actuellement dans ce <code>Container</code>.
		 */
		function get childrenCount(): int;
		
		/**
		 * Une référence vers l'objet <code>ComponentLayout</code> chargé de gérer
		 * le positionnement et le dimensionnement des sous-composants de ce <code>Container</code>.
		 */
		function get childrenLayout() : ComponentLayout;
		function set childrenLayout( cl : ComponentLayout ): void;
		
		/**
		 * Si à <code>false</code>, les contextes claviers définits par les descendants
		 * de ce <code>Container</code> seront ignorés.
		 */
		function get childrenContextEnabled () : Boolean;
		function set childrenContextEnabled ( b : Boolean ) : void;
		
		/**
		 * Une référence vers le premier enfant de ce <code>Container</code>.
		 */
		function get firstChild() : Component;
		/**
		 * Une référence vers le dernier enfant de ce <code>Container</code>.
		 */
		function get lastChild() : Component;
		/**
		 * Vaut <code>true</code> si ce <code>Container</code> possède des sous-composants, 
		 * vaut <code>false</code> autrement.
		 */
		function get hasChildren() : Boolean;
			
		/**
		 * Ajoute le composant <code>c</code> comme sous-composant de ce <code>Container</code>
		 * 
		 * @param	c	composant à ajouter en tant qu'enfant de cet objet
		 */
		function addComponent( c : Component): void;
		/**
		 * Ajoute un ensemble de composants comme sous-composants de ce <code>Container</code>.
		 * 
		 * @param	args	une liste de <code>Component</code> à ajouter à ce <code>Container</code>
		 */
		function addComponents( ... args ) : void;
		/**
		 * Enlève le composant <code>c</code> des sous-composants de ce <code>Container</code>.
		 * 
		 * @param	c	composant à enlever des sous-composant de cet objet
		 */
		function removeComponent( c : Component ) : void;
		/**
		 * Renvoie <code>true</code> si le composant <code>c</code> est actuellement un descendant 
		 * de ce <code>Container</code>. Un composant est considéré comme étant un descendant d'un
		 * objet <code>Container</code> s'il est un enfant de cet objet, ou de l'un de ces enfants.
		 * 
		 * @param	c	composant dont on souhaite savoir s'il appartient à la descendance de cet objet
		 * @return	<code>true</code> si le composant <code>c</code> est actuellement un descendant 
		 * 			de ce <code>Container</code>
		 */
		function isDescendant ( c : Component ) : Boolean;
	}
}
