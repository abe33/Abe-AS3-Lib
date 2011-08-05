package abe.com.ponents.text
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.utils.ToolKit;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	
	public class TextAreaEditor extends TextArea implements Editor
	{
		protected var _caller : Editable;
		
		
		public function TextAreaEditor()
		{
			super();
			
			FEATURES::KEYBOARD_CONTEXT { 
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER, KeyStroke.getModifiers( true ) ) ] = new ProxyCommand( comfirmInput );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ESCAPE ) ] = new ProxyCommand( cancelInput );
			} 
		}
		
		public function get caller():Editable { return _caller; }
		public function set caller(e:Editable):void { _caller = e; }
		
		public function initEditState(caller:Editable, value:*, overlayTarget:DisplayObject=null):void
		{
			_caller = caller;
			this.value = value;
			
			var bb : Rectangle = ( overlayTarget ? overlayTarget : _caller ).getBounds( StageUtils.root );
			
			ToolKit.popupLevel.addChild( this );
			position = bb.topLeft;
			preferredSize = new Dimension( bb.width, bb.height );
			
			_label.setSelection( 0, _label.length );
			
			StageUtils.stage.focus = _label as InteractiveObject;
		}
		public function comfirmInput ( ... args ) : void
		{			
			registerValue();
			//StageUtils.stage.focus = null;
			fireDataChangedSignal();
			_caller.confirmEdit();			
		}
		public function cancelInput () : void
		{
			_caller.cancelEdit();
		}
		override public function focusOut (e : FocusEvent) : void
		{
			_caller.cancelEdit();
		}
	}
}