package abe.com.ponents.skinning.icons 
{
	import abe.com.patibility.lang._$;
	import abe.com.ponents.allocators.EmbeddedBitmapAllocatorInstance;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="clazz")]
	public class EmbeddedBitmapIcon extends BitmapIcon 
	{
		protected var _class : Class;
		
		public function EmbeddedBitmapIcon ( c : Class = null )
		{
			_contentType = "BitmapData";
			super();
			this.clazz = c;
			invalidatePreferredSizeCache();
		}
		[Form(label="Symbol", type="embeddedBitmap")]
		public function get clazz() : Class{ return _class;}
		public function set clazz( cl : Class ) : void
		{
			if( _bitmap && _childrenContainer.contains( _bitmap ) )
			{
				_childrenContainer.removeChild( _bitmap );
				EmbeddedBitmapAllocatorInstance.release(_bitmap);
			}

			_class = cl;
			
			init();
		}
		override public function init () : void
		{
			if( _class )
			{
				_bitmap = EmbeddedBitmapAllocatorInstance.get( _class );
				super.init();
			}
		}

		override public function dispose () : void
		{
			EmbeddedBitmapAllocatorInstance.release( _bitmap );
			super.dispose();
		}

		override public function clone () : *
		{
			return new EmbeddedBitmapIcon( _class );
		}
	}
}
