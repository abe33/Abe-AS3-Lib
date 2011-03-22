package  
{
	import abe.com.mon.logs.LogEvent;
	import abe.com.mon.logs.Log;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * @author cedric
	 */
	public class AbeLibTestRunnerText extends Sprite 
	{
		private var _txt : TextField;
		private var _uiListener : TextRunner;

		public function AbeLibTestRunnerText ()
		{
			_txt = new TextField();
			_uiListener = new TextRunner(_txt);
			var core : FlexUnitCore = new FlexUnitCore();
			core.addListener( _uiListener );
			
			_txt.width = stage.stageWidth;
			_txt.height = stage.stageHeight;			addChild(_txt);
			Log.getInstance().addEventListener(LogEvent.LOG_ADD, logAdd );
			
			core.run( AbeLibTestSuite );
		}
		private function logAdd (event : LogEvent) : void 
		{
			_txt.appendText(event.msg +"\n");
		}
	}
}

import org.flexunit.runner.IDescription;
import org.flexunit.runner.Result;
import org.flexunit.runner.notification.Failure;
import org.flexunit.runner.notification.IRunListener;

import flash.text.TextField;

internal class TextRunner implements IRunListener
{
	private var _txt : TextField;

	public function TextRunner ( txt : TextField ) 
	{
		_txt = txt;
	}
	public function testRunStarted (description : IDescription) : void
	{
	}
	public function testRunFinished (result : Result) : void
	{
		_txt.appendText( "test run finished : " + result.successful + "\n" );
	}
	public function testStarted (description : IDescription) : void
	{
		//_txt.appendText( "test started : " + description.displayName + "\n" );
	}
	public function testFinished (description : IDescription) : void
	{
		//_txt.appendText( "test finished : " + description.displayName  + "\n" );
	}
	public function testFailure (failure : Failure) : void
	{
		_txt.appendText( "test failure : " + failure.message+ "\n" );
	}
	public function testAssumptionFailure (failure : Failure) : void
	{
		_txt.appendText( "test assumption failure : " + failure.message+ "\n" );
	}
	public function testIgnored (description : IDescription) : void
	{
		_txt.appendText( "test ignored : " + description.displayName+ "\n" );
	}
}