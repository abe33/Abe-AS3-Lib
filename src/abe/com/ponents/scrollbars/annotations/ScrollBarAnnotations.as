package abe.com.ponents.scrollbars.annotations
{
	import abe.com.mon.geom.dm;
	import abe.com.ponents.core.*;
	import abe.com.ponents.scrollbars.ScrollBar;

	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Skinable(skin="ScrollBarAnnotations")]
	[Skin(define="ScrollBarAnnotations",
			  inherit="DefaultComponent",
			  state__all__foreground="new abe.com.ponents.skinning.decorations::NoDecoration()"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class ScrollBarAnnotations extends AbstractComponent
	{
		static public const ANNOTATION_HEIGHT : uint = 4;

		protected var _annotations : Array;
		protected var _scrollBar : ScrollBar;


		public function ScrollBarAnnotations ( scrollBar : ScrollBar, ... annotations )
		{
			super ();
			_scrollBar = scrollBar;
			_annotations = [];
			_allowOver = false;
			_allowPressed = false;

			for each ( var a : Annotation in annotations )
				if( a )
					_annotations.push( a );

			invalidatePreferredSizeCache();
		}
		public function get annotations () : Array { return _annotations; }
		public function set annotations ( a : Array ) : void
		{
			_annotations = a;
			invalidate();
		}
		public function get scrollBar () : ScrollBar { return _scrollBar; }
		public function set scrollBar ( scrollBar : ScrollBar ) : void
		{
			_scrollBar = scrollBar;
		}
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = dm( 16, 16 );
			super.invalidatePreferredSizeCache ();
		}

		override public function repaint () : void
		{
			super.repaint ();
			drawAnnotations();
		}
		protected function drawAnnotations () : void
		{
			var g : Graphics = _childrenContainer.graphics;

			g.clear();

			var canScroll : Boolean = _scrollBar.canScroll;
			var h : Number;

			if( canScroll )
				h = _scrollBar.maxScroll + _scrollBar.extent;
			else
				h = _scrollBar.extent;

			for each( var a : Annotation in _annotations )
			{
				g.lineStyle ( 0, a.color.hexa, a.color.alpha / 255 );
				g.beginFill ( a.color.hexa, a.color.alpha / 510 );
				g.drawRect ( 2,
							 a.position / h * ( _scrollBar.height-4 ),
							 width - 6,
							 ANNOTATION_HEIGHT );
				g.endFill();
			}
		}
		public function addAnnotation ( a : Annotation ) : void
		{
			if( !containsAnnotation ( a ) )
			{
				_annotations.push( a );
				invalidate();
			}
		}
		public function containsAnnotation ( a : Annotation ) : Boolean
		{
			return _annotations.indexOf( a ) != -1;
		}
		override public function mouseMove ( e : MouseEvent ) : void
		{
			var canScroll : Boolean = _scrollBar.canScroll;
			var h : Number;

			if( canScroll )
				h = _scrollBar.maxScroll + _scrollBar.extent;
			else
				h = _scrollBar.extent;

			for each( var a : Annotation in _annotations )
			{
				var y : Number = a.position / h * ( _scrollBar.height-4 );
				if( mouseY > y && mouseY < y + 4 )
				{
					_tooltip = a.label;
					showToolTip();
					return;
				}
			}
			hideToolTip();
			_tooltip = null;
		}
		override public function click ( context : UserActionContext ) : void
		{
			var canScroll : Boolean = _scrollBar.canScroll;
			var h : Number;

			if( canScroll )
				h = _scrollBar.maxScroll + _scrollBar.extent;
			else
				h = _scrollBar.extent;

			for each( var a : Annotation in _annotations )
			{
				var y : Number = a.position / h * ( _scrollBar.height-4 );
				if( mouseY > y && mouseY < y + 4 )
				{
					_scrollBar.scrollTo( a.position + 1 );
					return;
				}
			}
		}
	}
}
