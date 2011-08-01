package abe.com.ponents.nodes.core
{
	import abe.com.patibility.lang._;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.core.edit.EditorFactoryInstance;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.nodes.renderers.nodes.NodeRendererFactoryInstance;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextAreaEditor;
	import abe.com.ponents.utils.ComponentResizer;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	[Skinable(skin="Note")]
	[Skin(define="Note",
		  inherit="DefaultComponent",
		  state__all__background="skin.tooltipBackgroundColor",
		  state__all__foreground="skin.tooltipBorderColor",
		  state__all__textColor="skin.tooltipTextColor")]
	public class CanvasNote extends CanvasNode implements Editable
	{
		protected var resizer : ComponentResizer;

		protected var _allowEdit : Boolean;
		protected var _isEditing : Boolean;
		protected var _editor:Editor;
		
		protected var _titleLabel : Label;
		protected var _contentLabel : Label;

		public var editStarted: Signal;
		public var editCancelled : Signal;
		public var editConfirmed : Signal;
		
		EditorFactoryInstance.register( "Text", new TextAreaEditor() );
		
		public function CanvasNote( note : String )
		{
			editStarted = new Signal();
			editCancelled = new Signal();
			editConfirmed = new Signal();
			
			_allowEdit = true;
			_childrenLayout = new BorderLayout( this );
			
			_titleLabel = new Label(_("<b>Note</b> (ctrl+enter to confirm)"));
			
			
			super(note);
			
			resizer = new ComponentResizer( this );
			
			(_childrenLayout as BorderLayout).north= _titleLabel;
			addComponent( _titleLabel );
		}
		override public function set userObject (userObject : *) : void
		{
			_userObject = userObject;
			
			FEATURES::MENU_CONTEXT {
				this.setContextMenuItemEnabled("properties", _userObject != null );    
			}
			if( _contentLabel && _contentLabel.stage )
				_contentLabel.removeFromParent();
			
			_contentLabel = NodeRendererFactoryInstance.getRenderer(this).render(userObject) as Label;
			
			(_childrenLayout as BorderLayout).center = _contentLabel;
			addComponent( _contentLabel );
		}
		override protected function editObjectProperties ( e : Event = null ) : void 
		{
			if( _userObject )
				startEdit();
		}
		
		public function get editor():Editor { return _editor; }
		public function get isEditing():Boolean { return _isEditing; }
		public function get supportEdit():Boolean { return true; }
		public function get allowEdit():Boolean { return _allowEdit; }
		public function set allowEdit(b:Boolean):void{ _allowEdit = b; }
		
		public function startEdit():void {
			if( _allowEdit )
			{
				_editor = EditorFactoryInstance.get( "Text" );
				_editor.initEditState( this , String(_userObject), _contentLabel );
				
				editStarted.dispatch( this );
				_isEditing = false;
			}
		}
		public function cancelEdit():void {
			_isEditing = false;
			EditorFactoryInstance.release( _editor );
			_editor = null;
			
			editCancelled.dispatch( this ); 
		}
		public function confirmEdit():void {
			_isEditing = false;
			this.userObject = _editor.value;
				
			EditorFactoryInstance.release( _editor );
			_editor = null;
			editConfirmed.dispatch( this );
			
		}
	}
}