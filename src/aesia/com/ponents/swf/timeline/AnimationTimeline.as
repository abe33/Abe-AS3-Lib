package aesia.com.ponents.swf.timeline
{
	import aesia.com.ponents.layouts.components.AnimationTimelineLayout;
	import aesia.com.ponents.core.AbstractContainer;

	[Skinable(skin="AnimationTimeline")]
	[Skin(define="AnimationTimeline",
			  inherit="DefaultComponent",
			  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill(color(White))"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class AnimationTimeline extends AbstractContainer
	{
		static public const FRAMES_WIDTH : uint = 8;		static public const FRAMES_HEIGHT : uint = 20;

		protected var _layers : Array;

		public function AnimationTimeline ( ... layers )
		{
			_layers = [];

			_childrenLayout = new AnimationTimelineLayout( this, FRAMES_WIDTH, FRAMES_HEIGHT );
			super ();

			for each( var o : TimelineLayer in layers )
			{
				_layers.push( o );
				addComponents.apply(this, o.frames );
			}
			invalidatePreferredSizeCache();
		}

		public function get layers () : Array { return _layers; }		public function get layersLength () : uint { return _layers.length; }
		public function get framesLength () : uint
		{
			var n : uint= 0;
			_layers.forEach( function( t : TimelineLayer, ... args ) : void
			{
				n = Math.max( n, t.length );
			} );
			return n;
		}

		public function addNewLayer( ... frames ) : TimelineLayer
		{
			var layer : TimelineLayer;
			if( frames[0] is Array )
				layer = new TimelineLayer ( frames[0] );			else
				layer = new TimelineLayer ( frames );

			_layers.push ( layer );
			addComponents.apply(this, layer.frames );

			return layer;
		}
		public function removeLayer( id : uint ) : void
		{
		}
	}
}
