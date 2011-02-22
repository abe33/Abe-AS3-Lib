package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.containers.Viewport;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.scrollbars.Scrollable;
	import abe.com.ponents.utils.Insets;
	import abe.com.ponents.utils.ScrollPolicies;

	/**
	 * @author Cédric Néhémie
	 */
	public class SlidePaneLayout extends AbstractComponentLayout 
	{
		protected var _scrollUpButton : Button;
		protected var _scrollDownButton : Button;
		protected var _scrollLeftButton : Button;
		protected var _scrollRightButton : Button;
		protected var _viewport : Viewport;
		
		protected var _scrollPolicy : String;
		
		public function SlidePaneLayout ( container : Container = null, policy : String = "auto" )
		{
			super( container );
			_scrollPolicy = policy;
		}
		public function get scrollUpButton () : Button { return _scrollUpButton; }		
		public function set scrollUpButton (scrollUpButton : Button) : void
		{
			_scrollUpButton = scrollUpButton;
		}		
		public function get scrollDownButton () : Button { return _scrollDownButton; }		
		public function set scrollDownButton (scrollDownButton : Button) : void
		{
			_scrollDownButton = scrollDownButton;
		}		
		public function get scrollLeftButton () : Button { return _scrollLeftButton; }		
		public function set scrollLeftButton (scrollLeftButton : Button) : void
		{
			_scrollLeftButton = scrollLeftButton;
		}		
		public function get scrollRightButton () : Button { return _scrollRightButton; }		
		public function set scrollRightButton (scrollRightButton : Button) : void
		{
			_scrollRightButton = scrollRightButton;
		}
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
			
			var innerWidth : Number = prefDim.width;
			var innerHeight : Number = prefDim.height;
			var innerX : Number = 0;
			var innerY : Number = 0;
			
			if( !_viewport.view )
			{
				_scrollDownButton.visible = false;
				_scrollUpButton.visible = false;
				_scrollLeftButton.visible = false;
				_scrollRightButton.visible = false;
				return;
			}
			
			switch( _scrollPolicy )
			{
				case ScrollPolicies.NEVER : 
					_scrollDownButton.visible = false;
					_scrollUpButton.visible = false;
										_scrollLeftButton.visible = false;					_scrollRightButton.visible = false;
					break;
				case ScrollPolicies.HORIZONTAL : 
					_scrollDownButton.visible = false;
					_scrollUpButton.visible = false;
					
					_scrollLeftButton.visible = true;
					_scrollRightButton.visible = true;
					
					innerWidth -= _scrollLeftButton.width + _scrollRightButton.width;
					break;
				case ScrollPolicies.VERTICAL : 
					_scrollDownButton.visible = true;
					_scrollUpButton.visible = true;
					
					_scrollLeftButton.visible = false;
					_scrollRightButton.visible = false;
					
					innerHeight -= _scrollUpButton.height + _scrollDownButton.height;
					break;
				case ScrollPolicies.ALWAYS : 
					_scrollDownButton.visible = true;
					_scrollUpButton.visible = true;
					
					_scrollLeftButton.visible = true;
					_scrollRightButton.visible = true;
					
					innerHeight -= _scrollUpButton.height + _scrollDownButton.height;
					innerWidth -= _scrollLeftButton.width + _scrollRightButton.width;
					break;
				case ScrollPolicies.AUTO : 
				default : 
					if( _viewport.view )
					{
						if( _viewport.view is Scrollable )
						{
							var sc : Scrollable = _viewport.view as Scrollable;
							if( sc.tracksViewportV )
							{
								_scrollDownButton.visible = false;
								_scrollUpButton.visible = false;
							}
							else 
							{
								if( sc.preferredViewportSize.height <= innerHeight )
								{
									_scrollDownButton.visible = false;
									_scrollUpButton.visible = false;
								}
								else if( _scrollPolicy != ScrollPolicies.HORIZONTAL && 
										 _scrollPolicy != ScrollPolicies.NEVER )
								{
									_scrollDownButton.visible = true;
									_scrollUpButton.visible = true;
									_scrollDownButton.enabled = true;
									_scrollUpButton.enabled = true;
									innerY = _scrollUpButton.height;
									innerHeight -= _scrollUpButton.height + _scrollDownButton.height;
								}
								else
								{
									_scrollDownButton.visible = false;
									_scrollUpButton.visible = false;
								}
							}
							
							if( sc.tracksViewportH )
							{
								_scrollLeftButton.visible = false;
								_scrollRightButton.visible = false;
							}
							else 
							{
								if( sc.preferredViewportSize.width <= innerWidth )
								{
									_scrollLeftButton.visible = false;
									_scrollRightButton.visible = false;
								}
								else if( _scrollPolicy != ScrollPolicies.VERTICAL && 
										 _scrollPolicy != ScrollPolicies.NEVER )
								{
									_scrollLeftButton.visible = true;
									_scrollRightButton.visible = true;
									_scrollLeftButton.enabled = true;
									_scrollRightButton.enabled = true;
									innerX = _scrollLeftButton.width;
									innerWidth -= _scrollLeftButton.width + _scrollRightButton.width;
								}
								else
								{
									_scrollLeftButton.visible = false;
									_scrollRightButton.visible = false;
								}
							}
						}
						else
						{
							if( _viewport.view.preferredSize.height <= innerHeight )
							{
								_scrollDownButton.visible = false;
								_scrollUpButton.visible = false;
							}
							else if( _scrollPolicy != ScrollPolicies.HORIZONTAL && 
									_scrollPolicy != ScrollPolicies.NEVER )
							{
								_scrollDownButton.visible = true;
								_scrollUpButton.visible = true;
								innerY = _scrollUpButton.height;
								innerHeight -= _scrollUpButton.height + _scrollDownButton.height;
							}
							else
							{
								_scrollDownButton.visible = false;
								_scrollUpButton.visible = false;
							}
								
							if( _viewport.view.preferredSize.width <= innerWidth )
							{
								_scrollLeftButton.visible = false;
								_scrollRightButton.visible = false;
							}
							else if( _scrollPolicy != ScrollPolicies.VERTICAL && 
									 _scrollPolicy != ScrollPolicies.NEVER )
							{
								_scrollLeftButton.visible = true;
								_scrollRightButton.visible = true;
								
								innerX = _scrollLeftButton.width;
								innerWidth -= _scrollLeftButton.width + _scrollRightButton.width;
							}
							else
							{
								_scrollLeftButton.visible = false;
								_scrollRightButton.visible = false;
							}
						}
					}
					break;
			}
			
			_scrollLeftButton.height = _scrollRightButton.height = innerHeight;
			_scrollRightButton.x = insets.left + innerX + innerWidth;
			_scrollLeftButton.y = _scrollRightButton.y = insets.top + innerY;
			
			_scrollUpButton.width = _scrollDownButton.width = innerWidth;
			_scrollUpButton.x = _scrollDownButton.x = insets.left + innerX;
			_scrollDownButton.y = insets.top + innerY + innerHeight;
	
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
			return  _viewport && _viewport.view ? _viewport.view.preferredSize : new Dimension(100,100 );
		}
		
	}
}
