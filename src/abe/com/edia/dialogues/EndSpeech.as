/**
 * @license 
 */
package  abe.com.edia.dialogues
{
	/**
	 * La classe <code>EndSpeech</code> identifie une fin possible
	 * dans l'arbre de discussion.
	 * <p>
	 * Les fins d'un arbre de discussion peuvent être identifiés afin
	 * de déclencher des actions spécifiques.
	 * </p>
	 */
	public class EndSpeech extends Speech
	{
		/**
		 * Un identifiant permettant de différencier cette fin
		 * de dialogue des autres fins potentielles.
		 */
		public var endID : String;
		
		/**
		 * Créer une nouvelle instance de la classe <code>EndSpeech</code>.
		 * 
		 * @param	message	le contenu de cette parole
		 * @param	speaker	l'auteur de cette parole
		 * @param	endID	identifiant de cette fin de dialogue
		 */
		public function EndSpeech( message : String, speaker : String, endID : String )
		{
			super(message, speaker, null);
			this.endID = endID;
		}
	}
}