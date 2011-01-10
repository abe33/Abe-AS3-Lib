package aesia.com.ponents.nodes.renderers.links 
{
	import aesia.com.ponents.nodes.core.NodeLink;
	/**
	 * @author cedric
	 */
	public class LinkRendererFactory 
	{
		static protected const DEFAULT_RENDERER : SimpleLine = new SimpleLine(); 
		
		protected var _relationshipMap : Object;
		
		public function LinkRendererFactory ( map : Object = null ) 
		{
			_relationshipMap = map ? map : {};
		}
		public function get relationshipMap () : Object { return _relationshipMap; }
		public function set relationshipMap (relationshipMap : Object) : void
		{
			_relationshipMap = relationshipMap;
		}
		public function get keys () : Array 
		{
			var a : Array = [];
			for( var i : String in _relationshipMap)
				a.push( i );
			
			a.sort();
			return a;
		}
		public function getRenderer ( link : NodeLink ) : LinkRenderer
		{
			if( _relationshipMap.hasOwnProperty( link.relationship ) )
				return _relationshipMap[ link.relationship ];
			else
				return DEFAULT_RENDERER;
		}
	}
}
