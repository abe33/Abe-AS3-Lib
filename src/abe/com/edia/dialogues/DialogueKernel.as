/**
 * @license 
 */
package  abe.com.edia.dialogues
{
	import org.osflash.signals.Signal;
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;

	import flash.events.Event;

	
	/**
	 * La classe <code>DialogueKernel</code> permet de lire une structure 
	 * de dialogue et de diffuser des évènements à d'éventuels écouteurs
	 * qui, eux, se chargeront de gérer l'affichage et les interactions
	 * avec l'utilisateur.
	 * <p>
	 * La classe <code>DialogueKernel</code> implémente l'interface <code>Command</code>,
	 * ce qui signifie qu'elle peut être utilisée comme n'importe qu'elle autre commande
	 * au sein de macro-commandes.
	 * </p>
	 * @author Cédric Néhémie
	 * @example
	 * <listing>// instanciation de tout les membres
	 * var speech0 : Question = new Question ( "Salut tu veux répondre à mes questions ?", "abe" );
	 * var speech1 : Answer = new Answer ( "Oui, bien sûr.", "john doe" );
	 * var speech2 : Answer = new Answer ( "Oui.", "john doe" );
	 * var speech3 : Answer = new Answer ( "Non mais tu rêve !", "john doe" );
	 * var speech4 : Speech = new Speech ( "Ok cool, bon avant de commencer je vais te racont...", "abe" );
	 * var speech5 : Answer = new Answer ( "Non.", "john doe" );
	 * var speech6 : Question = new Question ( "Tu veux arrêter ?", "abe" );
	 * var speech7 : Speech = new Speech ( "Allez, ciao", "abe" );
	 * 
	 * // liaisons de tout les membres
	 * speech6.answers.push( speech5 );
	 * speech6.answers.push( speech2 );
	 * speech4.nextSpeech = speech6;
	 * speech1.nextSpeech = speech4;
	 * speech0.answers.push( speech3 );
	 * speech0.answers.push( speech1 );
	 * speech2.nextSpeech = speech7;
	 * speech3.nextSpeech = speech7;
	 * speech5.nextSpeech = speech7;
	 * 
	 * // définition du dialogue de départ
	 * var startSpeech : Speech = speech0;
	 * 
	 * // création d'un noyeau d'éxécution de dialogue
	 * kernel = new SpeechKernel();
	 * kernel.addEventListener( SpeechEvent.SPEECH_START, speechStart );
	 * kernel.addEventListener( SpeechEvent.SPEECH_END, speechEnd );
	 * kernel.addEventListener( SpeechEvent.NEW_SPEECH, newSpeech );
	 * kernel.addEventListener( SpeechEvent.NEW_QUESTION , newQuestion );
	 * 
	 * // éxécution du dialogue
	 * kernel.execute( new SpeechEvent( "execute", startSpeech ) );</listing>
	 */
	public class DialogueKernel extends AbstractCommand implements Command, Runnable
	{
		private var _currentSpeech : Speech;
		private var _waitingForAnAnswer : Boolean;
        
        public var speechStarted : Signal;
        public var speechEnded : Signal;
        public var speechOccured : Signal;
        public var questionRaised : Signal;

        public function DialogueKernel ()
        {
            speechStarted = new Signal();
            speechEnded = new Signal();
            speechOccured = new Signal();
            questionRaised = new Signal();
        }

        
		/**
		 * Un appel à la méthode <code>execute</code> démarre la séquence de dialogue
		 * de cette instance.
		 * <p>
		 * Un évènement <code>SpeechEvent.SPEECH_START</code> est diffusé, suivi
		 * par un évènement <code>SpeechEvent.NEW_SPEECH</code>.
		 * </p>
		 * 
		 * @param	e	un objet évènement optionnel pour un usage en tant qu'écouteur
		 */
		override public function execute( e : Event = null ) : void
		{
			if( _isRunning )
				return;

			var evt : SpeechEvent = e as SpeechEvent;
			
			_currentSpeech = evt.speechTarget;
			_waitingForAnAnswer = false;
			
			fireSpeechStart();
			handleSpeech( _currentSpeech );
			
			_isRunning = true;
		}
		/**
		 * Accès à l'objet <code>Speech</code> actuellement traité
		 * par cette instance de la classe <code>DialogueKernel</code>.
		 */
		public function get currentSpeech () : Speech
		{
			return _currentSpeech;
		}
		
		/**
		 * Fait pointer l'instance courante vers le prochain objet
		 * <code>Speech</code>. Celui-ci est récupéré via la propriété
		 * <code>nextSpeech</code> de l'objet <code>Speech</code>
		 * courant.
		 * <p>
		 * Si l'objet <code>Speech</code> courant n'a pas de prochaine
		 * parole, ou qu'il s'agit d'une instance de la classe <code>EndSpeech</code>
		 * l'instance courante diffuse un évènement <code>SpeechEvent.SPEECH_END</code>.
		 * </p><p>
		 * Si la parole suivante est une instance de la classe <code>Question</code>
		 * l'instance courante diffuse un évènement <code>SpeechEvent.NEW_QUESTION</code>
		 * et se place en attente d'une réponse. Tant qu'un appel à la méthode
		 * <code>answer</code> n'aura pas été réalisé, la méthode <code>next</code>
		 * n'agira pas.
		 * </p><p>
		 * Autrement, l'instance courante diffuse un évènement 
		 * <code>SpeechEvent.NEW_SPEECH</code>.
		 * </p>
		 */
		public function next () : void
		{
			if( !_isRunning || _waitingForAnAnswer )
				return;
				
			if( !isEndSpeech( _currentSpeech ) )
			{
				_currentSpeech = _currentSpeech.nextSpeech;
				handleSpeech( _currentSpeech );
			}
		}
		/**
		 * Met fin à la phase d'attente d'une réponse de l'instance
		 * courante. La réponse passée en argument est alors définie
		 * en tant que parole courante, et un évènement 
		 * <code>SpeechEvent.NEW_SPEECH</code> est alors diffusé.
		 * 
		 * @param	answer	la réponse choisie par l'utilisateur,
		 * 					représenté par une instance de la classe
		 * 					<code>Answer</code>
		 */
		public function answer ( answer : Answer ) : void
		{
			if( !_isRunning || !_waitingForAnAnswer ) 
				return;	
			
			_waitingForAnAnswer = false;
			_currentSpeech = answer.nextSpeech;
			handleSpeech( _currentSpeech );
		}
		/**
		 * Renvoie <code>true</code> et diffuse un évènement
		 * <code>SpeechEvent.SPEECH_END</code> si la parole
		 * passé en paramètre n'a pas de parole suivante ou
		 * est une instance de la classe <code>EndSpeech</code>.
		 * 
		 * @param	s	la parole à tester
		 * @return	<code>true</code> si la parole passé en paramètre
		 * 			n'a pas de parole suivante ou est une instance 
		 * 			de la classe <code>EndSpeech</code>
		 */
		protected function isEndSpeech( s : Speech ) : Boolean
		{			
			if( s is EndSpeech || s.nextSpeech == null )
			{
				fireSpeechEnd( s );
				_commandEnded.dispatch( this );
				return true;
			}
			else return false;
		}
		/**
		 * Prend en charge une parole, du moment où celle-ci
		 * n'est pas considérée comme une parole de fin, tel
		 * que défini dans la méthode <code>isEndSpeech</code>.
		 * <p>
		 * Si la parole suivante est une instance de la classe <code>Question</code>
		 * l'instance courante diffuse un évènement <code>SpeechEvent.NEW_QUESTION</code>
		 * et se place en attente d'une réponse. Tant qu'un appel à la méthode
		 * <code>answer</code> n'aura pas été réalisé, la méthode <code>next</code>
		 * n'agira pas.
		 * </p><p>
		 * Autrement, l'instance courante diffuse un évènement 
		 * <code>SpeechEvent.NEW_SPEECH</code>.
		 * </p>
		 * 
		 * @param	s	la parole à traiter
		 */
		protected function handleSpeech( s : Speech ) : void
		{
			if( s is Question )
			{
				_waitingForAnAnswer = true;
				fireNewQuestion( s as Question );
			}
			else
			{
				fireNewSpeech( s );
			}
		}
		/**
		 * Notifie les éventuels écouteurs qu'un dialogue vient de commencer.
		 * Un évènement de type <code>SpeechEvent.SPEECH_START</code>
		 * est diffusé par la classe. 
		 */
		protected function fireSpeechStart () : void
		{
			speechStarted.dispatch(this);
		}
		/**
		 * Notifie les éventuels écouteurs qu'un dialogue vient de se terminer.
		 * Un évènement de type <code>SpeechEvent.SPEECH_START</code>
		 * est diffusé par la classe. 
		 * 
		 * @param	endSpeech	l'objet <code>Speech</code> ayant déclenché
		 * 						l'évènement.
		 */
		protected function fireSpeechEnd ( s : Speech ) : void
		{
            speechEnded.dispatch(this,s);
		}
		/**
		 * Notifie les éventuels écouteurs qu'une nouvelle parole vient d'être
		 * prononcé. Un évènement de type <code>SpeechEvent.NEW_SPEECH</code>
		 * est diffusé par la classe. 
		 * 
		 * @param	endSpeech	l'objet <code>Speech</code> ayant déclenché
		 * 						l'évènement.
		 */
		protected function fireNewSpeech( s : Speech ) : void
		{
			speechOccured.dispatch(this,s);
		}
		/**
		 * Notifie les éventuels écouteurs qu'une nouvelle question vient d'être
		 * formulée. Un évènement de type <code>SpeechEvent.NEW_QUESTION</code>
		 * est diffusé par la classe. 
		 * 
		 * @param	endSpeech	l'objet <code>Question</code> ayant déclenché
		 * 						l'évènement.
		 */
		protected function fireNewQuestion ( s : Question ) : void
		{
			questionRaised.dispatch(this,s);
		}
	}
}
