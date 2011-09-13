/**
 * @license
 */
package abe.com.ponents.tips 
{
    import abe.com.ponents.buttons.AbstractButton;
    import abe.com.ponents.skinning.DefaultSkin;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.utils.ToolKit;

    import flash.display.DisplayObject;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    import flash.text.TextFieldAutoSize;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="ToolTip")]
	[Skin(define="ToolTip",
			  inherit="DefaultComponent",
			  state__all__background="skin.tooltipBackgroundColor",			  state__all__foreground="skin.tooltipBorderColor",
			  state__all__textColor="skin.tooltipTextColor",
			  state__all__outerFilters="abe.com.ponents.tips::ToolTip.createToolTipFilters()"
	)]
	public class ToolTip extends AbstractButton
	{
		static public function createToolTipFilters () : Array
		{
			return [ new DropShadowFilter( 1 , 45, DefaultSkin.tooltipShadowColor.hexa, 1, 3, 3, 1, 2) ];
		}
		
		static public var timeout : Number = 500;
		static public var margin : Number = 3;
		static public var offset : Number = 10;
		static public var maxLength : Number = 300;
		
		/*-----------------------------------------------------------------------------------
		 * PRIVATE MEMBERS
		 *----------------------------------------------------------------------------------*/
		
		protected var _timeoutShow : Number;
		protected var _timeoutHide : Number;
		protected var _delayShow : Boolean = true;
	
		
		public function ToolTip ()
		{
			super( null );
			allowFocus = false;
			allowOver = false;
			allowPressed = false;
			allowSelected = false;
			mouseEnabled = false;
			mouseChildren = false;
			visible = false;
			
			_labelTextField.multiline = true;
			
			ToolKit.tooltipLevel.addChild( this );
		}

		override protected function updateLabelText () : void
		{
			// First we setup the label with autosize 
			if( _labelTextField )
			{
				_labelTextField.autoSize = TextFieldAutoSize.LEFT;
				_labelTextField.wordWrap = false;
				super.updateLabelText();
				
				if( _labelTextField.textWidth > maxLength )
				{
					// Then we restrict the label size for a too long text
					_labelTextField.autoSize = TextFieldAutoSize.NONE;
					_labelTextField.wordWrap = true;
					_labelTextField.width = maxLength;
					
					super.updateLabelText();
					
					// And finally adjust the label to the real text size
					_labelTextField.width = _labelTextField.textWidth + 4;
					_labelTextField.height = _labelTextField.textHeight + 4;
				}	
			}		
		}

		public function show ( msg : String,
							   icon : Icon = null,
							   refObj : DisplayObject = null ) : void
		{		
			if( msg != null && msg != "" )
			if( _delayShow )
			{
				_timeoutShow = setTimeout( _show, timeout,  msg, icon, refObj );
			}
			else
			{
				clearTimeout( _timeoutHide );
				_show( msg, icon, refObj );
			}
		}
		public function hide () : void
		{
			clearTimeout( _timeoutShow );
			_timeoutHide = setTimeout( _hide, timeout );
			visible = false;
		}
		
		protected function _show ( msg : String,
								   icon : Icon = null,
							   	   refObj : DisplayObject = null ) : void
		{
			label = msg;
			/*
			if( icon )
				this.icon = icon;
			*/
			visible = true;
			
			if( refObj )
			{
				var bb : Rectangle = refObj.getBounds( ToolKit.tooltipLevel );
				x = bb.x;
				y = bb.y;
			}
			else
			{
				x = stage.mouseX + offset;
				y = stage.mouseY + offset;
				
			}
			
			if( x + width > root.stage.stageWidth )
				x += root.stage.stageWidth - ( x + width );
			
			if( y + height > root.stage.stageHeight )
				y = stage.mouseY - height - offset;
				
			_delayShow = false;
		}
		protected function _hide () : void
		{
			_delayShow = true;
		}
	}
}
