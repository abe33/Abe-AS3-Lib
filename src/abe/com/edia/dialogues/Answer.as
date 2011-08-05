/**
 * @license 
 */
package  abe.com.edia.dialogues
{

	/**
	 * La classe <code>Answer</code> représente une réponse
	 * à une question dans le système de dialogue.
	 * <p>
	 * Rien ne différencie une réponse d'une parole classique,
	 * la seule différence est que les réponses peuvent être
	 * marquées comme déja choisie par l'utilisateur.
	 * </p>
	 */
	public class Answer extends Speech
	{
		/**
		 * Une valeur booléenne indiquant si la réponse
		 * a déjà été précédemment choisie par l'utilisateur.
		 * <p>
		 * Cette valeur permet de marquer les réponses précédemment
		 * donné par l'utilisateur si le lecteur de dialogue retombe
		 * sur la question dans sa lecture.
		 * </p>
		 */
		public var chosen : Boolean;
		
		/**
		 * Créer une nouvelle instance de la classe <code>Answer</code>.
		 * 
		 * @param	message		le contenu de cette répnse
		 * @param	speaker		l'auteur de cette parole
		 * @param	nextSpeech	la parole suivante à celle-ci
		 */
		public function Answer( message : String, speaker : String, nextSpeech : Speech = null )
		{
			super( message, speaker, nextSpeech );
		}
	}
}