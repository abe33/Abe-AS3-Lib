package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.magicClone;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.Window;
	import aesia.com.ponents.containers.WindowTitleBar;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.WindowEvent;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.lists.CustomEditCell;
	import aesia.com.ponents.lists.ListEditor;
	import aesia.com.ponents.skinning.decorations.SimpleFill;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.utils.Insets;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class EditObjectPropertiesAction extends AbstractAction 
	{
		static protected var _window : Window;
		
		protected var _object : Object;
		protected var _formObject : FormObject;
		protected var _formManager : SimpleFormManager;		protected var _currentClass : Class;
		protected var _saveFunction : Function;
		protected var _workOnCopy : Boolean;

		public function EditObjectPropertiesAction ( object : Object, 
													 saveFunction : Function = null,
													 name : String = "", 
													 icon : Icon = null, 
													 longDescription : String = null, 
													 accelerator : KeyStroke = null,
													 workOnCopy : Boolean = false
													)
		{
			super( name, icon, longDescription, accelerator );
			_object = object;
			_saveFunction = saveFunction;
			_workOnCopy = workOnCopy;
		}
		public function get object () : Object { return _object; }		
		public function set object (object : Object) : void
		{
			_object = object;
		}

		override public function execute (e : Event = null) : void
		{
			if( _object is FormMetaProvider )
			{
				_formObject = FormUtils.createFormFromMetas( _object );
				_formObject.target =  _workOnCopy ? magicClone( _object ) : _object;
			}
			else if( _object is Array )
			{
				var a : Array = _workOnCopy ? magicClone( _object ) : _object as Array;
				var l : uint = a.length;
				var hasSameTypeAccrossArray : Boolean = false;
				var sp : ScrollPane;
				var ppp : Panel;
				
				if( l > 0 )
				{
					_currentClass = Reflection.getClass(a[0]);
					hasSameTypeAccrossArray = a.every(compareClass);
					_currentClass = null;
				}	
			
				var li : ListEditor = new ListEditor( _object as Array, 
														hasSameTypeAccrossArray ? FormUtils.getComponentForType(
																						FormUtils.getClassicNewInstance( _currentClass ) ) : null, 
														hasSameTypeAccrossArray ? _currentClass : null );
				li.list.listCellClass = CustomEditCell;
				
				sp = new ScrollPane();
				sp.view = li;
				if( !_window )
				{
					_window = new Window();
					_window.resizable = true;
					_window.windowTitle = new WindowTitleBar(_("Properties"),null,WindowTitleBar.CLOSE_BUTTON + WindowTitleBar.MAXIMIZE_BUTTON );
					_window.addEventListener( WindowEvent.CLOSE, onClose );
				}
				if( _saveFunction == null )
				{
					if( _window.windowStatus != null )
						_window.windowStatus = null;
				}
				else
				{
					ppp = new Panel();
					ppp.style.setForAllStates("insets", new Insets(5));
					ppp.childrenLayout = new InlineLayout(ppp, 3, "right", "center", "leftToRight");
					ppp.addComponent( new Button(new ProxyAction( _saveFunction, _("Save"), null, null, null, _object, _formObject, _formManager, _window ) ) );
					_window.windowStatus = ppp;
				}
				
				_window.windowContent = sp; 
				if( _window.width > StageUtils.stage.stageWidth*.6 || _window.height > StageUtils.stage.stageHeight * .6 )
					_window.preferredSize = dm(StageUtils.stage.stageWidth * .6, StageUtils.stage.stageHeight * .6 );
				
				StageUtils.centerY(_window);				StageUtils.centerX(_window);
				
				_window.open();
				//_dialog = new Dialog( _("Properties"), Dialog.CLOSE_BUTTON, li );
				//_dialog.addEventListener( WindowEvent.CLOSE, onClose );
				//_dialog.open();
				
				return;
			}
			else
			{
				_formObject = FormUtils.createFormForPublicMembers( _object );
				_formObject.target = _workOnCopy ? magicClone( _object ) : _object;
			}
			
			_formManager = new SimpleFormManager( _formObject );
			var p : Component = FieldSetFormRenderer.instance.render( _formObject );
			p.style.setForAllStates("insets", new Insets(10)).setForAllStates("background", new SimpleFill( Color.LightGrey ) );
			
			sp = new ScrollPane();
			sp.view = p;
			if( !_window )
			{
				_window = new Window();
				_window.resizable = true;
				_window.windowTitle = new WindowTitleBar(_("Properties"),null,WindowTitleBar.CLOSE_BUTTON + WindowTitleBar.MAXIMIZE_BUTTON );
				_window.addEventListener( WindowEvent.CLOSE, onClose );
			}
			if( _saveFunction == null )
			{
				if( _window.windowStatus != null )
					_window.windowStatus = null;
			}
			else
			{
				ppp = new Panel();
				ppp.style.setForAllStates("insets", new Insets(5));
				ppp.childrenLayout = new InlineLayout(ppp, 3, "right", "center", "leftToRight");
				ppp.addComponent( new Button(new ProxyAction( _saveFunction, _("Save"), null, null, null, _object, _formObject, _formManager, _window ) ) );
				_window.windowStatus = ppp;
			}
			
			_window.windowContent = sp; 
			if( _window.width > StageUtils.stage.stageWidth*.6 || _window.height > StageUtils.stage.stageHeight * .6 )
				_window.preferredSize = dm(StageUtils.stage.stageWidth * .6, StageUtils.stage.stageHeight * .6 );
				
			StageUtils.centerX(_window);
			StageUtils.centerY(_window);
			_window.open();
			/*
			_dialog = new Dialog(_("Properties"), Dialog.CLOSE_BUTTON, p );
			_dialog.addEventListener( WindowEvent.CLOSE, onClose );
			_dialog.open();*/
		}
		
		protected function compareClass ( i : *, ... args) : Boolean { return i is _currentClass; }

		protected function onClose (event : WindowEvent) : void
		{
			//_dialog.removeEventListener( WindowEvent.CLOSE, onClose );			if( _formManager )
			{
				_formManager.updateTargetWithFields();
				_formManager.dispose();
				_formManager = null;
				
				_formObject = null;
			}
			_window.windowContent = null;
			/*
			_dialog.windowContent = null;
			_dialog = null;
			*/
			fireCommandEnd();
		}
	}
}
