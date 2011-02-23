/**
 * @license
 */
package abe.com.ponents.monitors
{
	import abe.com.mands.Command;
	import abe.com.mands.events.CommandEvent;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.TerminalAction;
	import abe.com.ponents.actions.TerminalActionOption;
	import abe.com.ponents.text.TextArea;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	/**
	 * Un objet <code>Terminal</code> peut être placé sur la scène et permet
	 * d'éxécuter des lignes de commandes. Chaque instance de <code>Terminal</code>
	 * peut avoir un ensemble de commandes différentes. Seules les commandes suivantes
	 * sont disponibles sur toutes les instances de la classe <code>Terminal</code> :
	 * <ul>
	 * <li><code>clear</code> : une instance de <code>ClearCommand</code> est utilisé
	 * pour néttoyer le terminal.</li>
	 * <li><code>help</code> : une instance de <code>HelpCommand</code> est utilisé
	 * pour afficher la liste de toutes les commandes disponibles.</li>
	 * </ul>
	 * <p>
	 * La classe <code>Terminal</code> possède les contrôles suivants :
	 * </p>
	 * <ul>
	 * <li>Une auto-complétion des commandes et des options de commandes est disponible
	 * à l'aide de la touche <code>Keys.TAB</code>. Si plusieurs résultats sont possibles
	 * le terminal affiche automatiquement la liste des possibilités.</li>
	 * <li>Un historique des dernières commandes saisies est disponible à l'aide des touches
	 * <code>Keys.UP</code> et <code>Keys.DOWN</code> qui parcourent l'historique
	 * respectivement du présent au passé et du passé au présent.</li>
	 * <i>L'éxécution des commandes est réalisée par l'utilisation de la touche
	 * <code>Keys.ENTER</code>.</i>
	 * <li>Un mécanisme permettant aux commandes éxécutées d'effectuer des requêtes
	 * à l'utilisateur et de récupérer les informations saisies.</li>
	 * <li>Une limite dans le nombre de messages afficher. Passé cette limite les messages
	 * les plus anciens sont supprimés. Dans cette version, un message peut faire plusieurs
	 * lignes, à la différences des terminaux UNIX.</li>
	 * </ul>
	 * <p>
	 * La saisie dans un terminal est désactivé pendant toute l'éxécution d'une commande,
	 * sauf si celle-ci initie un dialogue de saisie.
	 * </p>
	 */
	[Skinable(skin="Terminal")]
	[Skin(define="Terminal",
		  inherit="Text",

		  state__all__background="new abe.com.ponents.skinning.decorations::SimpleFill ( new abe.com.mon.utils::Color( 0x2E, 0x34, 0x36 ) )",
		  state__all__textColor="new abe.com.mon.utils::Color ( 0xD3, 0xD7, 0xCF )",
		  state__all__format="new flash.text::TextFormat ('Monospace', 11)"
	)]
	final public class Terminal extends TextArea
	{
		/**
		 * Valeur par défaut des messages de saisie.
		 */
		static public const INPUT : String = "~$ ";
		/**
		 * Taille de l'historique des commandes éxécutées des terminaux.
		 */
		static public var commandsLimit : Number = 20;
		/**
		 * Taille la limite sur le nombre de messages affichés.
		 */
		static public var logsLimit : Number = 500;

		// tableau des messages affichés
		protected var _logs : Vector.<String>;

		// index du charriot dans le champs de texte
		protected var _carretIndex : Number;
		// index minimum pour la modification du champs de texte
		protected var _carretLimit : Number;

		// objet contenant les paires alias:commande pour ce terminal
		protected var _commands : Object;
		// tableau contenant tout les alias des commandes de ce terminal
		protected var _commandsTriggers : Vector.<String>;
		// la commande en court d'éxécution
		protected var _currentCommand : TerminalAction;
		// dernières commandes éxécutées
		protected var _lastCommands : Vector.<String>;
		// index dans le tableau des dernières commandes éxécutées
		protected var _commandIndex : Number;

		// est-on dans une phase de saisie
		protected var _inputRequired : Boolean;
		// fonction à appeler en fin de saisie
		protected var _inputCallback : Function;

		/**
		 * Créer une nouvelle instance de la classe <code>Terminal</code>.
		 */
		public function Terminal ()
		{
			super();
			styleKey = "Terminal";
			_label.selectable = true;
			_label.multiline = true;
			_label.wordWrap = true;
			_label.alwaysShowSelection = true;

			allowInput = false;

			_commands = {};
			_commandIndex = -1;
			_commandsTriggers = new Vector.<String>( );
			_lastCommands = new Vector.<String>();
			_logs = new Vector.<String>();
			_carretLimit = 0;
			_size = new Dimension(100,100);
			_inputRequired = false;

			addCommand( new TerminalHelpAction() );
			addCommand( new TerminalClearAction() );

			_label.addEventListener( Event.CHANGE, change );
			_label.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
			_label.addEventListener( KeyboardEvent.KEY_UP, keyUp );
			_label.addEventListener( MouseEvent.MOUSE_UP, textMouseUp );

			input( INPUT );
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				createContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected function createContextMenu () : void
		{
			addNewContextMenuItemForGroup( _("Clear logs"), "clear", clear, "logs" );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		override public function keyFocusChange (e : FocusEvent) : void
		{
			e.preventDefault();
		}

		override public function set value (val : *) : void
		{
			_label.htmlText = "";
			super.value = val;
		}

		override public function registerValue (e : Event = null) : void
		{}


		/**
		 * Initie une phase de saisie. Le charriot sera précédé de <code>message</code>
		 * et une fois la saisie valider avec la touche <code>Keys.ENTER</code>
		 * la fonction <code>callback</code> sera appellé avec le contenu de la saisie.
		 *
		 * @param	message		message précédant la saisie
		 * @param	callback	fonction à appeler en validation
		 */
		public function input( message : String, callback : Function = null ) : void
		{
			echo( message );
			_inputCallback = callback;
			_commandIndex = -1;
			_inputRequired = true;
			_carretIndex = _label.length - 1;
			updateSelection();
		}
		/**
		 * Interrompt une saisie en court.
		 */
		public function endInput () : void
		{
			_inputRequired = false;
		}
		/**
		 * Ajoute une commande à ce terminal. Si la commande ajouté
		 * porte le même nom qu'une commande précédemment enregistré
		 * celle-ci sera supprimée au profit de la nouvelle commande.
		 *
		 * @param	command	commande à ajouter au terminal
		 */
		public function addCommand ( command : TerminalAction ) : void
		{
			if( _commands[ command.command ] != null )
				removeCommand( _commands[ command.command ] );

			_commands[ command.command ] = command;
			if ( _commandsTriggers.indexOf( command.command ) == -1 )
				_commandsTriggers.push( command.command );
		}
		/**
		 * Supprime une commande de ce terminal.
		 *
		 * @param	command	commande à supprimer du terminal
		 */
		public function removeCommand ( command : TerminalAction ) : void
		{
			if( _commands.hasOwnProperty( command.command ) )
				delete _commands[ command.command ];
			if ( _commandsTriggers.indexOf( command.command ) != -1 )
				_commandsTriggers.splice( _commandsTriggers.indexOf( command.command ), 1 );
		}
		/**
		 * Renvoie un objet contenant les paires alias:commande
		 * des commandes enregistrées dans ce terminal.
		 *
		 * @return	un objet contenant les paires alias:commande
		 * 			des commandes enregistrées dans ce terminal
		 */
		public function getCommands () : Object
		{
			return _commands;
		}
		/**
		 * Efface le contenu de ce terminal et relance une phase de saisie.
		 */
		public function clear(... args ) : void
		{
			_logs = new Vector.<String>;
			printLogs();
			input( INPUT );
		}
		/**
		 * Affiche un message dans le terminal. Le terminal
		 * accecpte le code HTML dans les messages.
		 *
		 * @param	str	messages à afficher dans le terminal
		 */
		public function echo ( str : String ) : void
		{
			_logs.push( str );

			if( _logs.length > logsLimit )
				_logs.shift();

			if( displayed )
				printLogs();
		}

		/**
		 * @private
		 */
		override public function set enabled (b : Boolean) : void
		{
			_label.mouseEnabled = b;
			_scrollbar.enabled = b;

			super.enabled = b;
		}

		/*------------------------------------------------------------------------
		 *	PROTECTED MEMBERS
		 *----------------------------------------------------------------------*/
		/**
		 * Affiche tout les messages, sauvegardés par le terminal, dans le champs de texte.
		 */
		protected function printLogs () : void
		{
			value = _logs.join("\n") + " ";
			_carretLimit = _label.length-1;
			_label.scrollV = _label.maxScrollV;
			_scrollbar.updateKnob();
			//_label.setTextFormat( _label.defaultTextFormat, _carretLimit, _carretLimit+1 );
		}

		/**
		 * Enregistre l'instance courante comme écouteur pour les évènements
		 * diffusé par la commande <code>c</code> passée en paramètre.
		 * <p>
		 * La fonction s'enregistre pour les évènements suivant :
		 * </p>
		 * <ul>
		 * <li><code>CommandEvent.COMMAND_END</code> :
		 * la fonction réceptrice est <code>commandEnd</code></li>
		 * <li><code>CommandEvent.COMMAND_FAIL</code> :
		 * la fonction réceptrice est <code>commandFailed</code></li>
		 * <li><code>CommandEvent.COMMAND_CANCEL</code> :
		 * la fonction réceptrice est <code>commandCancelled</code>.
		 * <p>
		 * Cet évènement est écouté uniquement si <code>c</code> implémente
		 * l'interface <code>Cancelable</code>.</p></li>
		 * </ul>
		 * @param	c	commande à laquelle on souhaite s'enregistrer
		 */
		protected function registerToCommandEvents ( c : Command ) : void
		{
			c.addEventListener( CommandEvent.COMMAND_END, commandEnd );
			c.addEventListener( CommandEvent.COMMAND_FAIL, commandFailed );

			if( c is Cancelable )
				c.addEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}
		/**
		 * Enlève l'instance courante de la liste des écouteurs pour la commande
		 * <code>c</code> passée en paramètre.
		 * <p>
		 * La fonction réalise la suppression des écouteurs enregistrés par la
		 * fonction <code>registerToCommandEvents</code>.
		 * </p>
		 * @param	c	commande à laquelle on souhaite se désinscrire
		 */
		protected function unregisterToCommandEvents ( c : Command ) : void
		{
			c.removeEventListener( CommandEvent.COMMAND_END, commandEnd );
			c.removeEventListener( CommandEvent.COMMAND_FAIL, commandFailed );

			if( c is Cancelable )
				c.removeEventListener( CommandEvent.COMMAND_CANCEL, commandCancelled );
		}

		/*------------------------------------------------------------------------
		 *	PRIVATE MEMBERS
		 *----------------------------------------------------------------------*/
		/*
		 * Intercepte l'évènement de fin d'éxécution de la commande courante.
		 *
		 * @param	e	évènement de fin de la commande courante
		 */
		private function commandEnd ( e : Event ) : void
		{
			unregisterToCommandEvents( _currentCommand );
			input( INPUT );
			checkMissingEndLineSpace ();
		}
		/*
		 * Intercepte l'évènement d'échec dans l'éxécution de la commande courante.
		 *
		 * @param	e	évènement de la commande courante
		 */
		private function commandFailed ( e : Event ) : void
		{
			unregisterToCommandEvents( _currentCommand );
			echo( (e as ErrorEvent).text );
			input( INPUT );
		}
		/*
		 * Intercepte l'évènement d'annulation d'éxécution de la commande courante.
		 *
		 * @param	e	évènement de la commande courante
		 */
		private function commandCancelled ( e : Event ) : void
		{
			unregisterToCommandEvents( _currentCommand );
			input( INPUT );
		}
		/*
		 * Notifiée lorsque le terminal est ajouté à la scène
		 *
		 * @param	e	évènement diffusé
		 */
		override public function addedToStage( e : Event ) : void
		{
			super.addedToStage( e );
			printLogs ();
		}

		/*
		 * Notifiée lorsqu'une touche est pressée dans le terminal.
		 *
		 * @param	e	<code>KeyboardEvent</code> contenant les
		 * 				informations de la touche
		 */
		private function keyDown ( e : KeyboardEvent ) : void
		{
			if( isEditable () )
				inputHandler ( e.keyCode, e.ctrlKey, e.shiftKey, e.charCode );
		}
		/*
		 * Notifiée lorsqu'une touche est relachée dans le terminal.
		 *
		 * @param	e	<code>KeyboardEvent</code> contenant les
		 * 				informations de la touche
		 */
		private function keyUp ( e : KeyboardEvent ) : void
		{
			if( !isMultiSelection () )
				updateSelection();
		}
		/*
		 * Notifiée lorsque le champs de texte change.
		 *
		 * @param	e	évènement diffusé par le champs de texte
		 */
		private function change ( e : Event ) : void
		{
			trimEndNewLine ();
		}
		/*
		 * Notifiée lorsque la souris est relachée dans le terminal.
		 *
		 * @param	e	<code>MouseEvent</code> contenant les
		 * 				informations de la souris
		 */
		private function textMouseUp ( e : MouseEvent ) : void
		{
			if( isEditable() )
			{
				_carretIndex = _label.caretIndex;

				if( _carretIndex >= _label.length )
					_carretIndex = _label.length - 1;
				else if( _carretIndex <= _carretLimit )
					_carretIndex = _carretLimit;

				updateSelection();
			}
			else
			{
				if( !isMultiSelection () )
				{
					_carretIndex = _label.caretIndex;

					if( _carretIndex >= _label.length )
						_carretIndex = _label.length - 1;
					else if( _carretIndex <= _carretLimit )
						_carretIndex = _carretLimit;

					updateSelection();
				}
			}
		}
		/*
		 * Gère les comportements du clavier dans le terminal.
		 * Le champs de texte est un champs de texte dynamique,
		 * la saisie est donc gérée entièrement manuellement,
		 * permettant ainsi d'empêcher la modification du contenu
		 * du terminal tout en autorisant la saisie.
		 *
		 * @param	key			code la touche
		 * @param	ctrl		la touche control est-elle enfoncée
		 * @param	shift		la touche shift est-elle enfoncée
		 * @param	charCode	le code du caractère
		 */
		private function inputHandler ( key : Number, ctrl : Boolean, shift : Boolean, charCode : Number = 0 ) : void
		{
			if( key == Keys.ENTER )
			{
				validateInput();
			}
			else if( key == Keys.UP )
			{
				commandHistoryUp ();
			}
			else if( key == Keys.DOWN )
			{
				commandHistoryDown ();
			}
			else if( key == Keys.TAB )
			{
				autoCompleteCommandName();
			}
			else if( key == Keys.LEFT )
			{
				if( ctrl )
				{

				}
				else if( !shift )
				{
					_carretIndex -= 1;

					if( _carretIndex <= _carretLimit )
						_carretIndex = _carretLimit;

					updateSelection();
				}
			}
			else if( key == Keys.RIGHT )
			{
				if( ctrl )
				{

				}
				else if( !shift )
				{
					_carretIndex += 1;

					if( _carretIndex > _label.length - 1 )
						_carretIndex = _label.length - 1;

					updateSelection();
				}
			}
			else if( key == Keys.BACKSPACE )
			{
				if( isMultiSelection () )
				{
					_label.replaceSelectedText( "" );
					checkMissingEndLineSpace ();
				}
				else if( _carretIndex > _carretLimit )
				{
					_carretIndex -= 1;
					_label.replaceText( _carretIndex, _carretIndex + 1, "" );
					updateSelection();
				}
			}
			else if( key == Keys.DELETE )
			{
				if( isMultiSelection () )
				{
					_label.replaceSelectedText( "" );
					checkMissingEndLineSpace ();
				}
				else if( _carretIndex < _label.length -1 )
				{
					_label.replaceText( _carretIndex, _carretIndex + 1, "" );
				}
			}
			else if ( charCode != 0 )
			{
				_label.replaceText( _carretIndex, _carretIndex + 1, String.fromCharCode( charCode ) + _label.text.charAt(_carretIndex) );

				_carretIndex++;
				updateSelection();
			}
			else
			{
			}
		}
		/*
		private function paste () : void
		{
			_label.replaceText( _carretIndex, _carretIndex + 1,
									Clipboard.generalClipboard.getData( ClipboardFormats.TEXT_FORMAT,
																		ClipboardTransferMode.CLONE_PREFERRED ) as String );
		}
		*/

		/*
		 * Met à jour la séléction dans le champs de texte.
		 */
		private function updateSelection() : void
		{
			_label.setSelection( _carretIndex, _carretIndex + 1 );
		}
		/*
		 * Ajoute un espace à la fin du champs de texte afin
		 * de permettre l'affichage du charriot.
		 */
		private function addInputCarret () : void
		{
			_label.appendText( " " );
		}
		/*
		 * Appelée lors de la validation d'une saisie.
		 */
		private function validateInput () : void
		{
			endInput();

			var command : String = StringUtils.trim( _label.text.substr( _carretLimit ) );
			_logs[ _logs.length - 1 ] += command;

			if( _inputCallback != null )
			{
				try
				{
					_inputCallback ( command );
				}
				catch( e : Error )
				{
					echo( "<font color='" + Color.Red.html + "'>La saisie à échouer :</font>&nbsp;" + e.message );
					input( INPUT );
				}
			}
			else
			{
				try
				{
					if( parseCommand ( command ) )
					{
						if( _lastCommands.indexOf( command ) != -1 )
							_lastCommands.splice(  _lastCommands.indexOf( command ), 1 );

						_lastCommands.splice( 0, 0, command );

						if( _lastCommands.length > commandsLimit )
							_lastCommands.pop();
					}
					else
					{
						input( INPUT );
					}
				}
				catch( e : Error )
				{
					echo( "<font color='" + Color.Red.html + "'>La saisie à échouer :</font>&nbsp;" + e.getStackTrace() );
					input( INPUT );
				}
			}
		}
		/*
		 *
		 */
		private function autoCompleteCommandName() : void
		{
			var content : String = StringUtils.trim( _label.text.substr( _carretLimit, _label.length - _carretLimit - 1 ) );
			var a : Vector.<String>;

			// cas d'autocomplétion du nom de la commande
			if( content.indexOf( " " ) == -1 )
			{
				a = _commandsTriggers.filter( function (item:*, ... args ):Boolean
				{
					return ( (item as String).indexOf( content ) == 0 );
				} );

				// il n'y a qu'une entrée qui correspond, on complète automatiquement.
				if( a.length == 1 )
				{
					_label.replaceText( _carretLimit, _label.length, a[ 0 ] );

					addInputCarret();
					_carretIndex = _label.length - 1;
					updateSelection();
				}
				// il y a plusieurs entrées, on les affichent puis on remet la saisie à
				// l'endroit où on en était
				else if( a.length > 1 )
				{
					_logs[ _logs.length - 1 ] += content;
					echo( "<font color='" + Color.GreenYellow.html + "'>" + a.join( ", " ) + "</font>&nbsp;" );
					input( INPUT );
					_label.replaceText( _label.length -1, _label.length, content + " " );
					_carretIndex = _label.length - 1;
					updateSelection();
				}
			}
			// cas d'autocomplétion d'une option
			else
			{
				var rest : Array = content.split( " " );
				var commandTrigger : String = rest[ 0 ];
				var last : String = rest.pop();
				var c : TerminalAction = _commands[ commandTrigger ];
				var str : String = rest.join( " " );

				var b : Vector.<TerminalActionOption> = c.optionsList.filter( function (item:*, ... args ):Boolean
				{
					return ( ( item as TerminalActionOption ).name.indexOf( last ) == 0 );
				} );

				// il n'y a qu'une entrée qui correspond, on complète automatiquement.
				if( b.length == 1 )
				{
					_label.replaceText( _carretLimit, _label.length, str + " " + b[ 0 ].name );

					addInputCarret();
					_carretIndex = _label.length - 1;
					updateSelection();
				}
				// il y a plusieurs entrées, on les affichent puis on remet la saisie à
				// l'endroit où on en était
				else if( b.length > 1 )
				{
					_logs[ _logs.length - 1 ] += content;

					var d : Array = [];
					for( var i : Number = 0; i < b.length; i++ )
						d.push( b[i].name );

					echo( "<font color='" + Color.GreenYellow.html + "'>" + d.join( ", " ) + "</font>&nbsp;" );
					input( INPUT );
					_label.replaceText( _label.length -1, _label.length, content + " " );
					_carretIndex = _label.length - 1;
					updateSelection();
				}
			}
		}
		/*
		 *
		 */
		private function commandHistoryUp () : void
		{
			_commandIndex++;

			if( _commandIndex >= _lastCommands.length )
				_commandIndex = -1;

			var com : String;

			if( _commandIndex == -1 )
				com = "";
			else
				com = _lastCommands[ _commandIndex ];

			_label.replaceText( _carretLimit, _label.length, com );

			addInputCarret();
			_carretIndex = _label.length - 1;
			updateSelection();
		}
		/*
		 *
		 */
		private function commandHistoryDown () : void
		{
			_commandIndex--;

			var com : String;

			if( _commandIndex < -1 )
				_commandIndex = _lastCommands.length - 1;

			if( _commandIndex == -1 )
				com = "";
			else
				com = _lastCommands[ _commandIndex ];

			_label.replaceText( _carretLimit, _label.length, com );

			addInputCarret();
			_carretIndex = _label.length - 1;
			updateSelection();
		}
		/*
		 *
		 */
		private function parseCommand(str:String) : Boolean
		{
			str = str.replace(/;$/, '');

			var trigger : String = str.match( /^([^ ])+/i )[0];
			var args : String = StringUtils.trim( str.replace( trigger, "" ) );


			if(str == '')
			{
				echo('');
				return false;
			}
			else if( _commands.hasOwnProperty( trigger ) )
			{
				_currentCommand = _commands[ trigger ];
				registerToCommandEvents( _currentCommand );
				_currentCommand.execute.call( null, new TerminalEvent( "execute", trigger, args, this ) );
				return true;
			}
			else
			{
				echo( "<font color='" + Color.Red.html + "'>Commande inconnue :</font>&nbsp; " + trigger + " " + args );
				return false;
			}
		}
		/*
		 *
		 */
		private function isEditable () : Boolean
		{
			return ( _label.selectionBeginIndex >= _carretLimit && _inputRequired );
		}
		/*
		 *
		 */
		private function isMultiSelection () : Boolean
		{
			return _label.selectionEndIndex - _label.selectionBeginIndex > 1;
		}
		/*
		 *
		 */
		private function checkMissingEndLineSpace () : void
		{
			if( _label.length <= _carretLimit || _label.selectionBeginIndex == _label.selectionEndIndex || _label.text.charAt( _label.length -1 ) != " " )
			{
				addInputCarret();
				updateSelection();
			}
		}
		/*
		 *
		 */
		private function trimEndNewLine () : void
		{
			if( new RegExp( "(\\n|\\r)$", "gi" ).test( _label.text ) )
			{
				_label.replaceText( _label.length - 1, _label.length, "" );
				_carretLimit = _label.length;
				_label.setSelection( _label.length, _label.length );
			}
		}
	}
}