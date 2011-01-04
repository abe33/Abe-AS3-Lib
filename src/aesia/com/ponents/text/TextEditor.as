package aesia.com.ponents.text 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.completion.InputMemory;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.edit.Editor;
	import aesia.com.ponents.utils.ToolKit;

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
		  
		  state__all_foreground="new deco::SimpleBorders( skin.selectedBorderColor )"
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
		override public function comfirmInput ( e : Event = null ) : void
		{			
			/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
			if( _autoCompleteDropDown && _autoCompleteDropDown.displayed )
			{
				_autoCompleteDropDown.validateCompletion();
				return;
			}
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
				if( _autoComplete is InputMemory )
				  ( _autoComplete as InputMemory ).registerCurrent();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			registerValue();
			//StageUtils.stage.focus = null;
			fireDataChange();
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
		/*FDT_IGNORE*/ FEATURES::AUTOCOMPLETION { /*FDT_IGNORE*/
		override protected function keyUp (event : KeyboardEvent) : void
		{
			super.keyUp( event );
			invalidatePreferredSizeCache();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
