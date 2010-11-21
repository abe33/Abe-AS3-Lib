package aesia.com.ponents.containers 
{
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.dnd.DropEvent;
	import aesia.com.ponents.dnd.DropTarget;
	import aesia.com.ponents.dnd.DropTargetDragEvent;

	import flash.display.Shape;

	/**
	 * 
	 */
	[Style(name="dropZoneColor",type="aesia.com.mon.utils.Color")]
	[Skinable(skin="DropPanel")]
	[Skin(define="DropPanel",
		  inherit="EmptyComponent",
		  
		  custom_dropZoneColor="aesia.com.mon.utils::Color.Black"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class DropPanel extends Panel implements DropTarget 
	{
		public function DropPanel ( dndEnabled : Boolean = true )
		{
			super();
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				_dropStatusShape = new Shape();
				addChild( _dropStatusShape );
				this.dndEnabled = dndEnabled;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		override public function set enabled (b : Boolean) : void
		{
			var old : Boolean = _enabled;
			super.enabled = b;
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			if( old != _enabled )
			{
				if( _enabled && _allowDrag )
					DnDManagerInstance.registerDropTarget( this );
				else if( !_enabled && _allowDrag )
					DnDManagerInstance.unregisterDropTarget( this );
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
/*-----------------------------------------------------------------
 *  DND SUPPORT
 *----------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		protected var _dropEnabled : Boolean;
		protected var _dropStatusShape : Shape;
		public function set dndEnabled ( b : Boolean ) : void
		{
			dragEnabled = dropEnabled = b; 
		}
		public function get dropEnabled () : Boolean { return _dropEnabled;	}		
		public function set dropEnabled (dropEnabled : Boolean) : void
		{
			_dropEnabled = dropEnabled;
			if( _enabled )
			{
				if( _dropEnabled )
					DnDManagerInstance.registerDropTarget( this );
				else
					DnDManagerInstance.unregisterDropTarget( this );
			}
		}
		
		public function get dragEnabled () : Boolean{ return _allowDrag; }		
		public function set dragEnabled (dragEnabled : Boolean) : void
		{
			_allowDrag = dragEnabled;
			
			setChildrenDragEnabled ( dragEnabled );
		}
		
		public function setChildrenDragEnabled ( dragEnabled : Boolean ) : void
		{
			for each ( var c : DragSource in _children)
			{
				/*
				if( c && c.transferData.flavors.some( 
					function ( f : DataFlavor, ... args ) : Boolean 
					{ 
						return f.isSupported( supportedFlavors ); 
					} ) )
				{
				}*/
				c.allowDrag = dragEnabled;
			}
		}
		public function get supportedFlavors () : Array { return null; }		
		
		public function dragEnter (e : DropTargetDragEvent) : void {}	
		public function dragExit (e : DropTargetDragEvent) : void 
		{
			_dropStatusShape.graphics.clear();
		}		
		public function dragOver (e : DropTargetDragEvent) : void 
		{
			_dropStatusShape.graphics.clear();
		}		
		public function drop (e : DropEvent) : void 
		{
			_dropStatusShape.graphics.clear();
		}
		protected function drawDropLeft ( c : Component ) : void
		{
			if( c )
			{
				var x : Number;
				
				if( _childrenContainer.scrollRect )
				{
					x = c.x - _childrenContainer.scrollRect.x + _style.insets.left; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( x , c.y );
					_dropStatusShape.graphics.lineTo( x, c.y + c.height ); 
				}
				else
				{
					x = c.x + _style.insets.left; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( x , c.y );
					_dropStatusShape.graphics.lineTo( x, c.y + c.height ); 
				} 
			}
		}
		protected function drawDropRight ( c : Component ) : void
		{
			if( c )
			{
				var x : Number;
				
				if( _childrenContainer.scrollRect )
				{
					x = c.x + c.width - _childrenContainer.scrollRect.x + _style.insets.left; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( x , c.y - _childrenContainer.scrollRect.y + _style.insets.top );
					_dropStatusShape.graphics.lineTo( x, c.y + c.height - _childrenContainer.scrollRect.y + _style.insets.top ); 
				}
				else
				{
					x = c.x + c.width + _style.insets.left; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( x , c.y + _style.insets.top );
					_dropStatusShape.graphics.lineTo( x, c.y + c.height + _style.insets.top ); 
				}
			}
		}
		protected function drawDropBelow ( c : Component ) : void
		{
			if( c )
			{
				var y : Number;
				
				if( _childrenContainer.scrollRect )
				{
					y = c.y + c.height - _childrenContainer.scrollRect.y + _style.insets.top; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( c.x - _childrenContainer.scrollRect.x + _style.insets.left , y );
					_dropStatusShape.graphics.lineTo( c.x + c.width - _childrenContainer.scrollRect.x + _style.insets.left, y ); 
				}
				else
				{
					y = c.y + c.height + _style.insets.top; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( c.x +_style.insets.left , y );
					_dropStatusShape.graphics.lineTo( c.x + c.width + _style.insets.left, y ); 
				}
			}
		}
		protected function drawDropAbove ( c : Component ) : void
		{
			if( c )
			{
				var y : Number;
				
				if( _childrenContainer.scrollRect )
				{
					y = c.y - _childrenContainer.scrollRect.y + _style.insets.top; 
					
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( c.x - _childrenContainer.scrollRect.x + _style.insets.left, y );
					_dropStatusShape.graphics.lineTo( c.x + c.width - _childrenContainer.scrollRect.x + _style.insets.left, y ); 
				}
				else
				{
					y = c.y + _style.insets.top; 
					_dropStatusShape.graphics.lineStyle( 2, 
														 _style.dropZoneColor.hexa,
														 _style.dropZoneColor.alpha );
					_dropStatusShape.graphics.moveTo( c.x + _style.insets.left, y );
					_dropStatusShape.graphics.lineTo( c.x + c.width + _style.insets.left, y ); 
				}
			}
		}
		protected function drawDropOnto ( c : Component ) : void
		{
			if( c )
			{
				if( _childrenContainer.scrollRect )
				{
					drawDropRect( c.x - _childrenContainer.scrollRect.x + _style.insets.left,
								  c.y - _childrenContainer.scrollRect.y + _style.insets.top, 
								  c.width, 
								  c.height ); 
				}
				else
				{
					drawDropRect( c.x + _style.insets.left,
								  c.y + _style.insets.top, 
								  c.width, 
								  c.height ); 
				}
			}
		}
		
		protected function drawDropRect ( x : Number, y : Number, w : Number, h : Number ) : void
		{
			_dropStatusShape.graphics.lineStyle( 2, 
												 _style.dropZoneColor.hexa,
												 _style.dropZoneColor.alpha );
			_dropStatusShape.graphics.drawRect( x,y,w,h ); 
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
