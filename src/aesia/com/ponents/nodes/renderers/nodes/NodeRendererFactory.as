package aesia.com.ponents.nodes.renderers.nodes 
{
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
		public function getRenderer( userObject : * ) : NodeRenderer
		{/*
			if( _rendererMap.hasOwnProperty( userObject ) )
				return _rendererMap[ userObjectType ];
			else*/
				return DEFAULT_RENDERER;
		}
	}
}
