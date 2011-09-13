package abe.com.ponents.layouts.components 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.Container;
    import abe.com.ponents.utils.Insets;
	/**
	 * @author Cédric Néhémie
	 */
	public class ConstraintLayout extends AbstractComponentLayout 
	{
		protected var _components : Vector.<Component>;
		protected var _constraints : Vector.<Constraint>;
		
		public function ConstraintLayout ( container : Container = null )
		{
			super( container );
			_components = new Vector.<Component>();			_constraints = new Vector.<Constraint>();
		}

		public function addComponent ( c : Component, ct : Constraint ) : void
		{
			if( !contains(c) )
			{
				_components.push( c );
				_constraints.push( ct ); 
			}
		}
		public function contains ( c : Component ) : Boolean 
		{
			return _components.indexOf( c ) != -1;
		}

		override public function get preferredSize () : Dimension {	return super.preferredSize; }

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			super.layout( preferredSize, insets );
		}

		public function estimatedSize () : Dimension
		{
			/*
			var l : Number = _components.length;
			var i : Number;
			var w : Number = 0;
			var h : Number = 0;
			*/			
			return null;
		}
	}
}
