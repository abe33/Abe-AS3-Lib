/**
 * @license
 */
package abe.com.ponents.buttons
{
	import abe.com.mands.*;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.StageUtils;
	import abe.com.mon.utils.magicCopy;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.actions.builtin.EditObjectPropertiesAction;
	import abe.com.ponents.builder.models.BuilderCollections;
	import abe.com.ponents.containers.Window;
	import abe.com.ponents.core.*;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.forms.FormComponentDisabledModes;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.managers.SimpleFormManager;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.HBoxLayout;
	import abe.com.ponents.menus.DropDownMenu;
	import abe.com.ponents.menus.MenuItem;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.skinning.decorations.ComponentDecoration;

    import org.osflash.signals.Signal;

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
		
		protected var _dataChanged : Signal;

		/**
		 * Constructeur de la classe <code>ComponentDecorationPicker</code>.
		 */
		public function ComponentDecorationPicker ()
		{
		    _dataChanged = new Signal();
			super();
			buildChildren();
		}
		public function get dataChanged () : Signal { return _dataChanged; }
		/**
		 * Construit les sous composants nécessaires au fonctionnement
		 * du <code>ComponentDecorationPicker</code>.
		 */
		protected function buildChildren () : void
		{
			_editDecoration = new Button( new EditObjectPropertiesAction( null, editObjectCallBack, _("No Object"), null, null, null, true ) );
			_editDecoration.action.commandEnded.add( editCommandEnded );
			_editDecoration.isComponentIndependent = false;
			
			BuilderCollections.commandEnded.add ( collectionsLoaded );
			
			_newDecoration = new DropDownMenu("New", 
											  null, 
											  BuilderCollections.getClassesByType("abe.com.ponents.skinning.decorations::ComponentDecoration").map( 
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
			 addComponent( _editDecoration );
			 addComponent( _newDecoration );
		}
		protected function collectionsLoaded ( c : Component ) : void 
		{
			_newDecoration.popupMenu.menuList.model = new DefaultListModel( 
															BuilderCollections.getClassesByType("abe.com.ponents.skinning.decorations::ComponentDecoration").map( 
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
		protected function editCommandEnded ( c : Command ) : void
		{
			fireDataChangedSignal();
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
			fireDataChangedSignal();
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
		 */
		protected function fireDataChangedSignal () : void
		{
			_dataChanged.dispatch( this, value );
		}
	}
}
