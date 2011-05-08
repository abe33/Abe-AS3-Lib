package abe.com.ponents.skinning.icons 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.geom.Dimension;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.AbstractComponent;
	import abe.com.ponents.layouts.display.DOStretchLayout;
	import abe.com.ponents.layouts.display.DisplayObjectLayout;

	import flash.utils.getQualifiedClassName;

	[Skinable(skin="EmptyComponent")]
	public class Icon extends AbstractComponent implements Allocable, Cloneable, FormMetaProvider, Serializable
	{
		protected var _childrenLayout : DisplayObjectLayout;
		protected var _contentType : String;
		
		public function Icon ()
		{
			super();
			_contentType = _contentType ? _contentType : "No Type";
			_allowFocus = false;
			_allowMask = false;
			_allowOver = false;
			_allowOverEventBubbling = true;
			_allowPressed = false;
			_allowSelected = false;
			_isComponentLeaf = false;
			_childrenLayout = _childrenLayout ? _childrenLayout : new DOStretchLayout( _childrenContainer );
		}

		public function get childrenLayout () : DisplayObjectLayout	{ return _childrenLayout; }		
		public function set childrenLayout (childrenLayout : DisplayObjectLayout) : void
		{
			_childrenLayout = childrenLayout;
			
			if( !_childrenLayout.container )
				_childrenLayout.container = _childrenContainer;

			invalidatePreferredSizeCache();
		}
		public function get contentType () : String { return _contentType; }
		
		override public function set preferredSize (d : Dimension) : void 
		{
			super.preferredSize = d;
		}
		
		override public function repaint () : void
		{
			var size : Dimension = calculateComponentSize();
			_repaint( size );			
			_childrenLayout.layout( size, _style.insets );
		}
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = _childrenLayout.preferredSize.grow( _style.insets.horizontal, _style.insets.vertical );
			super.invalidatePreferredSizeCache();
		}
		override public function invalidate (asValidateRoot : Boolean = false) : void
		{
			super.invalidate( asValidateRoot );
			//if( displayed )
			repaint();
		}
		
		public function dispose () : void {}		
		public function init () : void 
		{
			invalidatePreferredSizeCache();
		}
		public function clone () : * { return new Icon(); }
		
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		
		public function toReflectionSource () : String
		{
			return _$("new $0()", getQualifiedClassName(this));
		}
	}
}
