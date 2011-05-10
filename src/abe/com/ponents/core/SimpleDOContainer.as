package abe.com.ponents.core
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.layouts.display.DisplayObjectLayout;

	import flash.display.DisplayObject;
	/**
	 * Implémentation standard d'un composant n'ayant que des objets <code>DisplayObject</code>
	 * comme sous-objets.
	 * <p>
	 * Un objet <code>SimpleDOContainer</code> compose un objet <code>DisplayObjectLayout</code>
	 * afin de calculer sa taille préférentielle ainsi que pour mettre en page ses sous objets.
	 * </p>
	 *
	 * @author cedric
	 */
	public class SimpleDOContainer extends AbstractComponent
	{
		/**
		 * Une référence vers l'objet <code>DisplayObjectLayout</code> de ce composant.
		 *
		 * @default new DOInlineLayout( _childrenContainer )
		 */
		protected var _childrenLayout : DisplayObjectLayout;
		/**
		 * Une fonction utilisée pour réaliser le tri des enfants de ce composants
		 *
		 * @default	null
		 */
		public var displayObjectSort : Function;

		/**
		 * Constructeur de la classe <code>SimpleDOContainer</code>.
		 */
		public function SimpleDOContainer ()
		{
			super();
			_childrenLayout = _childrenLayout ? _childrenLayout : new DOInlineLayout( _childrenContainer );
			/*
			_childrenContainer.addEventListener( Event.ADDED, childrenChange );
			_childrenContainer.addEventListener( Event.REMOVED, childrenChange );
			*/
			invalidatePreferredSizeCache();
		}
		/**
		 * Une référence vers l'objet <code>DisplayObjectLayout</code> de ce composant.
		 *
		 * @default new DOInlineLayout( _childrenContainer )
		 */
		public function get childrenLayout () : DisplayObjectLayout	{ return _childrenLayout; }
		public function set childrenLayout (childrenLayout : DisplayObjectLayout) : void
		{
			if( childrenLayout )
			{
				_childrenLayout = childrenLayout;

				if( !_childrenLayout.container )
					_childrenLayout.container = _childrenContainer;

				invalidatePreferredSizeCache();
			}
		}
		override public function get maximumContentSize () : Dimension { return _childrenLayout.maximumContentSize; }
		/**
		 * Un entier représentant le nombre d'enfants dans ce composant.
		 */
		public function get childrenCount () : uint { return _childrenContainer.numChildren; }
		/**
		 * @inheritDoc
		 */
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = _childrenLayout.preferredSize.grow( _style.insets.horizontal, _style.insets.vertical );
			super.invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override public function repaint () : void
		{
			if( displayObjectSort != null )
				layoutChildren();

			var size : Dimension = calculateComponentSize();

			_repaint( size );
			_childrenLayout.layout( size, _style.insets );
		}
		/**
		 * Recoit les évènements de modification des enfants de ce composant et provoque
		 * un recalcule du cache de la taille de préférence de ce composant.
		 *
		 * @param	event	évènement diffusé lors de l'ajout ou de la suppression d'un enfant
		 * 					de ce composant
		 */
		/*
		protected function childrenChange (event : Event) : void
		{
			invalidatePreferredSizeCache();
		}*/
		/**
		 * @inheritDoc
		 */
		public function layoutChildren () : void
		{
			var children : Array = [];
			var l : uint = _childrenContainer.numChildren;
			for(var i : uint = 0; i < l ; i++)
				children.push(_childrenContainer.getChildAt(i));

			children.sort ( displayObjectSort );
			while( l-- )
				if ( _childrenContainer.getChildIndex( children[l] ) != l )
					 _childrenContainer.setChildIndex( children[l], l );
		}
		/**
		 * @inheritDoc
		 */
		override public function addComponentChild ( child : DisplayObject ) : void
		{
			super.addComponentChild ( child );
			invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override public function addComponentChildAt ( child : DisplayObject, index : int ) : void
		{
			super.addComponentChildAt ( child, index );
			invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override public function addComponentChildAfter ( child : DisplayObject, after : DisplayObject ) : void
		{
			super.addComponentChildAfter ( child, after );
			invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override public function addComponentChildBefore ( child : DisplayObject, before : DisplayObject ) : void
		{
			super.addComponentChildBefore ( child, before );
			invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override public function removeComponentChild ( child : DisplayObject ) : void
		{
			super.removeComponentChild ( child );
			invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override public function removeComponentChildAt ( index : int ) : void
		{
			super.removeComponentChildAt ( index );
			invalidatePreferredSizeCache();
		}
		public function removeAllComponentChildren ():void
		{
			var l : uint = _childrenContainer.numChildren;
			while( l-- )
				_childrenContainer.removeChild ( _childrenContainer.getChildAt(l) );

			invalidatePreferredSizeCache();
		}
	}
}
