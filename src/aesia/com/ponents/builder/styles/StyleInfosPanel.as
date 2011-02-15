package aesia.com.ponents.builder.styles 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Delegate;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.builder.events.StyleSelectionEvent;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.completion.InputMemory;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.containers.WarningDialog;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.DialogEvent;
	import aesia.com.ponents.forms.FormField;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.HBoxLayout;
	import aesia.com.ponents.layouts.components.VBoxLayout;
	import aesia.com.ponents.menus.ComboBox;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class StyleInfosPanel extends Panel 
	{
		[Embed(source="../../skinning/icons/add.png")]
		static private var add : Class;
		[Embed(source="../../skinning/icons/delete.png")]
		static private var remove : Class;
		
		protected var _styleName : Label;
		protected var _styleExtends : Label;
		protected var _styleOwner : Label;
		protected var _styleCustomProperties : ScrollPane;
		protected var _styleCustomPropertiesToolbar : ToolBar;
		protected var _styleNewCustomPropertyName : TextInput;
		protected var _styleNewCustomProperty : Button;
		protected var _styleNewCustomPropertyType : ComboBox;
		protected var _customStylePropertyManager : SimpleFormManager;

		public function StyleInfosPanel (policy : String = "auto")
		{
			style.setForAllStates("insets", new Insets(5));
	
			_styleName = new Label(_$(_("Style Name : <b>$0</b>"),_("No Style")));
			_styleExtends = new Label(_$(_("Style Extends : <b>$0</b>"), _("No Style ")));
			_styleOwner = new Label(_$(_("Style owned by : <b>$0</b>"),_("No Skin")));

			_styleCustomProperties = new ScrollPane();
			//_styleCustomProperties.preferredSize = dm(200,200);

			_styleCustomPropertiesToolbar = new ToolBar(ButtonDisplayModes.ICON_ONLY, false, 3);

			_styleNewCustomPropertyName = new TextInput(0,false,"styleNewCustomPropertyName",false);
			_styleNewCustomProperty = new Button(new ProxyAction( createNewCustomProperty, _("Add new property"), magicIconBuild( add )));
			_styleNewCustomPropertyType = new ComboBox(
														String,
														int,
														uint,
														Boolean,
														Array,
														Number,
														Color,
														//Gradient,
														//Palette,
														Icon );
			_styleNewCustomPropertyType.itemFormatingFunction = Reflection.getClassName;
			_styleCustomPropertiesToolbar.addComponent( _styleNewCustomPropertyName );
			_styleCustomPropertiesToolbar.addComponent( _styleNewCustomPropertyType );
			_styleCustomPropertiesToolbar.addComponent( _styleNewCustomProperty );

			_styleCustomProperties.colHead = _styleCustomPropertiesToolbar;
			_styleCustomPropertiesToolbar.enabled = false;

			childrenLayout = new VBoxLayout( this, 3,
					new BoxSettings(20, "left", "top", _styleName, true, false, false ),
					new BoxSettings(20, "left", "top", _styleExtends, true, false, false ),
					new BoxSettings(20, "left", "top", _styleOwner, true, false, false ),
					new BoxSettings(100, "left", "top", _styleCustomProperties, true, true, true )
			);

			addComponents( _styleName,_styleExtends,_styleOwner,_styleCustomProperties );
		}
		protected function setupRemovePropertyForm (formObject : FormObject) : void
		{
			for each( var f : FormField in formObject.fields )
			{
				if( f && f.component )
				{
					var c : Component = f.component;
					var p : Panel = c.parentContainer as Panel;
					var l : HBoxLayout = p.childrenLayout as HBoxLayout;
					var deleteButton : Button = new Button( new ProxyAction( deleteCustomProperty,
																			 _("Remove this property"),
																			 magicIconBuild( remove ),
																			 null,
																			 null,
																			 f,
																			 formObject ) );
					deleteButton.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
					deleteButton.styleKey = "ToolBar_Button";

					l.boxes.push(new BoxSettings(20, "center", "center", deleteButton, false, false, false ));
					p.addComponent( deleteButton );
				}
			}
		}
		protected function resultDeleteCustomProperty ( e : DialogEvent = null,  f : FormField = null, fo : FormObject = null ) : void
		{
			if( e && e.result != Dialog.RESULTS_YES )
				return;

			fo.fields.splice( fo.fields.indexOf(f), 1 );
			f.component.parentContainer.parentContainer.removeComponent( f.component.parentContainer);
			delete fo.target[ f.memberName ];
		}
		protected function deleteCustomProperty ( f : FormField, fo : FormObject ) : void
		{
			var dial : WarningDialog = new WarningDialog( new Label(_("You're attempting to delete a custom property on this style.\nDeleting a custom property on a style may result\nin runtime error if the deleted property was mandatory\nfor the component which receive the style.\nAre you sure you want to continue ?")) ,
														  Dialog.YES_BUTTON + Dialog.NO_BUTTON,
														  Dialog.YES_BUTTON );
			dial.id = "deleteCustomProperty";
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( SettingsManagerInstance.get( dial, "ignoreWarning") )
			{
				resultDeleteCustomProperty( null, f, fo );
				return;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			dial.addEventListener( DialogEvent.DIALOG_RESULT , Delegate.create( resultDeleteCustomProperty , f, fo ), false, 0, true );
			dial.open( Dialog.CLOSE_ON_RESULT );
		}
		protected function createNewCustomProperty () : void
		{
			var n : String = _styleNewCustomPropertyName.value;
			var t : Class = _styleNewCustomPropertyType.value;

			if( n && n != "" )
			{
				( _styleNewCustomPropertyName.autoComplete as InputMemory ).registerCurrent();
				_styleNewCustomPropertyName.value = "";
			}
		}
		public function styleSelectionChange ( e : StyleSelectionEvent ) : void
		{
			clearStyleCustomPropertiesTools ();
			if( e.style )
			{
				
				_styleName.value = _$(_("Style Name : <b>$0</b>"), e.style.styleName );
				_styleExtends.value = _$(_("Style Extends : <b>$0</b>"), e.style.defaultStyleKey != "" ? e.style.defaultStyleKey : _("Is Root") );
				_styleOwner.value = _$(_("Style owned by : <b>$0</b>"), e.style.skinName ? e.style.skinName : _( "No Owner") );
				
				_styleCustomPropertiesToolbar.enabled = true;

				// generate the form for the custom style properties
				if( e.style.hasCustomProperties() )
				{
					var a : Array = e.style.getCustomPropertiesTable();
					var l : uint = a.length;
					var fields : Array = [];

					for(var i:int=0;i<l;i++)
					{
						fields.push( new FormField( a[i] ,
													a[i],
													FormUtils.getComponentForValue(e.style[a[i]]),
													i,
													Reflection.getClass(e.style[a[i]])));

					}

					var f : FormObject = new FormObject( e.style, fields);
					var p : Component = FieldSetFormRenderer.instance.render( f );
					setupRemovePropertyForm(f);
					_customStylePropertyManager = new SimpleFormManager( f );

					p.style.insets = new Insets(5);
					
					_styleCustomProperties.view = p;
				}
			}
		}
		public function skinSelectionChange ( e : StyleSelectionEvent ) : void
		{
			clearStyleCustomPropertiesTools ();
		}
		protected function clearStyleCustomPropertiesTools () : void
		{
			_styleName.value = _$(_("Style Name : <b>$0</b>"),_("No Style") );
			_styleExtends.value = _$(_("Style Extends : <b>$0</b>"),_("No Style") );
			_styleOwner.value = _$(_("Style owned by : <b>$0</b>"),_("No Skin"));
			
			if( _styleCustomProperties.view )
				_styleCustomProperties.view = null;
			
			_customStylePropertyManager = null;
			_styleCustomPropertiesToolbar.enabled = false;
		}
	}
}
