package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.WindowEvent;
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.forms.managers.SimpleFormManager;
	import aesia.com.ponents.forms.renderers.FieldSetFormRenderer;
	import aesia.com.ponents.lists.CustomEditCell;
	import aesia.com.ponents.lists.ListEditor;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.Event;

	/**
	 * @author cedric
	 */
	public class EditObjectPropertiesAction extends AbstractAction 
	{
		protected var _object : Object;
		protected var _formObject : FormObject;
		protected var _formManager : SimpleFormManager;
		protected var _dialog : Dialog;
		protected var _currentClass : Class;

		public function EditObjectPropertiesAction ( object : Object, 
													 name : String = "", 
													 icon : Icon = null, 
													 longDescription : String = null, 
													 accelerator : KeyStroke = null
													 )
		{
			super( name, icon, longDescription, accelerator );
			_object = object;
		}
		
		public function get object () : Object { return _object; }		
		public function set object (object : Object) : void
		{
			_object = object;
		}

		override public function execute (e : Event = null) : void
		{
			
			if( _object is FormMetaProvider )
				_formObject = FormUtils.createFormFromMetas( _object );
				
			else if( _object is Array )
			{
				var a : Array = _object as Array;
				var l : uint = a.length;
				var hasSameTypeAccrossArray : Boolean = false;
				
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
				
				_dialog = new Dialog(_("Properties"), Dialog.CLOSE_BUTTON, li );
				_dialog.addEventListener( WindowEvent.CLOSE, onClose );
				_dialog.open();
				
				return;
			}
			else
				_formObject = FormUtils.createFormForPublicMembers( _object );
			
			_formManager = new SimpleFormManager( _formObject );
			var p : Component = FieldSetFormRenderer.instance.render( _formObject );
				
			_dialog = new Dialog(_("Properties"), Dialog.CLOSE_BUTTON, p );
			_dialog.addEventListener( WindowEvent.CLOSE, onClose );
			_dialog.open();
		}
		
		protected function compareClass ( i : *, ... args) : Boolean { return i is _currentClass; }

		protected function onClose (event : WindowEvent) : void
		{
			_dialog.removeEventListener( WindowEvent.CLOSE, onClose );
			
			if( _formManager )
			{
				_formManager.updateTargetWithFields();
				_formManager.dispose();
				_formManager = null;
				
				_formObject = null;
			}
			_dialog.windowContent = null;
			_dialog = null;
			fireCommandEnd();
		}
	}
}
