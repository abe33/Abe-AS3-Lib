package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class MacroDecoration implements ComponentDecoration, FormMetaProvider
	{
		[Form(type="array", 
			  label="Decorations",
			  contentType="abe.com.ponents.skinning.decorations::ComponentDecoration", 
			  listCell="abe.com.ponents.lists::CustomEditCell")]
		public var decorations : Array;
		public function MacroDecoration ( ... decorations ) 
		{
			this.decorations = [];
			var deco : ComponentDecoration;
			if( decorations.length == 1 && decorations[0] is Array )
			{
				for each( deco in decorations[0] )
					if( deco )
						addComponentDecoration( deco );
			}
			else
			{
				for each( deco in decorations )
					if( deco )
						addComponentDecoration( deco );
			}
		}
		public function clone () : * 
		{
			return new MacroDecoration(decorations.map(function(c : ComponentDecoration) : ComponentDecoration { return c.clone(); } ));
		}
		public function equals (o : *) : Boolean
		{
			if( o is MacroDecoration )
			{
				var m : MacroDecoration = o as MacroDecoration;
				if( m.decorations.length != decorations.length )
					return false;
				
				return decorations.every(function( o : ComponentDecoration, i:int, ... args) : Boolean {
					return o.equals( m.decorations[i] );
				} );
			}
			return false;
		}

		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			var l : uint = decorations.length;
			for(var i : uint=0;i<l;i++)
				decorations[i].draw(r, g, c, borders, corners, smoothing );
		}
		
		public function addComponentDecoration ( o : ComponentDecoration ) : void
		{
			if( !containsComponentDecoration( o ) )
				decorations.push( o ); 
		} 
		public function addComponentDecorations ( ... args ) : void
		{
			for each( var o : ComponentDecoration in args )
				if( o )
					addComponentDecoration ( o );
		} 
		
		public function removeComponentDecoration ( o : ComponentDecoration ) : void
		{
			if( containsComponentDecoration( o ) )
				decorations.splice( decorations.indexOf( o ), 1 ); 
		}
		public function removeComponentDecorations ( ... args ) : void
		{
			for each( var o : ComponentDecoration in args )
				if( o )
					removeComponentDecoration ( o );
		}
		public function containsComponentDecoration ( o : ComponentDecoration ) : Boolean
		{
			return decorations.indexOf( o ) != -1;
		}
		
		public function toSource () : String
		{
			return  "new "+ getQualifiedClassName(this).replace("::", ".") + "(" + decorations.map(
					function(c:ComponentDecoration,...args):String
					{
						return c.toSource();
					}) + ")";
		}
		public function toReflectionSource () : String
		{
			return  "new "+ getQualifiedClassName(this) + "(" + decorations.map(
					function(c:ComponentDecoration,...args):String
					{
						return c.toReflectionSource();
					}) + ")";
		}
	}
}
