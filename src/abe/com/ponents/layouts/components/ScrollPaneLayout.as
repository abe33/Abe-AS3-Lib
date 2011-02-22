package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.containers.Viewport;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.scrollbars.ScrollBar;
	import abe.com.ponents.scrollbars.Scrollable;
	import abe.com.ponents.utils.Insets;
	import abe.com.ponents.utils.ScrollPolicies;

	/**
	 * @author Cédric Néhémie
	 */
	public class ScrollPaneLayout extends AbstractComponentLayout 
	{
		protected var _colHead : Viewport;		protected var _rowHead : Viewport;
		protected var _lowerLeft : Component;		protected var _lowerRight : Component;		protected var _upperLeft : Component;		protected var _upperRight : Component;		protected var _vscrollbar : ScrollBar;		protected var _hscrollbar : ScrollBar;
		protected var _viewport : Viewport;
		
		protected var _scrollPolicy : String;
		
		public function ScrollPaneLayout ( container : Container = null, policy : String = "auto" )
		{
			super( container );
			_scrollPolicy = policy;
		}

		public function get colHead () : Viewport { return _colHead; }	
		public function set colHead (colHead : Viewport) : void { _colHead = colHead; }
		
		public function get rowHead () : Viewport { return _rowHead; }		
		public function set rowHead (rowHead : Viewport) : void { _rowHead = rowHead; }
		
		public function get lowerLeft () : Component { return _lowerLeft; }		
		public function set lowerLeft (lowerLeft : Component) : void { _lowerLeft = lowerLeft; }
		
		public function get lowerRight () : Component { return _lowerRight;	}		
		public function set lowerRight (lowerRight : Component) : void { _lowerRight = lowerRight; }
				
		public function get upperLeft () : Component { return _upperLeft; }		
		public function set upperLeft (upperLeft : Component) : void { _upperLeft = upperLeft; }
		
		public function get upperRight () : Component {	return _upperRight; }		
		public function set upperRight (upperRight : Component) : void { _upperRight = upperRight; }
		
		public function get vscrollbar () : ScrollBar { return _vscrollbar; }		
		public function set vscrollbar (vscrollbar : ScrollBar) : void { _vscrollbar = vscrollbar; }
		
		public function get hscrollbar () : ScrollBar { return _hscrollbar; }		
		public function set hscrollbar (hscrollbar : ScrollBar) : void { _hscrollbar = hscrollbar;	}
		
		public function get viewport () : Viewport { return _viewport; }	
		public function set viewport (viewport : Viewport) : void { _viewport = viewport; 
		}
		public function get scrollPolicy () : String { return _scrollPolicy; }		
		public function set scrollPolicy (scrollPolicy : String) : void
		{
			_scrollPolicy = scrollPolicy;
		}

		override public function get preferredSize () : Dimension { return estimatedContentSize(); }

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedContentSize();
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			
			var innerWidth : Number = prefDim.width;			var innerHeight : Number = prefDim.height;
			var innerX : Number = 0;			var innerY : Number = 0;
			
			if( _colHead.view )
			{
				innerHeight -= _colHead.view.preferredSize.height;
				innerY += _colHead.view.preferredSize.height;
				_colHead.visible = true;
			}
			else
				_colHead.visible = false;
			
			if( _rowHead.view )
			{
				innerWidth -= _rowHead.view.preferredSize.width;
				innerX += _rowHead.view.preferredSize.width;
				_rowHead.visible = true;
			}
			else
				_rowHead.visible = false;
			
			switch( _scrollPolicy )
			{
				case ScrollPolicies.NEVER : 
					_vscrollbar.visible = false;
					_hscrollbar.visible = false;
					break;
				case ScrollPolicies.HORIZONTAL : 
					_vscrollbar.visible = false;
					_hscrollbar.visible = true;
					innerHeight -= _hscrollbar.height;
					break;
				case ScrollPolicies.VERTICAL : 
					_hscrollbar.visible = false;
					_vscrollbar.visible = true;
					innerWidth -= _vscrollbar.width;
					break;
				case ScrollPolicies.ALWAYS : 
					_hscrollbar.visible = true;
					_vscrollbar.visible = true;
					innerHeight -= _hscrollbar.height;
					innerWidth -= _vscrollbar.width;
					break;
				case ScrollPolicies.AUTO : 
				default : 
					if( _viewport.view )
					{
						if( _viewport.view is Scrollable )
						{
							var sc : Scrollable = _viewport.view as Scrollable;
							if( sc.tracksViewportV )
								_vscrollbar.visible = false;
							else 
							{
								if( sc.preferredViewportSize.height <= innerHeight )
									_vscrollbar.visible = false;
								else if( _scrollPolicy != ScrollPolicies.HORIZONTAL && 
										 _scrollPolicy != ScrollPolicies.NEVER )
								{
									_vscrollbar.visible = true;
									innerWidth -= _vscrollbar.width;
								}
							}
							
							if( sc.tracksViewportH )
								_hscrollbar.visible = false;
							else 
							{
								if( sc.preferredViewportSize.width <= innerWidth )
									_hscrollbar.visible = false;
								else if( _scrollPolicy != ScrollPolicies.VERTICAL && 
										 _scrollPolicy != ScrollPolicies.NEVER )
								{
									_hscrollbar.visible = true;
									innerHeight -= _hscrollbar.height;
								}
							}
						}
						else
						{
							if( _viewport.view.preferredSize.height <= innerHeight )
								_vscrollbar.visible = false;
							else if( _scrollPolicy != ScrollPolicies.HORIZONTAL && 
									_scrollPolicy != ScrollPolicies.NEVER )
							{
								_vscrollbar.visible = true;
								innerWidth -= _vscrollbar.width;
							}
								
							if( _viewport.view.preferredSize.width <= innerWidth )
								_hscrollbar.visible = false;
							else if( _scrollPolicy != ScrollPolicies.VERTICAL && 
									 _scrollPolicy != ScrollPolicies.NEVER )
							{
								_hscrollbar.visible = true;
								innerHeight -= _hscrollbar.height;
							}
						}
					}
					break;
			}
			
			_vscrollbar.height = innerHeight;
			_vscrollbar.x = insets.left + innerX + innerWidth;
			_vscrollbar.y = insets.top + innerY;
			
			_hscrollbar.width = innerWidth;
			_hscrollbar.x = insets.left + innerX;
			_hscrollbar.y = insets.top + innerY + innerHeight;
			
			if( _colHead.view )
			{
				_colHead.x = insets.left + innerX;				_colHead.y = insets.top;
				_colHead.size = new Dimension( innerWidth , innerY );
				
				if( _vscrollbar.visible && _upperRight )
				{
					_upperRight.visible = true;
					_upperRight.x = insets.left + innerX + innerWidth;
					_upperRight.y = insets.top;
					_upperRight.size = new Dimension( _vscrollbar.width, innerY );
				}
				else if( _upperRight )
					_upperRight.visible = false;
					
				
				if( _rowHead.view && _upperLeft )
				{
					_upperLeft.visible = true;
					_upperLeft.x = insets.left;					_upperLeft.y = insets.top;
					_upperLeft.size = new Dimension( innerX, innerY );
				}
				else if( _upperLeft )
					_upperLeft.visible = false;
				
			}
			if( _rowHead.view )
			{
				_rowHead.y = insets.top + innerY;				_rowHead.x = insets.left;
				_rowHead.size = new Dimension( innerX, innerHeight );
				
				if( _hscrollbar.visible && _lowerLeft )
				{
					_lowerLeft.visible = true;
					_lowerLeft.y = insets.top + innerY + innerHeight;					_lowerLeft.x = insets.left;
					_lowerLeft.size = new Dimension( innerX, _hscrollbar.height );
				}
				else if( _lowerLeft )
					_lowerLeft.visible = false;
			}
			
			if( _hscrollbar.visible && _vscrollbar.visible && _lowerRight )
			{
				_lowerRight.visible = true;
				_lowerRight.x = insets.left + innerX + innerWidth;
				_lowerRight.y = insets.top + innerY + innerHeight;
				_lowerRight.size = new Dimension( _vscrollbar.width, _hscrollbar.height );
			}
			else if( _lowerRight )
				_lowerRight.visible = false;
			
			_viewport.x = insets.left + innerX;
			_viewport.y = insets.top + innerY;
			_viewport.size = new Dimension( innerWidth, innerHeight );
			
			if( _viewport.view is Scrollable )
			{
				var scv : Scrollable = _viewport.view as Scrollable;
				
				var d : Dimension = scv.preferredViewportSize.clone();
				
				if( scv.tracksViewportH )
					d.width = innerWidth;
				
				if( scv.tracksViewportV )
					d.height = innerHeight;
				
				_viewport.view.size = d;
			}
			super.layout( preferredSize, insets );
		}

		protected function estimatedContentSize () : Dimension
		{
			return  _viewport && _viewport.view ? _viewport.view.preferredSize : new Dimension(100,100);
		}
	}
}
