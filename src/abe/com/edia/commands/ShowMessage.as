/**
 * @license
 */
package abe.com.edia.commands 
{
	import abe.com.motion.ImpulseEvent;
	import abe.com.edia.text.AdvancedTextField;
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mands.Timeout;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.Impulse;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class ShowMessage extends AbstractCommand implements Suspendable, Command, Runnable
	{
		protected var _txt : AdvancedTextField;
		protected var _message : String;
		protected var _commandEndTimeout : Number;
		protected var _args : Array;
		protected var _timeout : Timeout;
		protected var _clickCatcher : Sprite;
		protected var _autoHideLaunch : Boolean;
		
		static public const SHOW_EFFECT_ID : String = "show";		static public const HIDE_EFFECT_ID : String = "hide";
		
		public var isActive : Boolean;

		public function ShowMessage ( message : String, commandEndTimeout : Number = 3000, autoHideLaunch : Boolean = false, ... args )
		{
			_message = message;
			_commandEndTimeout = commandEndTimeout;
			_autoHideLaunch = autoHideLaunch;
			_args = args;
			_txt = new AdvancedTextField();
			
			if( _commandEndTimeout != -1 )
				_timeout = new Timeout( clearSpeech, _commandEndTimeout );
		}

		override public function execute (e : Event = null) : void
		{
			showMessage();
		}
		
		protected function formatMessage ( str : String ) : String
		{
			return str;
		}
		
		protected function setupBeforeAffectation () : void
		{
			_txt.wordWrap = true;
			_txt.autoSize = "left";
			_txt.multiline = true;
			_txt.width = StageUtils.stage.stageWidth-40;
		}
		protected function setupAfterAffectation () : void
		{
			var bb : Rectangle = _txt.getBounds( ToolKit.mainLevel );
			
			_txt.x = 20;
			_txt.y = ( StageUtils.stage.stageHeight - _txt.height ) - bb.y - 20;
			
			//_txt.filters = [ new DropShadowFilter( 0, 0, 0, 1, 5, 5, 1, 2, true ) ];
			//_txt.graphics.lineStyle( 0,0 );
			_txt.graphics.beginFill( 0,.5);
			_txt.graphics.drawRoundRect(-10, -10, StageUtils.stage.stageWidth - 20, bb.height+20, 10, 10 );
			_txt.graphics.endFill();
		}
		protected function showMessage () : void
		{	
			_clickCatcher = new Sprite();
			_clickCatcher.graphics.beginFill(0,0);
			_clickCatcher.graphics.drawRect(0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
			_clickCatcher.graphics.endFill();
			
			ToolKit.popupLevel.addChild( _clickCatcher);
			ToolKit.popupLevel.addChild( _txt );
			
			isActive = true;
			
			setupBeforeAffectation();
			_txt.htmlText = formatMessage( _message );
			setupAfterAffectation();
			
			if( _txt.build.effects.hasOwnProperty( HIDE_EFFECT_ID ) )
				_txt.build.effects[HIDE_EFFECT_ID].addEventListener ( Event.COMPLETE, clearSpeech );
				
			if( _txt.build.effects.hasOwnProperty( SHOW_EFFECT_ID ) )
			{
				StageUtils.stage.addEventListener(MouseEvent.CLICK, clickShow);
				
				if( _autoHideLaunch )
					_txt.build.effects[SHOW_EFFECT_ID].addEventListener ( Event.COMPLETE, launchHide );
			}			else
				StageUtils.stage.addEventListener(MouseEvent.CLICK, clickHide);
			
			if( _timeout )
				_timeout.execute();
		}
		
		

		public function clearSpeech ( e : Event = null ) : void
		{
			StageUtils.stage.removeEventListener(MouseEvent.CLICK, clickShow);
			StageUtils.stage.removeEventListener(MouseEvent.CLICK, clickHide);
			
			isActive = false;
			
			if( ToolKit.popupLevel.contains(_clickCatcher) )
				ToolKit.popupLevel.removeChild(_clickCatcher);
				
			if( ToolKit.popupLevel.contains( _txt ) )
				ToolKit.popupLevel.removeChild( _txt );
			
			if( _timeout && _timeout.isRunning() )
				_timeout.stop();
				
			_txt.clear();
			_txt = null;
			_args = null;
			
			fireCommandEnd();
		}
		
		protected function launchHide (event : Event) : void
		{
			if( _txt.build.effects.hasOwnProperty(HIDE_EFFECT_ID) )
				_txt.build.effects[HIDE_EFFECT_ID].start();
		}
		
		public function clickShow( e : MouseEvent ) : void
		{
			if( _txt.build.effects.hasOwnProperty(SHOW_EFFECT_ID) && 
				_txt.build.effects[SHOW_EFFECT_ID].isRunning() )
			{
				_txt.build.effects[SHOW_EFFECT_ID].showAll();
				StageUtils.stage.removeEventListener(MouseEvent.CLICK, clickShow);
				StageUtils.stage.addEventListener(MouseEvent.CLICK, clickHide);
			}
			else if( _txt.build.effects.hasOwnProperty(HIDE_EFFECT_ID))
			{
				_txt.build.effects[HIDE_EFFECT_ID].hideAll();
			}
		}
		public function clickHide( e : MouseEvent ) : void
		{
			if( _txt.build.effects.hasOwnProperty(HIDE_EFFECT_ID) )
				_txt.build.effects[HIDE_EFFECT_ID].hideAll();
			else
				clearSpeech();

			StageUtils.stage.removeEventListener(MouseEvent.CLICK, clickHide );
		}
		
		public function start () : void
		{
			_isRunning = true;
			if( _timeout )
				_timeout.start();
			_txt.start();
		}

		public function stop () : void
		{
			_isRunning = false;
			if( _timeout )
				_timeout.stop();
			_txt.stop();
		}
	}
}
