package abe.com.ponents.layouts.components
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.containers.Accordion;
	import abe.com.ponents.containers.AccordionTab;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class AccordionLayout extends AbstractComponentLayout
	{
		protected var _accordion : Accordion;
		public function AccordionLayout ( container : Accordion = null)
		{
			super ( container );
			_accordion = container;
		}

		override public function get preferredSize () : Dimension { return estimatedSize( ); }


		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();

			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : estimatedSize();
			var tab : AccordionTab;
			var y : Number = 0;
			var h : Number = prefDim.height;

			for each( tab in _accordion.tabs )
				h-= tab.preferredHeight;

			h = Math.max( h, 50 );

			for each( tab in _accordion.tabs )
			{
				tab.y = y;
				tab.width = prefDim.width;
				y += tab.preferredHeight;

				if( tab.content == _accordion.tabContentContainer1.view )
				{
					_accordion.tabContentContainer1.y = y;
					_accordion.tabContentContainer1.size = dm ( prefDim.width, h * _accordion.transition );
					y += h * _accordion.transition;
				}
				else if( tab.content == _accordion.tabContentContainer2.view )
				{
					_accordion.tabContentContainer2.y = y;
					_accordion.tabContentContainer2.size = dm ( prefDim.width, h * ( 1-_accordion.transition ) );					y += h * ( 1-_accordion.transition );
				}
			}
		}

		protected function estimatedSize () : Dimension
		{
			var w : Number = 0;			var h : Number = 0;

			for each( var tab : AccordionTab in _accordion.tabs )
			{
				w = Math.max( w, tab.preferredWidth );
				h += tab.preferredHeight;
				if( tab.content )
				{
					w = Math.max ( w, tab.content.preferredWidth );
					if( tab.content == _accordion.tabContentContainer1.view )
						h += tab.content.preferredHeight * _accordion.transition;
					else if( tab.content == _accordion.tabContentContainer2.view )
						h += tab.content.preferredHeight * (1-_accordion.transition);
				}
			}
			return dm(w,h);
		}
	}
}
