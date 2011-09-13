package abe.com.ponents.utils 
{
    import abe.com.mon.utils.StageUtils;
    import abe.com.motion.SingleTween;
    import abe.com.motion.Tween;
    import abe.com.ponents.core.Component;

    import flash.display.DisplayObject;
	/**
	 * @author Cédric Néhémie
	 */
	public class PopupUtils 
	{
		static public const NONE : int = 0;
		static public const MODAL : int = 1;
		static public const HIDE_ON_BLUR : int = 2;
		
		static public var animateModal : Boolean = true;
		
		static protected var _levels : Array = new Array();
		static protected var _lastMode : int;
		static protected var tween : SingleTween = new SingleTween( null, "alpha", .3, 250, 0 );
		
		static public function showAsModalPopup ( c : Component, invoker : Component = null ) : void
		{
			_lastMode = MODAL;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var level : PopupLevel = new PopupLevel( [c], invoker, MODAL );  }
			TARGET::FLASH_10 { var level : PopupLevel = new PopupLevel( Vector.<Component>([c]), invoker, MODAL );  }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var level : PopupLevel = new PopupLevel( Vector.<Component>([c]), invoker, MODAL ) ; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			level.init();
			_levels.push( level );
			
			ToolKit.mouseCatcherLevel.addChild( level.mouseCatcher );
			StageUtils.lockToStage( level.mouseCatcher );
			if( animateModal )
			{
				tween.target = level.mouseCatcher;
				tween.reversed = false;
				tween.execute();
			}
			ToolKit.popupLevel.addChild( c as DisplayObject );
			StageUtils.lockToStage( c as DisplayObject, StageUtils.X_ALIGN_CENTER + StageUtils.Y_ALIGN_CENTER );	

			c.grabFocus();
		}
		static public function showAsNormalPopup ( c : Component, invoker : Component = null ) : void
		{
			_lastMode = NONE;
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var level : PopupLevel = new PopupLevel( [c], invoker, NONE );  }
			TARGET::FLASH_10 { var level : PopupLevel = new PopupLevel( Vector.<Component>([c]), invoker, NONE );  }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var level : PopupLevel = new PopupLevel( Vector.<Component>([c]), invoker, NONE ) ; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			level.init();
			_levels.push( level );
			/*
			ToolKit.popupLevel.addChild( level.mouseCatcher );
			StageUtils.lockToStage( level.mouseCatcher );
			if( animateModal )
			{
				tween.target = level.mouseCatcher;
				tween.reversed = false;
				tween.execute();
			}*/
			ToolKit.popupLevel.addChild( c as DisplayObject );
			StageUtils.lockToStage( c as DisplayObject, StageUtils.X_ALIGN_CENTER + StageUtils.Y_ALIGN_CENTER );	

			c.grabFocus();
			
		}
		static public function showAsHideOnBlurPopup ( c : Component, invoker : Component = null ) : void
		{
			var level : PopupLevel;
			if( _lastMode != HIDE_ON_BLUR || _levels.length == 0 )
			{
				_lastMode = HIDE_ON_BLUR;
	
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { level = new PopupLevel( [c], invoker, HIDE_ON_BLUR ) ;  }
				TARGET::FLASH_10 { level = new PopupLevel( Vector.<Component>([c]), invoker, HIDE_ON_BLUR ) ;  }
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				level = new PopupLevel( Vector.<Component>([c]), invoker, HIDE_ON_BLUR ) ; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				level.init();
				_levels.push( level );
				
				ToolKit.popupLevel.addChild( level.mouseCatcher );
				StageUtils.lockToStage( level.mouseCatcher, StageUtils.WIDTH + StageUtils.HEIGHT );
				ToolKit.popupLevel.addChild( c as DisplayObject );		
				c.grabFocus();
			}
			else
			{
				level = _levels[_levels.length-1];
				level.components.push(c);
				ToolKit.popupLevel.addChild( c as DisplayObject );
				c.grabFocus();
			}
		}
		static protected function tweenEnded ( t : Tween ) : void
		{
			ToolKit.mouseCatcherLevel.removeChild( tween.target as DisplayObject );
			tween.tweenEnded.remove( tweenEnded );
		}
		static public function pop () : void
		{
			if( _levels.length == 0 )
				return;
			
			var level : PopupLevel = _levels.pop();
		
			if( level.mode == PopupUtils.MODAL)
			{
				if( animateModal )
				{
					tween.target = level.mouseCatcher;
					tween.tweenEnded.add( tweenEnded );
					tween.reversed = true;
					tween.execute();
				}
				else if( ToolKit.mouseCatcherLevel.contains( level.mouseCatcher ) )
					ToolKit.mouseCatcherLevel.removeChild( level.mouseCatcher );
			}			
			else if( ToolKit.mouseCatcherLevel.contains( level.mouseCatcher ) )
				ToolKit.mouseCatcherLevel.removeChild( level.mouseCatcher );
			
			StageUtils.unlockFromStage( level.mouseCatcher );
			for each(var c : DisplayObject in level.components)
			{
				if( ToolKit.popupLevel.contains( c ) )
					ToolKit.popupLevel.removeChild( c );
				
				StageUtils.unlockFromStage( c );
			}
			if( level.invoker )
				level.invoker.grabFocus();
			
			level.dispose();
		}
	}
}
import abe.com.mon.core.Allocable;
import abe.com.ponents.core.Component;
import abe.com.ponents.utils.PopupUtils;

import flash.display.Sprite;
import flash.events.MouseEvent;

internal class PopupLevel implements Allocable
{
	/*FDT_IGNORE*/
	TARGET::FLASH_9
	public var components : Array;
	TARGET::FLASH_10
	public var components : Vector.<Component>;
	TARGET::FLASH_10_1 /*FDT_IGNORE*/
	public var components : Vector.<Component>;
	
	public var mode : int;
	public var invoker : Component;
	protected var _sprite : Sprite;

	/*FDT_IGNORE*/
	TARGET::FLASH_9
	public function PopupLevel ( comps : Array, invoker : Component = null, mod : int = 0 )
	{
		this.components = comps;
		this.invoker = invoker;
		this.mode = mod;
	}
	TARGET::FLASH_10
	public function PopupLevel ( comps : Vector.<Component>, invoker : Component = null, mod : int = 0 )
	{
		this.components = comps;
		this.invoker = invoker;
		this.mode = mod;
	}
	TARGET::FLASH_10_1 /*FDT_IGNORE*/
	public function PopupLevel ( comps : Vector.<Component>, invoker : Component = null, mod : int = 0 )
	{
		this.components = comps;
		this.invoker = invoker;
		this.mode = mod;
	}
	
	protected function createMouseCatcherShape () : void
	{
		_sprite = new Sprite();
		_sprite.graphics.beginFill(0);
		_sprite.graphics.drawRect(0, 0, 10, 10);
		_sprite.graphics.endFill();
		
		if( this.mode == PopupUtils.MODAL )
			_sprite.alpha = 0.3;
		else
			_sprite.alpha = 0;
	}
	
	private function click (event : MouseEvent) : void
	{
		switch( mode )
		{
			case PopupUtils.HIDE_ON_BLUR :
				PopupUtils.pop();				
				break;
			case PopupUtils.MODAL : 
				components[0].grabFocus();
				break;
			default : 
				break;
		}
	}
	
	public function init () : void
	{
		createMouseCatcherShape();
		_sprite.addEventListener( MouseEvent.CLICK, click );
	}
	
	public function dispose () : void
	{
		_sprite.removeEventListener( MouseEvent.CLICK, click );
		_sprite = null;
		invoker = null;
	}

	public function get mouseCatcher () : Sprite { return _sprite; }
}
