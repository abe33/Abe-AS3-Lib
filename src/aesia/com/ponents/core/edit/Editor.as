/**
 * @license
 */
package aesia.com.ponents.core.edit 
{
	import flash.display.DisplayObject;

	/**
	 * Un objet <code>Editor</code> est un objet utilisable par un composant 
	 * <code>Editable</code> afin de permettre à l'utilisateur de modifier
	 * son contenu.
	 * <p>
	 * Il n'est pas nécessaire qu'une classe implémentant l'interface <code>Editor</code>
	 * implémente aussi l'interface <code>Component</code> (voir par exemple la classe
	 * <a href="ObjectPropertiesEditor.html"><code>ObjectPropertiesEditor</code></a>).
	 * Cependant, certains composants standards du set de composants, tel les composants
	 * <code>Spinner</code> ou <code>ComboBox</code> implémentent l'interface <code>Editor</code>,
	 * leur permettant ainsi d'être utilisé directement en tant qu'objet <code>Editor</code>
	 * pour n'importe quel objet <code>Editable</code>.
	 * </p>
	 * @author Cédric Néhémie
	 * @see	ObjectPropertiesEditor
	 */
	public interface Editor
	{
		/**
		 * Une référence vers l'objet <code>Editable</code> ayant initié
		 * la séquence d'édition dont est chargé cet objet <code>Editor</code>.
		 * <p>
		 * Si l'objet <code>Editor</code> n'est actuellement pas en charge d'une
		 * séquence d'édition, cette propriété est à <code>null</code>.
		 * </p>
		 */
		function get caller() : Editable;
		function set caller( e : Editable ) : void;
		/**
		 * Une référence vers la valeur en cours d'édition.
		 */
		function get value() : *;
		function set value( v : * ) : void;
		/**
		 * Initie l'état d'édition pour cet objet <code>Editor</code>.
		 * 
		 * @param	caller			l'objet <code>Editable</code> initiant 
		 * 							cette séquence d'édition
		 * @param	value			la valeur à éditer. En règle général, 
		 * 							il est préferable de transmettre une copie
		 * 							de la valeur actuellement contenue dans l'objet
		 * 							<code>Editable</code> afin de permettre une
		 * 							annulation de la séquence d'édition.
		 * @param	overlayTarget	un <code>DisplayObject</code> permettant à une 
		 * 							implémentation de l'interface <code>Editor</code>
		 * 							de construire un élement graphique se superposant
		 * 							à ce <code>DisplayObject</code>
		 */
		function initEditState( caller : Editable, value : *, overlayTarget : DisplayObject = null ) : void;
	}
}
