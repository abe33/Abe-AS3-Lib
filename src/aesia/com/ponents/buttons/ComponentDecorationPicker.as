/**
 * @license
 */
package aesia.com.ponents.buttons
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.magicCopy;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.actions.builtin.EditObjectPropertiesAction;
	import aesia.com.ponents.builder.models.BuilderCollections;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.menus.DropDownMenu;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.ponents.skinning.decorations.ComponentDecoration;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 *
	 * @eventType aesia.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]

	[Skinable(skin="EmptyComponent")]
	/**
	 * La classe <code>ComponentDecorationPicker</code> permet la création et la modification
	 * d'objets <code>ComponentDecoration</code>.
	 * <p>
	 * La classe <code>ComponentDecorationPicker</code> est utilisé exclusivement dans
	 * le cadre de l'éditeur de styles de composant.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public class ComponentDecorationPicker extends AbstractContainer implements FormComponent
	{
		/**
		 * Une référence vers le bouton chargé de déclencher l'édition
		 * de la décoration courante pour ce composant.
		 */
		protected var _editDecoration : Button;
		/**
		 * Une référence vers le menu chargé de créer une nouvelle
		 * décoration pour ce composant.
		 */
		protected var _newDecoration : DropDownMenu;
		/**
		 * Une référence vers l'objet <code>ComponentDecoration</code>
		 * de ce <code>ComponentDecorationPicker</code>.
		 */
		protected var _value : ComponentDecoration;
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
		 */
		protected var _disabledMode : uint;
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		protected var _disabledValue : *;

		/**
		 * Constructeur de la classe <code>ComponentDecorationPicker</code>.
		 */
		public function ComponentDecorationPicker ()
		{
			super();
			buildChildren();
		}
		/**
		 * Construit les sous composants nécessaires au fonctionnement
		 * du <code>ComponentDecorationPicker</code>.
		 */
		protected function buildChildren () : void
		{
			_editDecoration = new Button( new EditObjectPropertiesAction( null, editObjectCallBack, _("No Object"), null, null, null, true ) );
			_editDecoration.action.addEventListener(CommandEvent.COMMAND_END, editCommandEnd);
			_editDecoration.isComponentIndependent = false;
			
			BuilderCollections.addEventListener(CommandEvent.COMMAND_END, collectionsLoaded );
			
			_newDecoration = new DropDownMenu("New", 
											  null, 
											  BuilderCollections.getClassesByType("decorations").map( 
											  	function( c : Class, ... args ) : MenuItem 
											  	{ 
											  		return getMenuItem( c ); 
											  	} ) );
			
			_newDecoration.isComponentIndependent = false;

			var l : HBoxLayout = new HBoxLayout(this, 3,
					new BoxSettings(100, "left", "center", _editDecoration, true, true, true ),
					new BoxSettings(50, "left", "left", _newDecoration, true, true, false )
			 );
			childrenLayout = l;
			 addComponent( _editDecoration );			 addComponent( _newDecoration );
		}
		protected function collectionsLoaded (event : CommandEvent) : void 
		{
			_newDecoration.popupMenu.menuList.model = new DefaultListModel( 
															BuilderCollections.getClassesByType("decorations").map( 
																function( c : Class, ... args ) : MenuItem { return getMenuItem( c ); } ) );
		}
		
		protected function editObjectCallBack (    o : Object, 
												   form : FormObject, 
												   manager : SimpleFormManager,
												   window : Window ) : void 
		{
			manager.save();
			magicCopy( form.target, o );
			window.close();
			StageUtils.stage.focus = null;
		}
		/**
		 * Une référence vers l'objet <code>ComponentDecoration</code>
		 * de ce <code>ComponentDecorationPicker</code>.
		 */
		public function get value () : * { return _value; }
		public function set value (v : *) : void
		{
			_value = v as ComponentDecoration;
			( _editDecoration.action as EditObjectPropertiesAction).object = _value;
			( _editDecoration.action as EditObjectPropertiesAction).name = Reflection.getClassName( _value );
		}
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
		 */
		public function get disabledMode () : uint { return _disabledMode; }
		public function set disabledMode (b : uint) : void
		{
			_disabledMode = b;
			if( !_enabled )
				checkDisableMode();
		}
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		public function get disabledValue () : * { return _disabledValue; }
		public function set disabledValue (v : *) : void
		{
			_disabledValue = v;

		}
		/**
		 * @inheritDoc
		 */
		override public function set enabled (b : Boolean) : void
		{
			super.enabled = b;
			checkDisableMode();
		}
		/**
		 * Recoit l'évènement <code>CommandEvent.COMMAND_END</code> de fin
		 * d'édition des propriétés de l'objet <code>ComponentDecoration</code>
		 * courant.
		 *
		 * @param	event	évènement de fin d'édition
		 */
		protected function editCommandEnd (event : CommandEvent) : void
		{
			fireDataChange();
		}
		/**
		 * Renvoie un objet <code>MenuItem</code> chargé de construire un objet
		 * de type <code>cl</code> lorsque celui-ci est éxécuter.
		 *
		 * @param	cl	classe à créer lors de l'éxécution du menu
		 * @return	un objet <code>MenuItem</code>
		 */
		protected function getMenuItem ( cl : Class ) : MenuItem
		{
			return new MenuItem( new ProxyAction( createNewDecoration, Reflection.getClassName( cl ), null, null, null, cl ) );
		}
		/**
		 * Créer un nouvel objet <code>ComponentDecoration</code> comme valeur
		 * cette instance.
		 *
		 * @param	cl	classe à instancier
		 */
		protected function createNewDecoration( cl : Class ) : void
		{
			value = new cl();
			fireDataChange();
		}
		/**
		 * Définie l'état du composant lorsque celuici est désactivé.
		 */
		protected function checkDisableMode() : void
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY :
					disabledValue = _("different values across many");
					( _editDecoration.action as EditObjectPropertiesAction).name = _disabledValue;
					break;

				case FormComponentDisabledModes.UNDEFINED :
					disabledValue = _("not defined");
					( _editDecoration.action as EditObjectPropertiesAction).name = _disabledValue;
					break;

				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED :
				default :
					( _editDecoration.action as EditObjectPropertiesAction).name = Reflection.getClassName( _value );
					break;
			}
		}
		/**
		 * Diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code> aux écouteurs
		 * de ce composant.
		 */
		protected function fireDataChange () : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}
