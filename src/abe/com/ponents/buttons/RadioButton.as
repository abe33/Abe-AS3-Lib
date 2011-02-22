/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.RadioCheckedIcon;
	import abe.com.ponents.skinning.icons.RadioUncheckedIcon;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	[Skinable(skin="Radio")]
	[Skin(define="Radio",
		  inherit="CheckBox",
		  preview="abe.com.ponents.buttons::RadioButton.defaultRadioButtonPreview",
		  custom_checkedIcon="icon(abe.com.ponents.skinning.icons::RadioCheckedIcon)",
		  custom_uncheckedIcon="icon(abe.com.ponents.skinning.icons::RadioUncheckedIcon)"
	)]
	/**
	 * Un composant <code>RadioButton</code> est une <code>CheckBox</code> dont l'état
	 * de sélection ne peut plus réversible une fois que l'on a cliqué dessus.
	 * <p>
	 * Les <code>RadioButton</code> sont généralement utilisé conjoitement avec un objet
	 * <code>ButtonGroup</code> afin d'offrir une liste de choix obligatoire.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class RadioButton extends CheckBox  implements IDisplayObject, 
														  IInteractiveObject, 
														  IDisplayObjectContainer, 
														  Component, 
														  Focusable,
												 		  LayeredSprite,
												 		  IEventDispatcher
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Renvoie un objet <code>RadioButton</code> servant de prévisualisation
		 * au style <code>RadioButton</code> dans l'éditeur de styles de composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#BUILDER">FEATURES::BUILDER</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * @see ../../../../Conditional-Compilation.html#BUILDER Constante FEATURES::BUILDER
		 * @return	un objet <code>Button</code> servant de prévisualisation au style <code>Button</code>
		 * 			dans l'éditeur de styles de composant
		 */
		static public function defaultRadioButtonPreview () : Component
		{
			return new RadioButton();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		/*
		 * Utilisé pour forcer la compilation des dépendances du skin de ce composant.
		 */
		static private const DEPENDENCIES : Array = [ RadioCheckedIcon, RadioUncheckedIcon ];
		
		/**
		 * Constructeur de classe <code>RadioButton</code>.
		 * <p>
		 * Si le premier paramètre transmi au constructeur est un objet <code>Action</code>
		 * le label et l'icône de ce bouton seront déterminé à l'aide des données contenues
		 * dans l'objet <code>Action</code>. Auquel cas le second paramètre sera tout simplement
		 * ignoré.
		 * </p>
		 * <p>Si le premier paramètre transmi est une <code>String</code>, celle-ci sera utilisé
		 * comme valeur pour le label de ce bouton, et le second paramètre ne sera pas ignoré.
		 * </p>
		 * 
		 * @param	actionOrLabel	un objet <code>Action</code> ou une chaîne de caractère
		 * @param	icon			un objet <code>Icon</code>
		 */
		public function RadioButton (actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
		}
		/**
		 * @inheritDoc
		 */
		override public function click (e : Event = null) : void
		{
			swapSelect(true);
		}
	}
}