package aesia.com.ponents.tools
{
	import aesia.com.edia.camera.Camera;
	import aesia.com.edia.camera.CameraEvent;
	import aesia.com.edia.camera.CameraLayer;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ContainerEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="Canvas")]
	[Skin(define="Canvas",
		  inherit="DefaultComponent",

		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( aesia.com.mon.utils::Color.White )"
	)]
	public class CameraCanvas extends AbstractContainer
	{
		protected var _camera : Camera;
		protected var _layers : Vector.<CameraLayer>;
		protected var _billboards : Array;

		public function CameraCanvas ()
		{
			super( );
			allowMask = false;
			_camera = new Camera( null, 1, new Range ( 0.2, 2 ) );
			_layers = new Vector.<CameraLayer>();
			_billboards = [];
			
			invalidatePreferredSizeCache();
			_camera.addEventListener( CameraEvent.CAMERA_CHANGE, cameraChange );		}
		protected function cameraChange (event : CameraEvent) : void
		{
			//Log.debug( "in cameraChange : "+_camera.screen );
			for each ( var o : DisplayObject in _billboards )
				updateBillboard( o );
		}
		override public function set doubleClickEnabled (enabled : Boolean) : void 
		{
			super.doubleClickEnabled = enabled;
			_childrenContainer.doubleClickEnabled = enabled;
			for each( var layer : CameraLayer in _layers)
				layer.doubleClickEnabled = enabled;
		}
		public function get camera () : Camera { return _camera; }		public function get canvasLevel () : DisplayObjectContainer { return _childrenContainer; }

		public function get hasLayers() : Boolean { return _layers.length > 0; }		public function get hasManyLayers() : Boolean { return _layers.length > 1; }		public function get bottomLayer () : CameraLayer { return hasLayers ? _layers[0] : null; }
		public function get topLayer () : CameraLayer { return hasLayers ? _layers[_layers.length-1] : null; }

		/*---------------------------------------------------------------
		 * 	LAYERS
		 *--------------------------------------------------------------*/
		public function get layers () : Vector.<CameraLayer>
		{
			return _layers;
		}
		public function getLayerAt( index : uint ) : CameraLayer
		{
			return index < _layers.length ? _layers[ index ] : null;
		}

		public function createLayer () : CameraLayer
		{
			return createLayerAt(_layers.length + 1 );
		}
		public function createLayerAt ( index : uint ) : CameraLayer
		{
			var l : CameraLayer = createDefaultLayer ();
			addLayerAt( l, index );
			return l;
		}
		public function addLayer( l : CameraLayer ) : void
		{
			addLayerAt( l, _layers.length );
		}
		public function addLayerAt( l : CameraLayer, index : uint ) : void
		{
			if( index < _layers.length )
			{
				_layers.splice( index, 0, l );
				_childrenContainer.addChildAt( l, index );			}
			else
			{
				_layers.push( l );
				_childrenContainer.addChild( l );
			}

			_camera.addEventListener( CameraEvent.CAMERA_CHANGE, l.cameraChanged );
		}

		protected function createDefaultLayer () : CameraLayer
		{
			return new CameraLayer();
		}

		/*---------------------------------------------------------------
		 * LAYERS CONTENT
		 *--------------------------------------------------------------*/

		public function addComponentToLayer ( c : Component, lindex : uint ) : void
		{
			addComponent(c);
			getLayerAt(lindex).addChild( c as DisplayObject );
		}
		public function addBillboardComponentToLayer ( c : Component, lindex : uint ) : void
		{
			addComponentToLayer(c,lindex);
			setBillboardObject( c as DisplayObject );
		}
		override public function removeComponent (c : Component) : void
		{
			if( c && containsComponent(c) )
			{
				_children.splice(_children.indexOf( c ), 1);

				if( c.parent )
					c.parent.removeChild( c as DisplayObject );

				teardownChildren(c);
				invalidatePreferredSizeCache();

				unsetBillboardObject( c as DisplayObject );

				dispatchEvent( new ContainerEvent( ContainerEvent.CHILD_REMOVE, c ) );
			}
		}

		/*---------------------------------------------------------------
		 * MISC
		 *--------------------------------------------------------------*/
		public function getObjectUnderTheMouse () : DisplayObject
		{
			var l : Number = _layers.length;
			for( var i : Number = l-1 ; i >=0 ; i-- )
			{
				var layer : Sprite = getLayerAt(i);				
				var cl : Number = layer.numChildren;
				
				while( cl--)
				{
					var o : DisplayObject = layer.getChildAt( cl );				
					if( o.hitTestPoint( StageUtils.stage.mouseX, StageUtils.stage.mouseY, true ) )
						return o;
				}
			}
			return null;
		}
		public function getLocalCameraScreen ( c : Camera ) : Rectangle
		{
			return new Rectangle( c.x,
								  c.y,
							 	  c.width,
								  c.height);
			_childrenContainer.buttonMode = true;
		}
		public function setBillboardObject ( o : DisplayObject ) : void
		{
			if( _billboards.indexOf( o ) == -1 )
			{
				_billboards.push( o );
				updateBillboard( o );
			}
		}
		protected function unsetBillboardObject (c : DisplayObject ) : void
		{
			 if( _billboards.indexOf( c ) != -1 )
				_billboards.splice( _billboards.indexOf( c ), 1 );
		}

		protected function updateBillboard (o : DisplayObject) : void
		{
			o.scaleY = o.scaleX = 1 / _camera.zoom;
		}
		override public function repaint () : void
		{
			if( _camera.safeWidth != width || _camera.safeHeight != height )
			{
				_camera.safeWidth = width;
				_camera.safeHeight = height;
			}
			super.repaint();
		}
	}
}
