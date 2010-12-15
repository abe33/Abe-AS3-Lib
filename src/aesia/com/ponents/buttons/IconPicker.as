/**
 * @license
 */
package aesia.com.ponents.buttons
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.actions.builtin.EditObjectPropertiesAction;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.menus.DropDownMenu;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.skinning.icons.EmbeddedBitmapIcon;
	import aesia.com.ponents.skinning.icons.ExternalBitmapIcon;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.SWFIcon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 *
	 * @eventType aesia.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="EmptyComponent")]
	/**
	 * La classe <code>IconPicker</code> permet la création et la modification
	 * d'objets <code>Icon</code>.
	 * <p>
	 * Cette classe est utilisé principalement dans le cadre de l'éditeur de styles
	 * de composant.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 * @see	aesia.com.ponents.skinning.icons.Icon
	 */
	public class IconPicker extends AbstractContainer implements FormComponent
	{
		/**
		 * Une référence vers le bouton chargé de déclencher l'édition
		 * de l'icône courant pour ce composant.
		 */
		protected var _editIcon : Button;
		/**
		 * Une référence vers le menu chargé de créer un nouvel
		 * icône pour ce composant.
		 */
		protected var _newIcon : DropDownMenu;
		/**
		 * Une référence vers l'objet <code>Icon</code>
		 * de cet <code>IconPicker</code>.
		 */
		protected var _value : Icon;
		/**
		 * Un entier représentant le mode de désactivation courant de ce composant.
		 */
		protected var _disabledMode : uint;
		/**
		 * La valeur de ce composant durant son mode de désactivation.
		 */
		protected var _disabledValue : *;

		/**
		 * Constructeur de la classe <code>IconPicker</code>.
		 *
		 * @param	ico	un objet <code>Icon</code> à éditer
		 */
		public function IconPicker ( ico : Icon = null )
		{
			super();
			buildChildren();
			value = ico;
		}
		/**
		 * Une référence vers l'objet <code>Icon</code>
		 * de cet <code>IconPicker</code>.
		 */
		public function get value () : * { return _value; }
		public function set value (v : *) : void
		{
			if( v is Icon )
				_value = v;
			else
				_value = magicIconBuild( v );

			( _editIcon.action as EditObjectPropertiesAction).object = _value;
			( _editIcon.action as EditObjectPropertiesAction).icon = _value;
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
		 * Construit les sous composants nécessaires au fonctionnement
		 * du <code>IconPicker</code>.
		 */
		protected function buildChildren () : void
		{
			_editIcon = new Button(new EditObjectPropertiesAction( null, null, "") );
			_editIcon.action.addEventListener(CommandEvent.COMMAND_END, editCommandEnd );
			_editIcon.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_editIcon.isComponentIndependent = false;

			_newIcon = new DropDownMenu("New", null,
												getMenuItem(ExternalBitmapIcon),
												getMenuItem(EmbeddedBitmapIcon),
												getMenuItem(SWFIcon)/*,
												getMenuItem(CheckBoxUncheckedIcon),
												getMenuItem(CheckBoxCheckedIcon),
												getMenuItem(RadioCheckedIcon),
												getMenuItem(RadioUncheckedIcon),
												getMenuItem(DOIcon),												getMenuItem(DOInstanceIcon),												getMenuItem(FontIcon),												getMenuItem(BitmapIcon)*/ );
			_newIcon.isComponentIndependent = false;

			var l : HBoxLayout = new HBoxLayout(this, 3,
					new BoxSettings(100, "left", "center", _editIcon, true, true, true ),
					new BoxSettings(50, "left", "left", _newIcon, true, true, false )
			 );
			childrenLayout = l;
			addComponent( _editIcon );
			addComponent( _newIcon );
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
			return new MenuItem( new ProxyAction( createNewIcon, Reflection.extractClassName( cl ), null, null, null, cl ) );
		}
		/**
		 * Créer un nouvel objet <code>Icon</code> comme valeur
		 * cette instance.
		 *
		 * @param	cl	classe à instancier
		 */
		protected function createNewIcon( cl : Class ) : void
		{
			value = new cl();
			fireDataChange();
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
		 * Définie l'état du composant lorsque celuici est désactivé.
		 */
		protected function checkDisableMode() : void
		{
			switch( _disabledMode )
			{
				case FormComponentDisabledModes.DIFFERENT_ACROSS_MANY :
					disabledValue = _("different values across many");
					( _editIcon.action as EditObjectPropertiesAction).name = _disabledValue;
					break;

				case FormComponentDisabledModes.UNDEFINED :
					disabledValue = _("not defined");
					( _editIcon.action as EditObjectPropertiesAction).name = _disabledValue;
					break;

				case FormComponentDisabledModes.NORMAL :
				case FormComponentDisabledModes.INHERITED :
				default :
					( _editIcon.action as EditObjectPropertiesAction).object = _value;
					( _editIcon.action as EditObjectPropertiesAction).icon = _value;
					break;
			}
		}
		/**
		 * Recoit l'évènement <code>CommandEvent.COMMAND_END</code> de fin
		 * d'édition des propriétés de l'objet <code>Icon</code>
		 * courant.
		 *
		 * @param	event	évènement de fin d'édition
		 */
		protected function editCommandEnd (event : CommandEvent) : void
		{
			( _editIcon.action as EditObjectPropertiesAction).icon = _value;
			invalidatePreferredSizeCache();
			fireDataChange();
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
