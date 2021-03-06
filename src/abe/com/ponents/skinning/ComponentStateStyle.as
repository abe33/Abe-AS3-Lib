/**
 * @license
 */
package abe.com.ponents.skinning 
{
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.skinning.decorations.SimpleBorders;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.ponents.skinning.decorations.ComponentDecoration;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;
	import abe.com.ponents.utils.Insets;

	import org.osflash.signals.Signal;

	import flash.text.TextFormat;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/**
	 * @author Cédric Néhémie
	 */
	dynamic public class ComponentStateStyle extends Proxy implements FormMetaProvider
	{
		public var propertyChanged : Signal;
		public var styleStateChanged : Signal;
		
		protected var _background : ComponentDecoration;
		protected var _foreground : ComponentDecoration;
		protected var _textColor : Color;
		protected var _format : TextFormat;
		protected var _outerFilters : Array;
		protected var _innerFilters : Array;
		protected var _corners : Corners;
		protected var _insets : Insets;
		protected var _borders : Borders;
		protected var _customProperties : Object;

		public function ComponentStateStyle ( background : ComponentDecoration = null, 
											  foreground : ComponentDecoration = null, 
											  textColor : Color = null, 
											  format : TextFormat = null,
											  insets : Insets = null,
											  borders : Borders = null,
											  corners : Corners = null,
											  outerFilters : Array = null,
											  innerFilters : Array = null )
		{		
			propertyChanged = new Signal();		
			styleStateChanged = new Signal();		
			_background = background;
			_foreground = foreground;
			_textColor = textColor;
			_corners = corners;
			_format = format;
			_insets = insets;
			_borders = borders;
			_outerFilters = outerFilters;
			_innerFilters = innerFilters;
			_customProperties = {};
		}
		[Form(type="componentDecoration", 
			  defaultValue="new abe.com.ponents.skinning.decorations::NoDecoration()", 
			  category="Decorations", 
			  order="2", 
			  label="Background",
			  description="The background decoration field defines the render type for the background of a component. A component decoration could be either a verctor graphics or a bitmap graphics. The background decoration is drawn below the component's content.")]
		public function get background () : * { return _background; }		
		public function set background (background : *) : void
		{
			if( background is Color )
            	_background = new SimpleFill(background as Color);
            else if( background is ComponentDecoration )
				_background = background;
            else
            	return;
                
			fireChangeEvent ();
			firePropertyChangedSignal("background", background );
		}
		[Form(type="componentDecoration", 
			  defaultValue="new abe.com.ponents.skinning.decorations::NoDecoration()", 
			  category="Decorations", 
			  order="3", 
			  label="Foreground",
			  description="The foreground decoration field defines the render type for the foreground of a component. A component decoration could be either a verctor graphics or a bitmap graphics. The foreground decoration is drawn above the component's content.")]
		public function get foreground () : * { return _foreground; }		
		public function set foreground (foreground : * ) : void
		{
            if( foreground is Color )
            	_foreground = new SimpleBorders( foreground as Color )
            else if( foreground is ComponentDecoration )
				_foreground = foreground;
            else
            	return;
            
			fireChangeEvent ();
			firePropertyChangedSignal("foreground", foreground );
		}
		[Form(type="filtersArray", 
			  defaultValue="[]", 
			  category="Decorations", 
			  categoryOrder="2",
			  order="1", 
			  label="Outer Filters",
			  description="The outer filters of a component are a list of BitmapFilters object which are applied on the whole component.")]
		public function get outerFilters () : Array { return _outerFilters; }		
		public function set outerFilters (outerFilters : Array) : void
		{
			_outerFilters = outerFilters;
			fireChangeEvent ();
			firePropertyChangedSignal("outerFilters", outerFilters );
		}
		[Form(type="filtersArray", 
			  defaultValue="[]", 
			  category="Decorations", 
			  order="1", 
			  label="Inner Filters",
			  description="The inner filters of a component are a list of BitmapFilters object which are applied on component's content.")]
		public function get innerFilters () : Array { return _innerFilters; }		
		public function set innerFilters (innerFilters : Array) : void
		{
			_innerFilters = innerFilters;
			fireChangeEvent ();
			firePropertyChangedSignal("innerFilters", innerFilters );
		}
		
		[Form(type="color", 
			  defaultValue="color(Black)", 
			  category="Text Settings", 
			  categoryOrder="1", 
			  order="0", 
			  label="Text Color",
			  description="The color of the text within a component. The color of a text defined in a TextFormat object is not used, instead the color of the text will be set using the text color field of a component style.")]
		public function get textColor () : Color { return _textColor;	}		
		public function set textColor (textColor : Color) : void
		{
			_textColor = textColor;
			fireChangeEvent ();
			firePropertyChangedSignal("textColor", textColor );
		}
		[Form(type="textFormat", 
			  defaultValue="new flash.text::TextFormat('Verdana',10)", 
			  category="Text Settings", 
			  order="1", 
			  label="Text Format",
			  description="The text format for this component. The color field of the a TextFormat object is ignored by the components, in order to allow a style to share the same text format along its different states and to change the text color in the same time.")]
		public function get format () : TextFormat { return _format; }	
		public function set format (format : TextFormat) : void
		{
			_format = format;
			fireChangeEvent ();
			firePropertyChangedSignal("format", format );
		}
		[Form(type="cornersUint", 
			  defaultValue="new abe.com.ponents.utils::Corners()", 
			  category="Boxing Settings", 
			  categoryOrder="0", 
			  order="1", 
			  label="Corners",
			  description="The corners property defines the radius of rounded corners of a component. The corners will be visible only when decorators are specified onto one of the decoration fields. However, some decorators don't support corners, such as the SlicedBitmapBox and the AdvancedSlicedBitmapBox.")]
		public function get corners () : Corners { return _corners; }		
		public function set corners (corners : Corners) : void
		{
			_corners = corners;
			fireChangeEvent ();
			firePropertyChangedSignal("corners", corners );
		}
		[Form(type="insetsUint", 
			  defaultValue="new abe.com.ponents.utils::Insets()", 
			  category="Boxing Settings", 
			  order="0", 
			  label="Insets",
			  description="The insets property stand for the internal margin of a component. The preferred size of a component generally consider the insets as a modifier of the component size. By the way a component preferred size will generally be the results of the addition of the component's content size as calculated by the current component's layout with the component's style insets.")]
		public function get insets () : Insets { return _insets; }		
		public function set insets (insets : Insets) : void
		{
			_insets = insets;
			fireChangeEvent ();
			firePropertyChangedSignal("insets", insets );
		}
		[Form(type="bordersUint", 
			  defaultValue="new abe.com.ponents.utils::Borders()", 
			  category="Boxing Settings", 
			  order="2", 
			  label="Borders",
			  description="The borders property of a component defines the size of each border of the component. However, setting borders don't mean that borders will be visible on a component. To have borders displayed on a component you have to set a border decoration onto one of the decoration fields.")]
		public function get borders () : Borders { return _borders; }		
		public function set borders (borders : Borders) : void
		{
			_borders = borders;
			fireChangeEvent ();
			firePropertyChangedSignal("borders", borders );
		}
		
		override flash_proxy function getProperty (name : *) : *
		{
			return _customProperties.hasOwnProperty(name) ? _customProperties[name] : undefined;
		}
		override flash_proxy function setProperty (name : *, value : *) : void
		{
			_customProperties[name]=value;
			firePropertyChangedSignal(name, value);
		}

		override flash_proxy function callProperty (name : *, ...args : *) : *
		{
			return flash_proxy::getProperty( name );
		}
		override flash_proxy function hasProperty (name : *) : Boolean 
		{
			return _customProperties.hasOwnProperty(name) || 
				   ["background",
					"foreground",
					"textColor",
					"corners",
					"format",
					"insets",
					"borders",
					"outerFilters",
					"innerFilters"].indexOf(name) != -1;
		}
		
		protected function firePropertyChangedSignal ( pname : String, pvalue : * ) : void
		{
			propertyChanged.dispatch( pname, pvalue );
		}
		protected function fireChangeEvent () : void
		{
			styleStateChanged.dispatch( this );
		}
	}
}
