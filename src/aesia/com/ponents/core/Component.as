/**
 * @license
 */
package aesia.com.ponents.core 
{
	import aesia.com.mon.core.Identifiable;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;

	/**
	 * L'interface <code>Component</code> définie l'ensemble des propriétés 
	 * essentielle des composants.
	 * 
	 * @author Cédric Néhémie 
	 * @see ../../../../annexes-summary.html#components Annexes des composants
	 */
	public interface Component extends Focusable, 
									   IDisplayObjectContainer, 
									   IDisplayObject, 
									   IInteractiveObject,
									   DragSource,
									   Identifiable
	{		
		/**
		 * État d'activation de ce composant.
		 * <p>
		 * Un composant désactivé devrait être totalement inerte du point
		 * de vues des interactions avec la souris et de la navigation au clavier. 
		 * Cependant, même un composant inactivé devrait afficher son info-bulle lors 
		 * d'un survol de celui-ci. 
		 * </p>
		 * @see ../../../../components/Style-Structure.html#behavior Structure comportementale
		 */
		function get enabled() : Boolean;
		function set enabled( b : Boolean ) : void;
		
		/**
		 * État d'interactivité de ce composant.
		 * <p>
		 * Un composant dont la propriété <code>interactive</code> est à <code>false</code>
		 * reste actif, seulement les interactions possible avec la souris ou le clavier
		 * sont elles désactivées.
		 * </p>
		 */
		function get interactive() : Boolean;
		function set interactive( b : Boolean ) : void;
		
		/**
		 * Position de ce composant
		 * <p>
		 * La valeur des coordonnées <code>x</code> et <code>y</code>
		 * de la position d'un composant devrait toujours être cohérentes
		 * avec les valeurs des propriétés <code>x</code> et <code>y</code>
		 * du composant.
		 * </p>
		 */
		function get position() : Point;
		function set position( p : Point ) : void;
		/**
		 * Taille de ce composant. 
		 * <p>
		 * <strong>Note :</strong> Il est important de se souvenir que la taille
		 * d'un composant ne peut en aucun cas être garantie. La propriété 
		 * <code>size</code> renvoie la taille du composant à un instant t, cependant, 
		 * définir la taille en utilisant la propriété <code>size</code> ne garantit 
		 * pas qu'elle ne changera pas par la suite.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> Il est vivement conseillé d'utiliser la propriété
		 * <code>preferredSize</code> plutôt que <code>size</code> pour définir une
		 * taille particulière pour un composant.
		 * </p>
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../components/Size-Layout.html Taille et layouts
		 */
		function get size() : Dimension;
		function set size( d : Dimension ) : void;
		/**
		 * Taille de préférence de ce composant. 
		 * <p>
		 * La taille de préférence d'un composant peut être déterminés de deux manières : 
		 * </p>
		 * <ul>
		 * <li>Par le composant lui même, à l'aide de son <code>Layout</code>.</li>		 * <li>Par l'utilisateur du composant, à l'aide de la propriété <code>preferredSize</code></li>
		 * </ul>
		 * <p>
		 * Par principe, un composant devrait toujours privilégier la taille définie
		 * par l'utilisateur lorsque on accède à sa taille de préférence. De même que, 
		 * s'il possède un layout, il devrait toujours privilégier la taille fournie 
		 * par ce dernier si aucune taille n'est précisée par l'utilisateur.
		 * </p>
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../components/Size-Layout.html Taille et layouts
		 */
		function get preferredSize() : Dimension;		function set preferredSize( d : Dimension ) : void;
		
		function get maximumSize() : Dimension;
		function get maximumContentSize() : Dimension;
		/**
		 * Longueur de préférence de ce composant.
		 * 
		 * @see #preferredSize
		 */
		function get preferredWidth() : Number;
		function set preferredWidth( n : Number ) : void;
		/**
		 * Hauteur de préférence de ce composant.
		 * 
		 * @see #preferredSize
		 */
		function get preferredHeight() : Number;
		function set preferredHeight( n : Number ) : void;
		/**
		 * Vaut <code>true</code> si le composant fait actuellement parti
		 * de la display list.
		 */
		function get displayed () : Boolean;
		/**
		 * Accès à l'objet <code>ComponentStyle</code> de ce composant.
		 * <p>
		 * Cette propriété n'a pas nécessairement besoin d'être en écriture
		 * car les objets <code>ComponentStyle</code> compose une chaîne afin
		 * de construire le style exploitable. Ainsi, en changeant uniquement
		 * la clé du style, il est possible de distinguer les modifications 
		 * faites sur le composant de la racine du style de référence.
		 * </p>
		 */		function get style () : ComponentStyle;
		/**
		 * La clé de l'objet <code>style</code> de ce composant.
		 * <p>
		 * Cette clé sert d'accès à la lignée hierarchique des styles.
		 * </p>
		 */
		function get styleKey () : String;
		function set styleKey ( s : String ) : void;
		/**
		 * Renvoie l'objet <code>Container</code> contenant actuellement
		 * le composant ou <code>null</code> s'il n'a aucun parent.
		 */
		function get parentContainer () : Container;
		/**
		 * La valeur de décalage horizontal appliquer au contenu de ce composant.
		 */
		function get contentScrollH () : Number;	
		function set contentScrollH (contentScrollH : Number) : void;
		/**
		 * La valeur de décalage vertical appliquer au contenu de ce composant.
		 */
		function get contentScrollV () : Number;	
		function set contentScrollV (contentScrollV : Number) : void;
		/**
		 * La distance maximum de décalage vertical du contenu de ce composant.
		 */
		function get maxContentScrollV () : Number;
		/**
		 * La distance maximum de décalage horizontal du contenu de ce composant.
		 */
		function get maxContentScrollH () : Number;	
		/**
		 * La zone visible du composant dans son espace de référence.
		 */
		function get visibleArea () : Rectangle;
		/**
		 * La zone visible du composant dans l'espace de l'écran.
		 */		function get screenVisibleArea () : Rectangle;
		/**
		 * Renvoie <code>true</code> si la souris est actuellement au dessus de ce composant.
		 * 
		 * @return <code>true</code> si la souris est actuellement au dessus de ce composant
		 */
		function get isMouseOver () : Boolean;
		
		function get isComponentIndependent () : Boolean;	
		function set isComponentIndependent ( isIndependent : Boolean ) : void;
		
		/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Un dictionnaire contenant les associations 
		 * <code>KeyStroke -> Command</code> à utiliser pour ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#KEYBOARD_CONTEXT">FEATURES::KEYBOARD_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#KEYBOARD_CONTEXT Constante FEATURES::KEYBOARD_CONTEXT
		 */
		function get keyboardContext() : Dictionary;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		/**
		 * [conditional-compile] Un vecteur contenant les objets <code>ContextMenuItem</code> à afficher
		 * dans le menu contextuel de ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */		
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT {
		TARGET::FLASH_9		function get menuContext() : Array;		TARGET::FLASH_10		function get menuContext() : Vector.<ContextMenuItem>;		TARGET::FLASH_10_1 /*FDT_IGNORE*/		function get menuContext() : Vector.<ContextMenuItem>; /*FDT_IGNORE*/ } /*FDT_IGNORE*/		
		
		/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Référence à l'objet <code>Cursor</code> utilisé lorsque la souris survole
		 * ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#CURSOR">FEATURES::CURSOR</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#CURSOR Constante FEATURES::CURSOR
		 */
		function get cursor () : Cursor;	
		function set cursor ( s : Cursor ) : void;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Déclenche l'affichage de l'info-bulle de ce composant.
		 * <p>
		 * L'argument <code>overlay</code> détermine si l'info-bulle vient se superposer
		 * au composant ou si elle se positionne relativement à la souris.
		 * </p> 
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @param overlay 	détermine si l'info-bulle vient se superposer
		 * 					au composant ou si elle se positionne relativement à la souris
		 * @see ../../../../components/Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		function showToolTip (overlay : Boolean = false) : void;
		/**
		 * [conditional-compile] Masque l'info-bulle de ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		function hideToolTip () : void;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		/**
		 * Ajoute un écouteur au composant en utilisant une référence faible pour stocker l'écouteur.
		 *  
		 * @param eventType	type de l'évènement auquel l'écouteur s'abonne
		 * @param listener	l'écouteur à enregistrer
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/events/EventDispatcher.html#addEventListener() EventDispatcher.addEventListener()
		 */
		function addWeakEventListener ( eventType : String, listener : Function ) : void;
		/**
		 * Invalide le composant.
		 * <p>
		 * Une fois invalidé, le composant sera redessiné à la fin de la frame, 
		 * au moment de la diffusion de l'évènement <code>Event.EXIT_FRAME</code>
		 * </p>
		 * @param asValidateRoot	<code>true</code> pour que le composant soit la racine de redessin,
		 * 							<code>false</code> pour faire remonter l'invalidation aux parents
		 */
		function invalidate( asValidateRoot : Boolean = false ) : void;
		/**
		 * Renvoie <code>true</code> si le composant est la racine de redessin,
		 * sinon <code>false</code> s'il fait remonté l'invalidation à ses parents.
		 * 
		 * @return <code>true</code> si le composant est la racine de redessin,
		 * 		   sinon <code>false</code> s'il fait remonté l'invalidation à ses parents
		 */
		function isValidateRoot() : Boolean;
		/**
		 * Redessine le composant.
		 */
		function repaint() : void;
	}
}
