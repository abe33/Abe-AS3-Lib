package abe.com.ponents.text 
{
    import abe.com.edia.text.AdvancedTextField;
    import abe.com.edia.text.builds.BasicBuild;
    import abe.com.edia.text.layouts.BasicLayout;
    import abe.com.mon.core.Clearable;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.skinning.SkinManagerInstance;

    import flash.filters.GlowFilter;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="GameLabel")]
	[Skin(define="GameLabel",
		  inherit="EmptyComponent",
		  custom_embedFonts="false"
    )]
    public class GameLabel extends Label implements Clearable 
	{
        public function GameLabel ( text : String = "Label", configure : Function = null, forComponent : Component = null )
		{
			_style = SkinManagerInstance.getComponentStyle(this);
			var l : AdvancedTextField = new AdvancedTextField( new BasicBuild(_style.format,false,_style.embedFonts), new BasicLayout() );
			l.allowMask = false;
			_label = l;
            if( configure != null )
            	configure( l );
			super( text, forComponent );
			
			childrenLayout = new DOInlineLayout( _childrenContainer, 0, "center" );
			mouseEnabled = false;
			mouseChildren = false;
			allowMask = false;
        }
        override public function invalidatePreferredSizeCache () : void
        {
            var atf : AdvancedTextField = _label as AdvancedTextField;
            
//            ( atf.build as BasicBuild ).rebuildChars();
//            atf.layout.layout( atf.build.chars );
	        _label.width = _preferredSizeCache ? _preferredSizeCache.width : 100;
	        _label.height = _label.textHeight + 4;
            super.invalidatePreferredSizeCache ();
        }

        override public function repaint () : void
        {
            super.repaint ();
            _label.x = _style.insets.left;
            _label.y = _style.insets.top;
            _label.width = width-_style.insets.horizontal;
            _label.height = height-_style.insets.vertical;
        }
		public function clear () : void
		{
			( _label as AdvancedTextField ).clear();
		}
	}
}