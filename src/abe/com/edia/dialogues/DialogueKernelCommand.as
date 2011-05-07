/**
 * @license 
 */
package  abe.com.edia.dialogues
{
	import abe.com.mands.Command;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Runnable;
	import abe.com.ponents.actions.AbstractTerminalAction;
	import abe.com.ponents.actions.TerminalAction;
	import abe.com.ponents.monitors.Terminal;
	import abe.com.ponents.monitors.TerminalEvent;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * Permet de tester le moteur de dialogue dans le terminal
	 */
	public class DialogueKernelCommand extends AbstractTerminalAction implements TerminalAction, Command, Runnable
	{	
		public var startSpeech : Speech;
		
		private var kernel : DialogueKernel;
		
		private var terminal : Terminal;
		
		public function DialogueKernelCommand( name : String, command:String, icon : Icon = null, longDescription : String = "", usage:String="", description:String="", startSpeech : Speech = null )
		{
			super( name, icon, longDescription, command, usage, description);
			this.startSpeech = startSpeech;
			this.kernel = new DialogueKernel();
			this.kernel.addEventListener( SpeechEvent.NEW_QUESTION, newQuestion );
			this.kernel.addEventListener( SpeechEvent.NEW_SPEECH, newSpeech );
			this.kernel.addEventListener( SpeechEvent.SPEECH_END, speechEnd );
			this.kernel.addEventListener( SpeechEvent.SPEECH_START, speechStart );
		}
		
		override public function execute( e : Event = null ) : void
		{
			var te : TerminalEvent = e as TerminalEvent;
			terminal = te.terminal;
			
			if( startSpeech == null )
			{
				fireCommandFailed( "Il n'existe aucun message de départ de dialogue pour la commande." );
			}	
			else if( checkSpeechStructure ( startSpeech ) )
			{
				kernel.execute( new SpeechEvent ( "", startSpeech ) );
			}
			else
			{
				fireCommandFailed(  "Une(Des) erreur(s) éxiste(nt) dans la structure du dialogue," +
							   		" veuillez corriger celle(s)-ci avant de relancer la commande" );
			}
		}
		
		public function speechStart ( e : SpeechEvent ) : void
		{
			terminal.echo( "<font color='" + Color.DeepSkyBlue.html + "'>Démarrage du dialogue</font>"  );
		}
		public function speechEnd ( e : SpeechEvent ) : void
		{
			terminal.echo( "<font color='" + Color.DeepSkyBlue.html + "'>Fin du dialogue</font>"  );
			fireCommandEnd();
		}
		public function newSpeech ( e : SpeechEvent ) : void
		{
			printSpeech ( e.speechTarget );
		}
		public function newQuestion ( e : SpeechEvent ) : void
		{
			printQuestion( e.speechTarget as Question );
		}
		public function speechCallback ( s : String ) : void
		{
			kernel.next();
		}
		public function questionCallback ( s : String ) : void
		{
			var quest : Question = kernel.currentSpeech as Question;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var answers : Array = []; }
			TARGET::FLASH_10 { var answers : Vector.<Answer> = new Vector.<Answer>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var answers : Vector.<Answer> = new Vector.<Answer>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/

			var l : Number = answers.length;
			
			for(var i:Number = 0; i<l;i++)
			{
				if( s.toLocaleLowerCase() == answers[i].message.toLocaleLowerCase() )
				{
					kernel.answer( answers[ i ] );
					return;
				}
			}
			terminal.input( getAuthor( answers[0].speaker ), questionCallback );	
		}
		
		private var _numQuestions : Number;
		private var _numAnswers : Number;
		private var _numNamedEnds : Number;
		private var _numUnnamedEnds : Number;
		private var _numSpeeches : Number;
		private var _checked : Dictionary;
		private var _errorOccured : Boolean;

		private function checkSpeechStructure ( start : Speech ) : Boolean
		{
			_numQuestions = _numAnswers = _numSpeeches = _numNamedEnds = _numUnnamedEnds = 0;
			_checked = new Dictionary();
			_errorOccured = false;
			
			browseSpeeches( start );
			
			terminal.echo( "<font color='" + Color.DeepSkyBlue.html + "'>Statistiques : </font>" );
			terminal.echo( "Nombre d'éléments   	: " + _numSpeeches );
			terminal.echo( "Nombre de questions 	: " + _numQuestions );
			terminal.echo( "Nombre de réponses  	: " + _numAnswers );
			terminal.echo( "Nombre de fins nommées  : " + _numNamedEnds );
			terminal.echo( "Nombre de fins anonymes : " + _numUnnamedEnds );
			
			return !_errorOccured;
		}

		private function browseSpeeches ( start : Speech ) : void
		{
			if( _checked [ start ] != null )
				return;
			else
			{				
				_numSpeeches++;
				_checked [ start ] = true;
			}
					
			if( start is Question )
			{
				var q : Question = start as Question;
				var l : Number = q.answers.length;
				
				_numQuestions++;
				
				if( l == 0 )
				{
					printError( "Une question ne possède pas de réponses :\n'" + start.message + "'" );
					_errorOccured = true;
				}
				else
				{
					for( var i : Number = 0; i < l; i++ )
					{
						browseSpeeches( q.answers[ i ] );
					}
				}
			}
			else if ( start is EndSpeech )
			{
				_numNamedEnds++;	
			}
			else if ( start is Answer )
			{
				_numAnswers++;
				
				if( start.nextSpeech )
					browseSpeeches( start.nextSpeech );
				else
				{
					printWarning(	"Une réponse ne possède pas de suite :\n'" + start.message + "'" );
					_numUnnamedEnds++;
				}
			}
			else
			{
				 if( start.nextSpeech )
					browseSpeeches( start.nextSpeech );
				else
				{
					_numUnnamedEnds++;
				}
			}
		}

		public function printWarning ( s : String ) : void
		{
			 terminal.echo( "<font color='" + Color.DarkOrange.html + "'><u>WARNING</u></font> " + s ); 
		}
		public function printError ( s : String ) : void
		{			
			 terminal.echo( "<font color='" + Color.OrangeRed.html + "'><u>ERROR</u></font> " + s ); 
		}

		public function printSpeech ( s : Speech ) : void
		{
			terminal.echo( getAuthor( s.speaker ) + s.message );		
			terminal.input( "&gt; ", speechCallback );
		}
		public function printQuestion ( quest : Question ) : void
		{
			terminal.echo( getAuthor( quest.speaker ) + quest.message );
			terminal.echo( "\n<font color='" + Color.GreenYellow.html + "'>" + getAnswers( quest.answers ) + "</font>\n" );	
			terminal.input( getAuthor( quest.answers[0].speaker ), questionCallback );	
		}
		public function printAnswers ( quest : Question ) : void
		{
			terminal.echo( "\n<font color='" + Color.GreenYellow.html + "'>" + getAnswers( quest.answers ) + "</font>\n" );	
			
			terminal.input( getAuthor( quest.answers[0].speaker ), questionCallback );	
		}
		public function getAuthor ( s : String ) : String
		{
			return "<b>" + s + "</b> : ";
		}
		public function getAnswers ( a : Object ) : String
		{
			var s : String = "";
			var l : Number = a.length;
			
			for(var i:Number = 0; i < l;i++ )
			{
				if( i > 0 )
					s += ", ";
	
				s += a[i].message;
			}
			
			return s ;	
		}
	}
}	