/**
 * @license
 */
package abe.com.edia.text.builds 
{
	import abe.com.edia.text.AdvancedTextField;
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.core.CharEvent;
	import abe.com.edia.text.core.NewLineChar;
	import abe.com.edia.text.core.NullChar;
	import abe.com.edia.text.core.ParagraphChar;
	import abe.com.edia.text.core.ParagraphEndChar;
	import abe.com.edia.text.core.SpaceChar;
	import abe.com.edia.text.core.SpriteChar;
	import abe.com.edia.text.core.TabChar;
	import abe.com.edia.text.core.TextFieldChar;
	import abe.com.edia.text.fx.CharEffect;
	import abe.com.mon.core.Clearable;
	import abe.com.mon.iterators.StringIterator;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.utils.Reflection;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	[Event(name="charsCreated", 	type="core.CharEvent")]	[Event(name="charsRemoved", 	type="core.CharEvent")]	[Event(name="buildComplete", 	type="core.CharEvent")]
	[Event(name="init", 			type="flash.events.Event")]
	public class BasicBuild extends EventDispatcher implements CharBuild, Clearable
	{
		// le suffix utilisé pour les fonctions de traitement de fin de balise,	
		static private const END_SUFFIX : String = ":end";

		// 
		public var _embedFonts : Boolean;
		// 
		public var cacheAsBitmap : Boolean;
		//
		public var antiAliasType : String;

		// le format original du champs de texte
		protected var _format : TextFormat;
		// un vecteur contenant tout les caractère de la chaîne une fois traitée.s
		protected var _chars : Vector.<Char>;
		// un vecteur utilisé pour stocker les balises ouvertes 
		protected var _activeTags : Vector.<String>;
		// un vecteur utilisé pour stocker les contextes à chaque ouverture de balises		protected var _buildContexts : Vector.<BuildContext>;
		// un vecteur stockant tout les effets de caractère créer durant le processus
		protected var _effects : Object;
		// un objet mappant le nom d'une balise avec une fonction de traitement.
		protected var _tagMapping : Object;
		// un objet mappant un caractère avec une fonction de traitement.
		protected var _charMapping : Object;
		// une copie du texte traité dans le dernier appel à la fonction de build
		protected var _lastBuiltText : String;
		// le champ de texte possédant le build
		protected var _owner : AdvancedTextField;
		// 
		protected var _styleContextRoot : StyleContext;
		
		// le context de construction courant 
		private var currentBuildContext : BuildContext;		// le context de style courant
		private var currentStyleContext : StyleContext;
		// vecteurs des context
		private var styleContexts : Vector.<StyleContext>;
		
		// un object stockant les instance crées de Char
		private var created : Object;
		// un objet stockant les instances supprimées de Char
		private var removed : Object;
		// la position du curseur de traitement
		private var i : Number;
		// le nombre initial de char dans _chars au départ du traitement
		private var m : Number;
		// l'instance courante de Char
		private var char : Char;
		// id d'effet utilisé en cas d'absence de l'attribut correspondant
		private var fxid : Number;
		
		private var forceRebuild : Boolean;
		
		public function BasicBuild( defaultFormat : TextFormat = null, 
									cacheAsBitmap : Boolean = true, 
									embedFonts : Boolean = false, 
									antiAliasType : String = "advanced" )
		{
			//this.cacheAsBitmap = cacheAsBitmap;
			this._embedFonts = embedFonts;
			this.antiAliasType = antiAliasType;
			
			_format = defaultFormat ? defaultFormat : new TextFormat( "Verdana", 12, 0x000000, false, false, false );
			_chars = new Vector.<Char> ();				
			_tagMapping = {};
			_charMapping = {};
			
			if( _format.bold == null )
				_format.bold = false;
				
			if( _format.italic == null )
				_format.italic = false;
			
			if( _format.underline == null )
				_format.underline = false;
			
			_tagMapping.a = anchor;			_tagMapping.b = bold;
			_tagMapping.i = italic;
			_tagMapping.u = underline;
			_tagMapping.p = paragraph;			_tagMapping.img = image;			_tagMapping.font = font;			_tagMapping.br = br;
			_tagMapping[ "p:end" ] = paragraphEnd;
			_tagMapping[ "fx:effect" ] = effect;			_tagMapping[ "fx:filter" ] = filter;
			
			_charMapping[ "&nbsp;" ] = nbsp;
			
			_effects = new Object ();
		}
		
		public function get owner (): AdvancedTextField { return _owner; }
		public function set owner ( o : AdvancedTextField ) : void
		{
			_owner = o;
		}
		
		public function get defaultTextFormat () : TextFormat { return _format; }
		public function set defaultTextFormat ( tf : TextFormat ) : void
		{
			_format = tf;
			updateCharsFormat();
		}
		
		public function get chars () : Vector.<Char> { return _chars; }
		public function get effects () : Object { return _effects; }
		
		public function get embedFonts () : Boolean { return _embedFonts; }		
		public function set embedFonts (embedFonts : Boolean) : void
		{
			_embedFonts = embedFonts;
			rebuildChars();
		}
		public function rebuildChars () : void
		{
			forceRebuild = true;
			buildChars( _lastBuiltText );
		}
		public function buildChars( txt : String ):void
		{
			if( _lastBuiltText != txt || forceRebuild )
			{
				forceRebuild = false;
				// on créer les container des currentBuildContextes et des tags
				_buildContexts = new Vector.<BuildContext>();
				styleContexts = new Vector.<StyleContext>();
				// 
				_activeTags = new Vector.<String> ();
				fxid = 0;
				// on supprime tout les effets qui auraient pu être créer la fois précédente
				for each (var j : CharEffect in _effects )
				{
					j.dispose();
				}
				_effects = {};
				
				if( txt.length != 0 )
				{		
					// on créer un currentBuildContext de départ, basé sur le format transmis à cette instance de CharBuild			
					currentBuildContext = new BuildContext();
					//currentBuildContext.format = _format;
					currentBuildContext.embedFonts = _embedFonts;					currentBuildContext.cacheAsBitmap = cacheAsBitmap;
					_buildContexts.push( currentBuildContext );
					
					_styleContextRoot = new StyleContext();
					_styleContextRoot.format = _format;
					currentStyleContext = _styleContextRoot;
					styleContexts.push( currentStyleContext );
					
					// on créer un itérateur sur les caractère de la chaîne
					var iterator : StringIterator = new StringIterator( txt );
					
					// on initialise le compteur de caractère
					i = -1;
					// on initialise le nombre de caractère créer dans le build précédent
					m = _chars.length;
					// on initialise les objets de modifications
					removed = {};
					created = {};
					
					var newLength : Number;
					
					// tant qu'on a des caractère dans la chaîne ou d'un build précédent
					while( ++i < m || iterator.hasNext() )
					{
						// on récup le caractère de la chaine et celui du build précédent					
						var l : String = iterator.hasNext() ? iterator.next() as String : null;
						char = i < m ? _chars[ i ] : null;	
						
						// si il n'y a plus de caractère dans la chaine			
						if( l == null)
						{
							if( isNaN( newLength ) )
								newLength = i;
								
							// et le caractère associé
							checkCharRelease ( char );
							continue;
						}
						// si c'est l'ouverture d'une balise
						else if( l == "<" )
						{
							checkTag(iterator);
						}
						// si c'est un espace on créer un caractère nul selon le type d'espace
						else if( new RegExp( "[\\n\\t\\r]+", "g" ).test( l ) )
						{		
							var lt : Char;	
							switch ( l )
							{
								case "\n" : 								case "\r" :
									lt = new NewLineChar();
									break;
								case "\t" : 
									lt = new TabChar();
									break;
								default : 	
									lt = new NullChar();
									break;
							}
							
							// on remplace ou ajoute en fonction de l'index
							setChar( i, lt );
							
							// et si un champs de texte précédent existait on le supprime
							checkCharRelease ( char );
							continue;
						}
						// on est dans le cas général
						else
						{
							// si c'est le début d'un caractère spécial
							if( l == "&" )
							{
								l = checkSpecialChar(iterator);
							}
							// s'il s'agit d'une image
							if ( char is SpriteChar )
							{
								removed[ i ] = char;
								char = null;	
							}
							// si il n'y a pas de champs texte, on en récupère un
							if( char == null || char is NullChar )
							{
							 	char = getChar( l, currentBuildContext );
							 	created[ i ] =  char;
								setChar( i, char );
								
							}
							// on force la réaffectation de l'embed si changement
							if( char is TextFieldChar )
								( char as TextFieldChar ).embedFonts = currentBuildContext.embedFonts;
								
							// on ajoute le format de texte et les filtres
							currentStyleContext.chars.push( char );
							//char.format = currentBuildContext.format;							//char.format = currentStyleContext.format;
							char.filters = currentBuildContext.filters;
							if( !isNaN( currentBuildContext.backgroundColor ) )
							{
								char.background = true,
								char.backgroundColor = currentBuildContext.backgroundColor;
							}
							
							// on ajoute ce caractère a tout les effets du currentBuildContexte
							for each ( var k : CharEffect in currentBuildContext.effects )
							{
								k.addChar( char );						
							}
							
							// on définit le texte de ce caractère selon qu'un lien est défini dans le currentBuildContexte ou non
							if( currentBuildContext.link )
							{
								char.text = "<a href='event:" + currentBuildContext.link + "'>" + l + "</a>";
							}
							else
							{
								char.text = l;
							}
						}
					}
					// on modifie la longueur du tableau pour toujours n'avoir que les char courante
					_chars.length = isNaN( newLength ) ? i : newLength;
					
					updateCharsFormat();
					
					fireCharsRemoved( removed );
					fireCharsCreated( created );
					fireBuildComplete();
					
					removed = null;
					created = null;
										
					// initialise tout les effets 
					for each ( var n : CharEffect in _effects )
					{
						n.init();
					}
					
					// le processus est fini
					fireInit ();
				}
			}
			_lastBuiltText = txt;
		}
		public function clear () : void
		{
			_lastBuiltText = null;
			var l : Number = _chars.length;
			var removed : Object = [];
			removed = {};
			if( l > 0 )
			{
				for ( var i : Number = 0; i < l; i++ )
				{	
					var let : Char = _chars[ i ];
						
					if( !(let is NullChar) )
					{
						removed[ i ] = let;
						checkCharRelease(let);
					}
				}
			}	
			this.removed = null;
			this.created = null;
			_chars = new Vector.<Char>;
			
			for each( var c : CharEffect in effects )
				c.clear();
			
			fireCharsRemoved( removed );
		}
		
		/*--------------------------------------------------------------------------
		 * 	CHAR HANDLING
		 *-------------------------------------------------------------------------*/
		public function addCharMapping ( char : String, func : Function ) : void
		{
			_charMapping[ char ] = func;
		}
		public function removeCharMapping ( char : String ) : Boolean
		{
			return delete _charMapping[ char ];
		}
		public function setChar ( i : Number, char : Char ) : void
		{
			if( i < m )
				_chars[ i ] = char;
			else
				_chars.push( char );
		}
		public function checkCharRelease ( char : Char ) : void
		{
			if( char != null && !(char is NullChar) )
			{
				if( char is TextFieldChar )
				{
					AllocatorInstance.release( char, TextFieldChar );
				}
				else if( char is SpriteChar )
				{
					var o : DisplayObject = ( char as SpriteChar ).getChildAt(0);
					if( o is Bitmap )
					  ( o as Bitmap ).bitmapData.dispose();
				}
				//removed[ i ] = char;
			}	
		}
		protected function getChar ( s : String, currentBuildContext : BuildContext ) : Char
		{
			if( _charMapping.hasOwnProperty( s ) )
				return ( _charMapping[ s ] as Function ).call( null, s, currentBuildContext ) as Char;
			else
				return setDefaults( AllocatorInstance.get( TextFieldChar ) as TextFieldChar, currentBuildContext );
		}
		protected function checkSpecialChar ( iterator : StringIterator ) : String
		{
			var specialChar : String = "";
			
			while( iterator.hasNext() )
			{
				var s : String = iterator.next() as String;
				if( s != ";" )
				{
					specialChar += s;
				}
				else 
					break;
			}
			return "&" + specialChar + ";";
		}

		protected function updateCharsFormat () : void 
		{
			if( _styleContextRoot )
			{
				_styleContextRoot.format = _format;
				_styleContextRoot.applyStyle();
			}
		}

		/*--------------------------------------------------------------------------
		 * 	TAGS HANDLING
		 *-------------------------------------------------------------------------*/
		
		protected function checkTag ( iterator : StringIterator ) : Boolean
		{
			var tag : String = "";
			var unik : Boolean = false;
			
			var last : String;
			while( iterator.hasNext() )
			{
				var s : String = iterator.next() as String;
				if( s != ">" )
				{
					tag += s;
					
				}
				else
				{
					if( last == "/" )
						unik = true;
					else
						unik = false;
					
					break;
				}
				last = s;
			}
			if( !unik )
				parseTag( tag );
			else
				unik = parseSingleTag( tag );
				
			return unik;
		}
		protected function parseSingleTag ( s : String ) : Boolean
		{
			var a : Array = s.substr(0,-1).split(" ");
			var tag : String = a[0];
			
			var xml : XML = new XML ( "<root xmlns:fx='http://abe.fr/fx'><" + s.substr(0,-1) + "/></root>" );
				
			
			if( _tagMapping.hasOwnProperty( tag ) )
			{
				(_tagMapping[ tag ] as Function).call( null, cloneContext( currentBuildContext ), parseAttributes( xml.children()[0] ) );
				return true;
			}
			else
			{
				Log.warn( "unknown tag <" + tag +">" );
				return false;
			}
		}
		protected function parseTag ( s : String ) : void
		{
			var tag : String;
			if( s.substr(0,1) == "/" )
			{
				tag = s.substr(1);
				if( _tagMapping.hasOwnProperty( tag ) && _activeTags[ _activeTags.length -1 ] == tag )
				{
					if( _tagMapping.hasOwnProperty( tag + END_SUFFIX ) )
						_tagMapping[ tag + END_SUFFIX ].call( null, currentBuildContext, null );
					else
						i--;
						
					_activeTags.pop();
					_buildContexts.pop();
					styleContexts.pop();
					
					currentStyleContext = styleContexts[ styleContexts.length - 1 ];
					currentBuildContext = _buildContexts[ _buildContexts.length -1 ];
				}
			}
			else
			{
				var a : Array = s.split(" ");
				tag = a[0];
				
				var xml : XML = new XML ( "<root xmlns:fx='http://abe.fr/fx'><" + s + "/></root>" );
				
				if( _tagMapping.hasOwnProperty( tag ) )
				{
					var styleContext : StyleContext = new StyleContext();
					styleContext.format = new TextFormat();//currentBuildContext.format;
					currentStyleContext.subContexts.push( styleContext );
					currentStyleContext = styleContext;
					
					currentBuildContext = (_tagMapping[ tag ] as Function).call( 
									null, cloneContext( currentBuildContext ), parseAttributes( xml.children()[0] ) );
					
					
					_activeTags.push( tag );
					
					styleContexts.push( currentStyleContext );
					_buildContexts.push( currentBuildContext );
					
				}
				else
				{
					Log.debug( "unknown tag : <" + tag +">" );
				}
			}			
		}
		protected function parseAttributes ( x : XML ) : Object
		{
			var o : Object = {};
			for each( var att:XML in x.attributes() )
			{		
				o[ att.name().toString() ] = toArgument( att.toString() );
			}
			return o;
		}
		protected function parseArguments ( s : String ) : Array
		{
			if( s == "" )
			return [];
			
			var a : Array = s.split( /\s*[,]{1}\s*/gi );
			return a.map( toArgument );	
		}
		private function toArgument(element:*, ... args ):* 
		{
			var s : String = element.toString();
			var numval : Number;
			if( s.indexOf("0x") != -1 )
				numval = parseInt( s );
			else
				numval = parseFloat( s );
				
			if( isNaN( numval ) )
			{
				if( s == "false" || s == "true" )
				{
					return s == "true";
				}
				else if( s.indexOf(",") != -1 && s.indexOf("(") == -1 )
				{
					var a : Array = s.split(",");
					
					return a.map( toArgument );
				}
				else
					return s;
			}
			else return numval;
            return undefined;
        }

		/*--------------------------------------------------------------------------
		 * 	DOUBLE TAGS NODES
		 *-------------------------------------------------------------------------*/

		protected function bold ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			//currentBuildContext.format.bold = true;			currentStyleContext.format.bold = true;
			return currentBuildContext;
		}
		protected function italic ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			//currentBuildContext.format.italic = true;			currentStyleContext.format.italic = true;
			return currentBuildContext;	
		}
		protected function underline ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			//currentBuildContext.format.underline = true;			currentStyleContext.format.underline = true;
			return currentBuildContext;
		}
		protected function font ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			if( attributes.hasOwnProperty( "embedFonts" ) )
				currentBuildContext.embedFonts = attributes.embedFonts;	
				
			if( attributes.hasOwnProperty( "cacheAsBitmap" ) )
				currentBuildContext.cacheAsBitmap = attributes.cacheAsBitmap;	
					
			if( attributes.hasOwnProperty( "face" ) )
				currentStyleContext.format.font = attributes.face;
				
			if( attributes.hasOwnProperty( "color" ) )
				currentStyleContext.format.color = attributes.color;
				
			if( attributes.hasOwnProperty( "size" ) )
				currentStyleContext.format.size = attributes.size;
				
			if( attributes.hasOwnProperty( "background" ) )
				currentBuildContext.backgroundColor = parseInt( attributes.background );
				
			return currentBuildContext;
		}
		protected function paragraphEnd ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			checkCharRelease ( char );			
			var c : ParagraphEndChar = new ParagraphEndChar();
			
			char = c;	
			setChar(i, char);
			return currentBuildContext;
		}
		protected function paragraph ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			if( !attributes.hasOwnProperty( "align" ) )
			{
				attributes.align = "left";
			}
			checkCharRelease ( char );		
			
			var c : ParagraphChar = new ParagraphChar( attributes.align );
			currentBuildContext.align = attributes.align;
			
			char = c;	
			setChar(i, char);	

			return currentBuildContext;	
		}
		protected function effect ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			if( attributes.hasOwnProperty( "type" ) )
			{
				//var a : Array = attributes.type.split( "(" );
				
				var fx : CharEffect = Reflection.get( attributes.type ) as CharEffect;
				
				currentBuildContext.effects.push( fx );
				
				if( attributes.hasOwnProperty( "id" ) )
					_effects[ attributes.id ] = fx;
				else
					_effects[ fxid++ ] = fx;
			}
			
			return currentBuildContext;
		}
		protected function filter ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			if( attributes.hasOwnProperty( "type" ) )
			{
				var fx : BitmapFilter = Reflection.get( attributes.type ) as BitmapFilter;
				
				currentBuildContext.filters.push( fx );			}
			
			return currentBuildContext;
		}
		protected function anchor ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			i--;
			if( attributes.hasOwnProperty( "href" ) )
			{
				currentBuildContext.link = attributes.href;	
			}
			
			return currentBuildContext;
		}
		
		/*--------------------------------------------------------------------------
		 * 	SINGLE TAG NODES
		 *-------------------------------------------------------------------------*/
		
		protected function br ( currentBuildContext : BuildContext, attributes : Object ) : BuildContext
		{
			checkCharRelease ( char );		
			
			var c : NewLineChar = new NewLineChar();
			
			char = c;	
			setChar(i, char);	

			return currentBuildContext;	
		}
		protected function image ( currentBuildContext : BuildContext, attributes : Object ) : void
		{
			if( attributes.hasOwnProperty( "src" ) )
			{
				checkCharRelease ( char );
								
				var d : DisplayObject = new (Reflection.get( attributes.src ) as Class)();
				
				var c : SpriteChar = new SpriteChar();
				if( currentBuildContext.link )
					c.link = currentBuildContext.link;
				 
				c.addChild( d );
				
				char = c;
				
				created[i] = char;
								
				setChar(i, char);
				
				for each ( var q : CharEffect in currentBuildContext.effects )
				{
					q.addChar( char );						
				}
			}			
		}
		/*--------------------------------------------------------------------------
		 * 	HTML ENTITY
		 *-------------------------------------------------------------------------*/
		protected function nbsp ( char : String, currentBuildContext : BuildContext ) : Char
		{
			return new SpaceChar();
		}
		/*--------------------------------------------------------------------------
		 * 	CONTEXT AND DEFAULTS
		 *-------------------------------------------------------------------------*/

		protected function cloneContext ( currentBuildContext : BuildContext ) : BuildContext
		{
			var c : BuildContext = new BuildContext();
			/*
			var ntf : TextFormat = new TextFormat( 
							currentBuildContext.format.font,
							currentBuildContext.format.size,
							currentBuildContext.format.color, 
							currentBuildContext.format.bold, 
							currentBuildContext.format.italic, 
							currentBuildContext.format.underline );
			*/
			c.effects = currentBuildContext.effects.concat();
			c.filters = currentBuildContext.filters.concat();
			c.align = currentBuildContext.align;
			c.link = currentBuildContext.link;			c.embedFonts = currentBuildContext.embedFonts;
			c.cacheAsBitmap = currentBuildContext.cacheAsBitmap;
			//c.format = ntf;
			c.backgroundColor = currentBuildContext.backgroundColor;
			
			return c;
		}
        protected function setDefaults( char : TextFieldChar, currentBuildContext : BuildContext ) : TextFieldChar
		{
			char.visible = true;
			char.alpha = 1;
			char.autoSize = TextFieldAutoSize.LEFT;
			char.selectable = false;			
			char.cacheAsBitmap = currentBuildContext.cacheAsBitmap;
			char.embedFonts = currentBuildContext.embedFonts;
			char.background = false;			char.backgroundColor = 0xffffff;
			return char;
		}
		/*--------------------------------------------------------------------------
		 * 	FIRING EVENTS
		 *-------------------------------------------------------------------------*/

		public function fireCharsCreated(chars:Object):void
		{
			dispatchEvent( new CharEvent( CharEvent.CHARS_CREATED, chars ) );
		}		
		public function fireCharsRemoved(chars:Object):void
		{
			dispatchEvent( new CharEvent( CharEvent.CHARS_REMOVED, chars ) );
		}
		public function fireBuildComplete () : void
		{
			dispatchEvent( new CharEvent( CharEvent.BUILD_COMPLETE ) );
		}
		public function fireInit () : void
		{
			dispatchEvent( new Event( Event.INIT ) );
		}

	}
}

