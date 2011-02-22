/**
 * @license 
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.utils.Color;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	/**
	 * La classe <code>HexaColorPicker</code> est utilisé afin d'éditer des couleurs
	 * sous la forme d'entiers héxadécimaux.
	 * 
	 * @author Cédric Néhémie
	 */
	public class HexaColorPicker extends ColorPicker 
	{
		/**
		 * Constructeur de la classe <code>HexaColorPicker</code>.
		 * <p>
		 * Cette classe est utilisée en particulier dans le cadre 
		 * de l'édition des filtres, afin de permettre de modifier
		 * les propriétés de couleurs des différents filtres.
		 * </p>
		 * @param	color	la couleur à éditer sous la forme d'un entier
		 * 					héxadécimal
		 */
		public function HexaColorPicker ( color : uint = 0xffffff )
		{
			super( new Color( 0xff000000 + color ) );
		}
		/**
		 * Un entier non signé représentant la couleur sous une forme héxadécimale.
		 */
		override public function get value () : * {	return super.value.hexa; }
		override public function set value (value : *) : void
		{
			super.value = new Color( 0xff000000 + value );
		}
		
	}
}
