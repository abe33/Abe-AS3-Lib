package aesia.com.ponents.demos 
{
	import aesia.com.edia.dialogues.Answer;
	import aesia.com.edia.dialogues.DialogueKernelCommand;
	import aesia.com.edia.dialogues.EndSpeech;
	import aesia.com.edia.dialogues.Question;
	import aesia.com.edia.dialogues.Speech;
	import aesia.com.mands.Interval;
	import aesia.com.mands.ParallelCommand;
	import aesia.com.mands.ReversedQueue;
	import aesia.com.mands.Timeout;
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.motion.SingleTween;
	import aesia.com.ponents.monitors.Terminal;
	import aesia.com.ponents.monitors.TerminalActionProxy;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class TerminalDemo extends Sprite 
	{
		private var terminal : Terminal;
		public function TerminalDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			terminal = new Terminal();
			
			
			terminal.addCommand( 
				new TerminalActionProxy( 
					new Timeout( function(...args):void {}, 500 ),
					"timeout", null, 
					"Appelle une fonction après 500ms.",
					"timeout", "timeout", 
					"Appelle une fonction après 500ms." 
				));
			testSpeech();
			testCommands();
			
			terminal.x  = 10;			terminal.y  = 10;
			terminal.size = new Dimension( 330, 380 );
			
			ToolKit.mainLevel.addChild( terminal );
		}

		public function testSpeech () : void
		{
			// 
			var speech1 : Speech = new Speech ( "Hey ! amigo, appuie sur la touche entrée pour passer à la phrase suivante lorsque tu vois le signe &gt;.", "abe");
			var speech2 : Speech = new EndSpeech ( "Bon, ben ciao", "abe", "shortend" );
			var speech3 : Speech = new Speech ( "Très bien, commencons.", "abe" );
			var speech4 : Speech = new Speech ( "Même pas une petite idée ? Tu m'etonne là, essaye encore", "abe" );
			var speech5 : Speech = new Speech ( "Ça aurait pu, mais non, essaye encore.", "abe" );
			var speech6 : Speech = new Speech ( "Bien ! Tes neurones ne sont pas complètement inutiles après tout.", "abe" );
			var speech7 : Speech = new EndSpeech ( "Mais attention, la prochaine fois, ça sera plus difficile !", "abe", "longend" );
			
			var answer1 : Answer = new Answer( "Oui", "me" );
			var answer2 : Answer = new Answer( "Non", "me" );
			var question1 : Question = new Question ( "Ça te dit de discuter avec moi ?\nTu as juste à saisir ta réponse, le parseur est insensible à la casse.", "abe", answer1, answer2 );
			
			var answer3 : Answer = new Answer( "Dunno", "me" );
			var answer4 : Answer = new Answer( "42", "me" );
			var answer5 : Answer = new Answer( "Dieu", "me" );
			var answer6 : Answer = new Answer( "Obiwan Kenobi", "me" );
			var question2 : Question = new Question ( "Quelle est la réponse à la grande question de la vie, de l'univers et de tout le reste ?", "abe", answer3, answer4, answer5, answer6 );
			//var question3 : Question = new Question ( "Ahahaha c'était un piège, t'en était tu douté ?", "abe" );
			
			// on fait les branchements.
			speech1.nextSpeech = question1;
			speech3.nextSpeech = question2;
			speech4.nextSpeech = question2;
			speech5.nextSpeech = question2;
			speech6.nextSpeech = speech7;

			answer1.nextSpeech = speech3;
			answer2.nextSpeech = speech2;
			answer3.nextSpeech = speech4;
			answer4.nextSpeech = speech6;
			answer5.nextSpeech = speech5;
			//answer5.nextSpeech = question3;
			answer6.nextSpeech = speech5;
			terminal.addCommand( new DialogueKernelCommand("speak", "speak",null, "Permet de tester la speech engine", "speak", "", speech1 ) );
		}

		public function testCommands() : void
		{
			var s : Shape = new Shape();
			s.graphics.beginFill( Color.YellowGreen.hexa );
			s.graphics.drawCircle( 0,0,10);
			s.graphics.endFill();
			s.x = 200;
			s.y = 200;
			
			ToolKit.mainLevel.addChild( s );

			var i1 : Interval = new Interval( foo, 1000, 5, "pouet" );
			var i2 : Timeout = new Timeout( foo, 2000, "plop" );
			//var l : LoopCommand = new LoopCommand( new Iteration( new StringIterator( "hello world !!!" ), terminal ), 10 );
			var t1 : SingleTween = new SingleTween( s, "x", 400, 1000 );
			var t2 : SingleTween = new SingleTween( s, "y", 300, 1000 );
			var b : ReversedQueue = new ReversedQueue();
			var p : ParallelCommand = new ParallelCommand();
			
			p.addCommand( t1 );
			p.addCommand( t2 );
			
			b.addCommand( i1 );
			b.addCommand( i2 );
			//b.addCommand( l );
			b.addCommand( p );
			
			b.addEventListener( CommandEvent.COMMAND_END, commandEnd );
			b.addEventListener( CommandEvent.COMMAND_FAIL, commandFailed );
			
			terminal.addCommand( new TerminalActionProxy( b, 
														  "proxy", null,
														  "A TerminalCommandProxy which launch a ReversedQueue with many sub-routines.",
														  "proxy", "proxy",
														  "A TerminalCommandProxy which launch a ReversedQueue with many sub-routines." ) );
		}		
		public function foo( s : String ) : void
		{
			terminal.echo( s );
		}
		public function commandEnd ( e : Event ) : void
		{
			terminal.echo( "command ended" );
		}
		public function commandFailed ( e : Event ) : void
		{
			terminal.echo( "command failed" );
		}
	}
}

import aesia.com.mands.AbstractCommand;
import aesia.com.mands.IterationCommand;
import aesia.com.mands.events.IterationEvent;
import aesia.com.mon.core.Iterator;
import aesia.com.ponents.monitors.Terminal;

import flash.events.Event;

internal class Iteration extends AbstractCommand implements IterationCommand
{
	protected var _iterator : Iterator;
	protected var _terminal : Terminal;
	
	public function Iteration ( i : Iterator, t : Terminal )
	{
		_iterator = i;
		_terminal = t;
	}

	override public function execute(e : Event = null ) : void
	{
		_terminal.echo( ( e as IterationEvent ).iteration + " : " + ( e as IterationEvent ).value );
	}
	public function iterator() : Iterator
	{
		return _iterator;
	}
}
