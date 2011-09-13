/**
 * @license
 */
package abe.com.ponents.actions 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.ponents.skinning.icons.Icon;
	/**
	 * La classe <code>ProxyAction</code> permet de créer des actions correspondant
	 * à de simple appel de fonctions.
	 * 
	 * @author Cédric Néhémie
	 */
	public class ProxyAction extends AbstractAction 
	{
		/**
		 * Référence vers la fonction à appeler.
		 */
		protected var _function : Function;
		/**
		 * Un tableau d'arguments à transmettre à la fonction lors de l'appel.
		 */
		protected var _arguments : Array;
		
		/**
		 * Constructeur de la classe <code>ProxyAction</code>.
		 * 
		 * @param func				référence vers la fonction à appeler
		 * @param name				chaîne utilisée pour nommer l'action
		 * @param icon				icône de l'action
		 * @param longDescription	description de l'action
		 * @param accelerator		raccourci de l'action
		 * @param args				suite d'arguments à transmettre à la fonction
		 */
		public function ProxyAction ( func : Function, 
									  name : String = "", 
									  icon : Icon = null, 
									  longDescription : String = null, 
									  accelerator : KeyStroke = null, 
									  ... args )
		{
			super( name, icon, longDescription, accelerator );
			_function = func;
			_arguments = args;
		}
		/**
		 * @inheritDoc
		 */
		override public function execute( ... args ) : void
		{
			_function.apply( null, _arguments );
			commandEnded.dispatch( this );
		}
	}
}
