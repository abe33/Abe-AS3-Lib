package abe.com.ponents.nodes.renderers.nodes 
{
	import abe.com.mon.utils.Reflection;
	/**
	 * @author cedric
	 */
	public class NodeRendererFactory 
	{
		static public const DEFAULT_RENDERER : NodeRenderer = new DefaultNodeRenderer();
		
		protected var _rendererMap : Object;

		public function NodeRendererFactory ( map : Object = null ) 
		{
			_rendererMap = map ? map : {};
		}
		public function get rendererMap () : Object { return _rendererMap; }
		public function set rendererMap (rendererMap : Object) : void {	_rendererMap = rendererMap; }
		
		public function getRenderer( userObject : * ) : NodeRenderer
		{
			var cn : String = Reflection.getClassName( userObject );
			if( _rendererMap.hasOwnProperty( cn ) )
				return _rendererMap[ cn ];
			else
				return DEFAULT_RENDERER;
		}
	}
}
