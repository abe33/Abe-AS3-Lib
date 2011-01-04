/**
 * @license 
 */
package aesia.com.ponents.buttons 
{
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.core.Component;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType aesia.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="LockerButton")]
	[Skin(define="LockerButton",
		  inherit="ToolBar_Button",
		  preview="aesia.com.ponents.buttons::LockerButton.defaultLockerButtonPreview",  
		  custom_checkedIcon="icon(aesia.com.ponents.buttons::LockerButton.CHECKED_ICON)",
		  custom_uncheckedIcon="icon(aesia.com.ponents.buttons::LockerButton.UNCHECKED_ICON)"
	)]
	/**
	 * Le composant <code>LockerButton</code> est une <code>CheckBox</code> donc la
	 * représentation de l'état <code>selected</code> prend la forme d'une chaîne
	 * fermée ou ouverte.
	 * <p>
	 * Cette classe est utilisée par les composants <code>DoubleSpinner</code> et
	 * <code>QuadSpinner</code> afin de vérrouiller les différents <code>Spinner</code>
	 * entre eux.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class LockerButton extends CheckBox 
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Renvoie un objet <code>LockerButton</code> servant de prévisualisation
		 * au style <code>LockerButton</code> dans l'éditeur de styles de composant.
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
		static public function defaultLockerButtonPreview () : Component
		{
			return new LockerButton();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		/**
		 * Icône du composant lorsqu'il est sélectionné.
		 */
		[Embed(source="../skinning/icons/link.png")]
		static public var CHECKED_ICON : Class;
		
		/**
		 * Icône du composant lorsqu'il est désélectionné.
		 */
		[Embed(source="../skinning/icons/link_break.png")]
		static public var UNCHECKED_ICON : Class;
		
		/**
		 * Constructeur de la classe <code>LockerButton</code>.
		 */
		public function LockerButton ()
		{
			super( "" );
		}
		/**
		 * @inheritDoc
		 */
		override public function set selected (b : Boolean) : void 
		{
			super.selected = b;
			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				tooltip = !_selected ? _( "Lock values") : _("Unlock values");
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}
