package abe.com.ponents.models 
{
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.utils.ContextMenuItemUtils;

	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	/**
	 * @author Cédric Néhémie
	 */
	public class SpinnerNumberModel extends AbstractSpinnerModel 
	{
		protected var _value : Number;
		protected var _min : Number;
		protected var _max : Number;
		protected var _step : Number;
		protected var _intOnly : Boolean;
		protected var _decimals : Number;
		protected var _formatFunction : Function;
		protected var _uintDisplayMode : uint;
		
		static public const DECIMAL : uint = 10;
		static public const HEXADECIMAL : uint = 16;		static public const BINARY : uint = 2;		static public const OCTAL : uint = 8;
		
		
		public function SpinnerNumberModel ( value : Number, 
											 min : Number = 0, 
											 max : Number = 10, 
											 step : Number = 1, 
											 intOnly : Boolean = false,
											 decimals : Number = 2 )
		{
			super();
			_value = value;
			_max = max;
			_min = min;
			_step = step;
			_intOnly = intOnly;
			_decimals = decimals;
			_formatFunction = format;
			_uintDisplayMode = DECIMAL;
			
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			if( _intOnly )
				buildContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected var _cmiBinary : ContextMenuItem;
		protected var _cmiOctal : ContextMenuItem;
		protected var _cmiHexa : ContextMenuItem;
		protected var _cmiDecimal : ContextMenuItem;
		
		protected function displayAsDecimal (event : ContextMenuEvent) : void { uintDisplayMode = DECIMAL; }
		protected function displayAsHexadecimal (event : ContextMenuEvent) : void { uintDisplayMode = HEXADECIMAL; }
		protected function displayAsOctal (event : ContextMenuEvent) : void { uintDisplayMode = OCTAL; }
		protected function displayAsBinary (event : ContextMenuEvent) : void { uintDisplayMode = BINARY; }	
		
		protected function buildContextMenu () : void
		{
			if( _modelMenuContext.length == 0 )
			{
				_cmiBinary = new ContextMenuItem( 
						ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Display as binary"), 
						uintDisplayMode == BINARY ), 
						true );
				_cmiOctal = new ContextMenuItem(  
						ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Display as octal"), 
						uintDisplayMode == OCTAL ) );
						
				_cmiHexa = new ContextMenuItem(  
						ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Display as hexadecimal"), 
						uintDisplayMode == HEXADECIMAL ) );
						
				_cmiDecimal = new ContextMenuItem( 
						ContextMenuItemUtils.getBooleanContextMenuItemCaption( _("Display as decimal"), 
						uintDisplayMode == DECIMAL ) );
				
				_cmiBinary.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsBinary );
				_cmiOctal.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsOctal );
				_cmiHexa.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsHexadecimal );
				_cmiDecimal.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsDecimal );
			
				_modelMenuContext.push(_cmiBinary);
				_modelMenuContext.push(_cmiOctal);
				_modelMenuContext.push(_cmiHexa);
				_modelMenuContext.push(_cmiDecimal );
				
				firePropertyChange( "modelMenuContext", _modelMenuContext );
			}
		}
		
		protected function clearContextMenu () : void
		{
			if( _modelMenuContext.length > 0 )
			{
				_cmiBinary.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsBinary );
				_cmiOctal.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsOctal );
				_cmiHexa.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsHexadecimal );
				_cmiDecimal.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, displayAsDecimal );
				
				_cmiBinary = null;
				_cmiDecimal = null;
				_cmiHexa = null;
				_cmiOctal = null;
				
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { _modelMenuContext = []; }
				TARGET::FLASH_10 { _modelMenuContext = new Vector.<ContextMenuItem>(); }
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				_modelMenuContext = new Vector.<ContextMenuItem>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				firePropertyChange( "modelMenuContext", _modelMenuContext );
			}
		}
		
		protected function hasContextMenus () : Boolean
		{
			return _modelMenuContext.length > 0;		
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function get uintDisplayMode () : uint { return _uintDisplayMode; }	
		public function set uintDisplayMode (uintDisplayMode : uint) : void
		{
			_uintDisplayMode = uintDisplayMode;
			firePropertyChange("displayValue", displayValue);
			
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			if( _intOnly )
			{
				_cmiBinary.caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Display as binary"), 
						uintDisplayMode == BINARY );
						
				_cmiOctal.caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Display as octal"), 
						uintDisplayMode == OCTAL );
						
				_cmiHexa.caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Display as hexadecimal"), 
						uintDisplayMode == HEXADECIMAL );
						
				_cmiDecimal.caption = ContextMenuItemUtils.getBooleanContextMenuItemCaption( _("Display as decimal"), 
						uintDisplayMode == DECIMAL );
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		override public function get displayValue () : String { return _formatFunction( _value ); }
		override public function get value () : * { return _value; }
		override public function set value (v : *) : void
		{
			if( !(v is Number) )
				v = _intOnly ? parseInt( v ) : parseFloat( v );

			if( !isNaN( v ) )
			{
				if( v < _min )
					v = _min;
				else if( v > _max )
					v = _max;
					
				if( _intOnly )
					v = Math.round( v );
				
				_value = v;
			}
			fireDataChange();
		}
		public function get min () : Number	{ return _min; }		
		public function set min (min : Number) : void
		{
			_min = min;
		}
		public function get max () : Number { return _max; }		
		public function set max (max : Number) : void
		{
			_max = max;
		}
		public function get step () : Number { return _step; }		
		public function set step (step : Number) : void
		{
			_step = step;
		}
		public function get intOnly () : Boolean { return _intOnly; }		
		public function set intOnly (intOnly : Boolean) : void
		{
			_intOnly = intOnly;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				if( _intOnly )
					buildContextMenu();
				else
					clearContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		public function get decimals () : Number{ return _decimals; }		
		public function set decimals (decimals : Number) : void
		{
			_decimals = decimals;
		}
		public function get formatFunction () : Function { return _formatFunction; }		
		public function set formatFunction (formatFunction : Function) : void
		{
			_formatFunction = formatFunction;
			firePropertyChange("displayValue", displayValue);
		}

		override public function reset () : void 
		{
			value = min > 0 ? min : 0;
		}

		override public function getNextValue () : *
		{
			return _value + _step;
		}
		override public function getPreviousValue () : *
		{
			return _value - _step;
		}

		override public function hasNextValue () : Boolean
		{
			return _value < _max;
		}
		override public function hasPreviousValue () : Boolean
		{
			return _value > _min;
		}
		
		protected function format( v : Number ) : String
		{
			if( _intOnly )
			{
				switch( _uintDisplayMode )
				{
					case BINARY : 
						return v.toString(2);
					case OCTAL :
						return v.toString(8);
					case HEXADECIMAL : 
						return StringUtils.formatUintAsHexadecimal(v);
					case DECIMAL : 
					default : 
						return String( v );
				}
			}
			else
			{
				return StringUtils.formatNumber( v, _decimals );
			}
			return null;	
		}
		override public function toString () : String
		{
			return StringUtils.stringify(this, {'min':_min,'max':_max,'value':_value});
		}
	}
}
