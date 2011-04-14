package abe.com.ponents.text 
{
	import abe.com.mon.logs.Log;
	import flash.events.MouseEvent;

	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.core.Component;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="EmptyComponent")]
	public class Label extends AbstractTextComponent 
	{
		protected var _forComponent : Component;
		
		public function Label ( text : String = "Label", forComponent : Component = null )
		{
			super();
			_label.type = TextFieldType.DYNAMIC;
			_label.autoSize = TextFieldAutoSize.LEFT;
			selectable = false;
			
			_forComponent = forComponent;
			
			this.value = text;
		}

		public function get forComponent () : Component { return _forComponent;	}		
		public function set forComponent (forComponent : Component) : void
		{
			_forComponent = forComponent;
		}

		override public function focusIn (e : FocusEvent) : void
		{
			if( _allowFocus )
			{
				if( _forComponent && !e.shiftKey )
				{
					e.stopPropagation();
					StageUtils.stage.focus = _forComponent as InteractiveObject;
					if( _forComponent is AbstractTextComponent )
					  ( _forComponent as AbstractTextComponent ).selectAll();	
				}
				else 
				{
					if( e.shiftKey )
						focusPrevious();
					else
						focusNext();
				}
			}
		}

		override public function click (e : Event = null) : void
		{
			if( _forComponent )
			{
				StageUtils.stage.focus = _forComponent as InteractiveObject;
				if( _forComponent is AbstractTextComponent )
				  ( _forComponent as AbstractTextComponent ).selectAll();	
			}	
		}
		/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
		override public function mouseOver (e : MouseEvent) : void
		{
			if( _label.textWidth > _label.width ||
				_label.textWidth > width )
			{
				_tooltip = _value;
			}
			else
			{
				_tooltip = "";	
			}
			super.mouseOver( e );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		override public function registerValue (e : Event = null) : void {}
	}
}
