package abe.com.ponents.buttons 
{
    import abe.com.edia.text.AdvancedTextField;
    import abe.com.edia.text.builds.BasicBuild;
    import abe.com.edia.text.layouts.BasicLayout;
    import abe.com.mon.core.Clearable;
    import abe.com.ponents.skinning.SkinManagerInstance;
    import abe.com.ponents.skinning.icons.Icon;

    import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="GameButton")]
	[Skin(define="GameButton",
		  inherit="Button"
    )]
    public class GameButton extends Button implements Clearable 
    {
        public function GameButton ( actionOrLabel : * = null, icon : Icon = null )
		{
			_style = SkinManagerInstance.getComponentStyle(this);
			var l : AdvancedTextField = new AdvancedTextField( new BasicBuild(_style.format,false,_style.embedFonts), new BasicLayout() );
			_labelTextField = l;
			l.allowMask = false;
			
			super( actionOrLabel, icon );
			allowMask = false;
			invalidatePreferredSizeCache( );
        }
        override public function removeFromStage ( e : Event ) : void
        {
            super.removeFromStage ( e );
            clear();
        }
		public function clear () : void
		{
			( _labelTextField as AdvancedTextField ).clear();
		}
	}
}