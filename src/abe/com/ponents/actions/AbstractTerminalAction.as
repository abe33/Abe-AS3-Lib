/**
 * @license 
 */
package abe.com.ponents.actions
{
    import abe.com.mands.Command;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.StringUtils;
    import abe.com.patibility.lang._;
    import abe.com.ponents.skinning.icons.Icon;
	
	/**
	 * Classe de base pour les commandes spécifiques à un usage dans le <code>Terminal</code>.
	 * <p>
	 * Il suffit généralement d'étendre cette classe et de redéfinir la méthode <code>execute</code>
	 * pour créer une commande de terminal concrète.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class AbstractTerminalAction extends AbstractAction implements TerminalAction, Command, Runnable
	{
		/**
		 * Une chaîne de caractères contenant la documentation de la commande de terminal.
		 */
		protected var _documentation : String;
		/**
		 * Une chaîne de caractères décrivant l'utilisation de la commande.
		 */
		protected var _usage : String;
		/**
		 * Un chaîne de caractères contenant la commande à éxécuter.
		 */
		protected var _command : String;
		/**
		 * Un vecteur contenant les différentes options de la commandes.
		 */
		protected var _optionsList : Vector.<TerminalActionOption>;
		
		/**
		 * Constructeur de la classe <code>AbstractTerminalAction</code>.
		 * 
		 * @param name				nom de la commande
		 * @param icon				icône de la commande
		 * @param longDescription	description de la commande
		 * @param command			alias de la commande à utiliser dans le terminal
		 * @param usage				chaîne décrivant les utilisations de la commande
		 * @param documentation		chaîne décrivant le comportement de la commande
		 * @param optionsList		vecteur d'options pour la commande
		 * @param accelerator		raccourcis clavier de la commande
		 */
		public function AbstractTerminalAction(  name : String = "",
												 icon : Icon = null,
												 longDescription : String = "", 
												 command : String = "", 
												 usage : String = "", 												 documentation : String = "", 
												 optionsList : Vector.<TerminalActionOption> = null,
												 accelerator : KeyStroke = null )
		{
			super( name, icon, longDescription, accelerator );
			this._command = command;
			this._usage = usage;
			this._documentation = documentation;
			this._optionsList = optionsList ? optionsList : new Vector.<TerminalActionOption> ();
		}
		/**
		 * @inheritDoc
		 */
		public function get documentation () : String
		{
			return _documentation;
		}
		/**
		 * @inheritDoc
		 */
		public function get usage () : String
		{
			return _usage;
		}
		/**
		 * @inheritDoc
		 */
		public function get command () : String
		{
			return _command;
		}
		/**
		 * @inheritDoc
		 */
		public function get optionsList () : Vector.<TerminalActionOption>
		{
			return _optionsList;
		}
		/**
		 * Renvoie un objet contenant les paires <code>nom:valeur</code>
		 * d'options transmises à la commande lors d'une
		 * saisie en ligne de commande.
		 * <p>
		 * La fonction peut traiter des chaînes formées de cette
		 * façon : 
		 * <listing>commande valeur</listing>
		 * <listing>commande -option valeur</listing>
		 * <listing>commande valeur -option valeur</listing>
		 * <listing>commande -option1 valeur1 valeur2 -option2 valeur</listing>
		 * </p>
		 * <p>
		 * La valeur spécifié directement après le nom de la commande sera enregistrée
		 * dans l'objet à l'index <code>value</code>.
		 * </p>
		 * @param	s	les options de la ligne de commande
		 */
		public function parseOptions( s : String ) : Object
		{
			var o : Object = {};
			o.length = 0;
			var regExp : RegExp = /(-[^\s]+)?([^\-]+)?/gi;
			var regReplace : Function = function( ... match ):String 
			{
				o.length++;
				var key : String = match[ 1 ];
				var value : String = StringUtils.trim( match[ 2 ] );
				
				if( value.length == 0 )
				{
					o[ key ] = null;
				}
				else if( key.length == 0 )
				{
					o[ "value" ] = value;
				}
				else
				{
					o[ key ] = value.split( /[\s]+/gi );
				}
				return "";
			};
			s.replace( regExp, regReplace );			
			return o;
		}
		/**
		 * Renvoie une chaîne représentant une version simplifiée de l'aide
		 * de la commande. La documentation est tronquée au premier caractère 
		 * <code>.</code> et renvoyée.
		 * 
		 * @param	c	commande dont on souhaite avoir la decription courte
		 * @return	une chaîne formatée contenant la documentation simplifiée
		 */
		protected function formatCommandInfoSummary ( c : TerminalAction ) : String
		{
			return "<b>" + c.command + "</b> : " + c.documentation.split( "." )[0];
		}
		/**
		 * Renvoie une chaîne représentant une version détaillée de l'aide
		 * de la commande. La chaîne contient la documentation complète ainsi
		 * que la liste des usages et des options disponibles.
		 * 
		 * @param	c	commande dont on souhaite avoir la decription complète
		 * @return	une chaîne formatée contenant la documentation complète
		 */
		protected function formatCommandInfoDetails ( c : TerminalAction ) : String
		{
			return _( "<b>-> 'help' command</b><br/><u>Description</u> : <br/> $1<br/><u>Usage(s)</u> : <br/>$2<br/><u>Option(s)</u> : <br/>$3" )
						.replace( "$0", c.command )
						.replace( "$1", c.documentation )
						.replace( "$2", c.usage )
						.replace( "$3", formatTerminalCommandOptions( c ) );
		}
		/**
		 * Renvoie une chaîne représentant la liste des options de cette commande.
		 * 
		 * @param	c	commande dont on souhaite avoir la liste des options
		 * @return	une chaîne formatée contenant la liste des options
		 * 			de la commande
		 */
		protected function formatTerminalCommandOptions ( c : TerminalAction ) : String
		{
			var s : String = "";
			var a : Vector.<TerminalActionOption> = c.optionsList;
			var l : Number = a.length;
			var o : TerminalActionOption;
			
			for( var i : Number = 0; i < l; i++ )
			{
				o = a[ i ];
				if( i != 0 )
					s += "<br/>";
				s +=  "<b>" + o.name + "</b> : " + o.description;
			}
			return s;
		} 
	}
}