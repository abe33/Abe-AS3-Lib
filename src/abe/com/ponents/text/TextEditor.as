package abe.com.ponents.text 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.completion.InputMemory;
    import abe.com.ponents.core.edit.Editable;
    import abe.com.ponents.core.edit.Editor;
    import abe.com.ponents.utils.ToolKit;

    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="TextEditor")]
	[Skin(define="TextEditor",
		  inherit="Text",
		  
		  state__all_foreground="skin.selectedBorderColor"
	)]
	public class TextEditor extends TextInput implements Editor
	{
		protected var _caller : Editable;
		
		protected var _minWidth : Number; 
		
		public function TextEditor ()
		{		
			super();
			//_label.autoSize = "left";	
			_label.addEventListener( Event.CHANGE, textChange );
		}

		public function initEditState ( caller : Editable, value : *, overlayTarget : DisplayObject = null ) : void
		{
			this.caller = caller;
			this.value = value;
			
			var bb : Rectangle = ( overlayTarget ? overlayTarget : _caller ).getBounds( StageUtils.root );
			
			ToolKit.popupLevel.addChild( this );
			position = bb.topLeft;
			_minWidth = bb.width;
			_preferredSizeCache = new Dimension( bb.width, bb.height );
			
			_label.setSelection( 0, _label.length );
			
			StageUtils.stage.focus = _label as InteractiveObject;
		}
		
		
		public function get caller () : Editable { return _caller; }		
		public function set caller (e : Editable) : void
		{
			_caller = e;
		}
		override public function comfirmInput ( ... args ) : void
		{			
			FEATURES::AUTOCOMPLETION { 
			    if( _autoCompleteDropDown && _autoCompleteDropDown.displayed )
			    {
				    _autoCompleteDropDown.validateCompletion();
				    return;
			    }
			    FEATURES::SETTINGS_MEMORY { 
				    if( _autoComplete is InputMemory )
				      ( _autoComplete as InputMemory ).registerCurrent();
			    } 
			} 
				
			registerValue();
			//StageUtils.stage.focus = null;
			fireDataChangedSignal();
			_caller.confirmEdit();			
		}
		override public function cancelInput () : void
		{
			_caller.cancelEdit();
		}
		override public function focusOut (e : FocusEvent) : void
		{
			_caller.cancelEdit();
		}
		override public function keyFocusChange (e : FocusEvent) : void
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			
			if( e.shiftKey )
				_caller.focusPrevious();
			else
				_caller.focusNext();
		}
		protected function textChange (event : Event) : void 
		{
			_preferredSizeCache = new Dimension( Math.max( _minWidth, _label.textWidth + 4 + _style.insets.horizontal ), _preferredSizeCache.height );
			invalidate(true);
		}
		FEATURES::AUTOCOMPLETION
		override protected function keyUp (event : KeyboardEvent) : void
		{
			super.keyUp( event );
			invalidatePreferredSizeCache();
		}
	}
}
