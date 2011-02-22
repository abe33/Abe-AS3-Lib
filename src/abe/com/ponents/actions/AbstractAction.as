/**
 * @license
 */
package abe.com.ponents.actions 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.utils.KeyboardControllerInstance;

	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé lorsqu'une propriété de l'action est modifiée.
	 * 
	 * <p>Les propriétés suivantes sont à l'origine de la diffusion de l'évènement
	 * <code>propertyChange</code></p>
	 * <ul>
	 * <li>name</li>			
	 * <li>icon</li>
	 * <li>longDescription</li>
	 * <li>accelerator</li>
	 * <li>actionEnabled</li>
	 * </ul>
	 * 
	 * @eventType abe.com.ponents.events.PropertyEvent.PROPERTY_CHANGE
	 */
	[Event(name="propertyChange", type="abe.com.ponents.events.PropertyEvent")]
	/**
	 * La classe <code>AbstractAction</code> sert de classe de base aux actions concrètes
	 * que vous voulez créer dans votre programme.
	 * <p>
	 * La classe <code>AbstractAction</code> fournie l'implémentation standard des éléments
	 * nécessaires définis dans l'interface <code>Action</code>. Il suffit généralement d'étendre
	 * cette classe et de redéfinir la méthode <code>execute</code> pour créer une action concrète.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractAction extends AbstractCommand implements Action, Command, Runnable, IEventDispatcher
	{
		/**
		 * Une chaîne de caractère utilisé comme texte d'affichage pour cette
		 * action.
		 */
		protected var _name : String;
		/**
		 * Une référence vers un objet <code>Icon</code> représentant cette action.
		 */
		protected var _icon : Icon;
		/**
		 * Une chaîne de caractère servant de description à l'action.
		 */
		protected var _longDescription : String;
		/**
		 * Une référence vers un objet <code>KeyStroke</code> représentant
		 * la combinaison de touches à réaliser afin de déclencher cette action.
		 */
		protected var _accelerator : KeyStroke;
		/**
		 * Une valeur booléenne indiquant si cette action est actuellement active
		 * et utilisable par les composants l'aggrégeant.
		 */
		protected var _actionEnabled : Boolean; 
		
		/**
		 * Constructeur de la classe <code>AbstractAction</code>.
		 * 
		 * @param	name			nom de l'action
		 * @param	icon			icône de l'action
		 * @param	longDescription	description de l'action
		 * @param	accelerator		raccourcis clavier global pour cette action
		 */
		public function AbstractAction ( name : String = "", 
										 icon : Icon = null, 
										 longDescription : String = null, 
										 accelerator : KeyStroke = null )
		{
			this.name = name;
			this.icon = icon;
			this.longDescription = longDescription;	
			this.accelerator = accelerator;
			_actionEnabled = true;
			super();
		}
		/**
		 * @inheritDoc
		 */
		public function get icon () : Icon { return _icon; }
		public function set icon ( icon : Icon) : void
		{
			_icon = icon;
			firePropertyEvent( "icon", _icon );
		}
		/**
		 * @inheritDoc
		 */
		public function get name () : String { return _name; }
		public function set name (name : String) : void
		{
			_name = name;
			firePropertyEvent( "name", name );
		}
		/**
		 * @inheritDoc
		 */
		public function get longDescription () : String { return _longDescription; }
		public function set longDescription (longDescription : String) : void
		{
			_longDescription = longDescription;
			firePropertyEvent( "longDescription", longDescription );
		}
		/**
		 * @inheritDoc
		 */
		public function get accelerator () : KeyStroke { return _accelerator; }
		public function set accelerator (accelerator : KeyStroke) : void
		{
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/				if( _accelerator )
					KeyboardControllerInstance.removeGlobalKeyStroke( _accelerator );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_accelerator = accelerator;
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				if( _accelerator )
					KeyboardControllerInstance.addGlobalKeyStroke( _accelerator, this );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			firePropertyEvent( "accelerator", accelerator );
		}
		/**
		 * @inheritDoc
		 */
		public function get actionEnabled () : Boolean { return _actionEnabled; }	
		public function set actionEnabled (actionEnabled : Boolean) : void
		{
			_actionEnabled = actionEnabled;
			firePropertyEvent( "actionEnabled", actionEnabled );
		}
		/**
		 * @inheritDoc
		 */
		public function get component () : Component { return new Button(this); }
		/**
		 * Diffuse un évènement de type <code>PropertyEvent.PROPERTY_CHANGE</code> pour ce composant.
		 * 
		 * @param	pname	nom de la propriété provoquant la diffusion de l'évènement
		 * @param	pvalue	nouvelle valeur de cette propriété
		 */
		public function firePropertyEvent ( pname : String, pvalue : * ) : void
		{
			dispatchEvent( new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, pname, pvalue) );
		}
	}
}
