package aesia.com.ponents.skinning
{
	import aesia.com.mon.utils.Reflection;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.skinning.decorations.EmptyFill;
	import aesia.com.ponents.skinning.decorations.SimpleBorders;
	import aesia.com.ponents.skinning.decorations.SimpleFill;
	import aesia.com.ponents.skinning.icons.magicIconBuild;

	[Skin(define="EmptyComponent",
		  inherit="DefaultComponent",
		  shortcuts="utils=aesia.com.mon.utils,cutils=aesia.com.ponents.utils,deco=aesia.com.ponents.skinning.decorations,txt=flash.text",

		  state__all__background="new deco::EmptyFill()",
		  state__all__foreground="new deco::NoDecoration()"
	)]
	[Skin(define="NoDecorationComponent",
		  inherit="DefaultComponent",
		  shortcuts="utils=aesia.com.mon.utils,cutils=aesia.com.ponents.utils,deco=aesia.com.ponents.skinning.decorations,txt=flash.text",

		  state__all__background="new deco::NoDecoration()",
		  state__all__foreground="new deco::NoDecoration()"
	)]
	[Skin(define="Text",
		  inherit="DefaultComponent",
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( aesia.com.mon.utils::Color.White )",

		  custom_mispellWordsColor="aesia.com.mon.utils::Color.Red",
		  custom_embedFonts="false"
	)]
	[Skin(define="DefaultComponent",
		  inherit="",
		  preview="aesia.com.ponents.core::AbstractComponent.defaultPreview",
		  shortcuts="utils=aesia.com.mon.utils,cutils=aesia.com.ponents.utils,deco=aesia.com.ponents.skinning.decorations,txt=flash.text",

		  state__all__insets="new cutils::Insets()",
		  state__all__borders="new cutils::Borders()",
		  state__all__corners="new cutils::Corners()",
		  state__all__format="new txt::TextFormat('Verdana',11,0,false,false,false)",

		  state__all__textColor="color(Black)",
		  state__disabled__textColor="color(Gray)",
		  state__disabled__innerFilters="aesia.com.ponents.core::AbstractComponent.createDisabledInnerFilters()",

		  state__0_3_4_7__background="new deco::SimpleFill(color(LightGrey))",
		  state__1_2_5_6__background="new deco::SimpleFill(color(Gainsboro))",
		  state__8_12__background="new deco::SimpleFill(color(LightBlue))",
		  state__9__background="new deco::SimpleFill(color(LightBlue).alphaClone( 0x66 ))",
		  state__10_14__background="new deco::SimpleFill(color(PowderBlue))",
		  state__11_15__background="new deco::SimpleFill(color(LightSkyBlue))",

		  state__0_3__foreground="new deco::SimpleBorders(color(DimGray))",
		  state__2__foreground="new deco::SimpleBorders(color(Gray))",
		  state__focus_focusandselected__foreground="new deco::SimpleBorders(color(ForestGreen))",
		  state__selected__foreground="new deco::SimpleBorders(color(DodgerBlue))",
		  state__disabled__foreground="new deco::SimpleBorders(color(Gray))",
		  state_disabled_selected__foreground="new deco::SimpleBorders(color(DodgerBlue).alphaClone( 0x66 ))"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class SkinManager
	{
		
		// Utiliser pour forcer la compilation des classes utilisés par les styles définis.
		static private const DEPENDENCIES : Array = [ magicIconBuild,
													  SimpleFill,
													  SimpleBorders,
													  EmptyFill ];

		static public const DEFAULT_STYLE_KEY : String = "DefaultComponent";
		static public const DEFAULT_SKIN_NAME : String = "DefaultSkin";
		Reflection.addCustomShortcuts("icon(", "aesia.com.ponents.skinning.icons::magicIconBuild(");

		protected var _defaultSkin : Object;
		protected var _currentSkin : Object;
		protected var _skins : Object;

		public function SkinManager ( defaultSkin : Object )
		{
			_currentSkin = _defaultSkin = defaultSkin;

			_skins = {};
			_skins[DEFAULT_SKIN_NAME] = defaultSkin;
		}

/*--------------------------------------------------------------
 * GETTERS & SETTERS
 *--------------------------------------------------------------*/

		public function get defaultSkin() : Object{ return _defaultSkin; }

		public function get currentSkin () : Object	{ return _currentSkin; }
		public function set currentSkin (currentSkin : Object) : void
		{
			_currentSkin = currentSkin;
		}

/*--------------------------------------------------------------
 * SKIN MANAGEMENT
 *--------------------------------------------------------------*/

		public function getSkin( name : String ) : Object
		{
			 if( _skins.hasOwnProperty( name ) )
			 	return _skins[name];
			 else
			 	return null;
		}
		public function containsSkin( skinName : String ) : Boolean
		{
			return _skins.hasOwnProperty( skinName );
		}

		public function addSkin( name : String, o : Object ) : void
		{
			 if( !_skins.hasOwnProperty( name ) )
			 {
			 	_skins[name] = o;
			 	o.name = name;
			 }
		}
		public function removeSkin( name : String ) : void
		{
			if( _skins.hasOwnProperty( name ) )
			{
				var o : Object = _skins[name];
				if( _currentSkin == o )
					_currentSkin = defaultSkin;

				delete _skins[name];
			}
		}

		public function renameSkin ( currentName : String, newName : String ) : void
		{
			if( containsSkin(currentName) )
			{
				var o : Object = getSkin( currentName );
				removeSkin( currentName );
				addSkin( newName, o );
				for each ( var cs : ComponentStyle in o )
				{
					cs.skinName = newName;
				}
				o.name = newName;
			}
		}

		/*--------------------------------------------------------------
 * STYLE MANAGEMENT
 *--------------------------------------------------------------*/

		public function containsStyle ( key : String ) : Boolean
		{
			if( key.indexOf("#") != -1 )
			{
				var a : Array = key.split("#");
				var skin : Object = _skins[ a[0] ];
				key = a[1];

				if( skin )
					return skin.hasOwnProperty( key );
			}
			return _currentSkin.hasOwnProperty( key ) || _defaultSkin.hasOwnProperty( key );
		}

		public function getStyle ( key :  String ) : *
		{
			if( key.indexOf("#") != -1 )
			{
				var a : Array = key.split("#");
				var skin : Object = _skins[ a[0] ];
				key = a[1];
				if( skin && skin.hasOwnProperty( key ) )
					return skin[ key ];
			}

			if( _currentSkin.hasOwnProperty( key ) )
				return _currentSkin[ key ];
			else if( _defaultSkin.hasOwnProperty( key ) )
				return _defaultSkin[ key ];
			else
			{
				if( _currentSkin.hasOwnProperty( DEFAULT_STYLE_KEY ) )
					return _currentSkin[ DEFAULT_STYLE_KEY ];
				else if( _defaultSkin.hasOwnProperty( DEFAULT_STYLE_KEY ) )
					return _defaultSkin[ DEFAULT_STYLE_KEY ];
			}

		}

		public function removeStyle ( style : ComponentStyle ) : void
		{

		}

/*--------------------------------------------------------------
 * DEFAULTS BUILDINGS METHODS
 *--------------------------------------------------------------*/
		public function registerMetaStyle ( o : Object ) : void
		{
			var skins : XMLList = Reflection.getClassAndAncestorMeta( o, "Skin" );
			var l : uint = skins.length();
			var i : uint;
			for( i=0; i<l; i++ )
			{
				var x : XML = skins[i];
				createStyleWithMeta ( x );
			}
		}
		public function getComponentStyle ( c : Component ) : ComponentStyle
		{
			var xl : XMLList = Reflection.getClassAndAncestorMeta( c, "Skinable" );
			var skinID : String = xl[ xl.length()-1 ].arg.(@key == "skin").@value.toString();

			if( !containsStyle( skinID ) )
				registerComponentDefaults(c);
			return new ComponentStyle(skinID);
		}
		public function registerComponentDefaults ( c : Component ) : void
		{
			var skins : XMLList = Reflection.getClassAndAncestorMeta( c, "Skin" );
			var l : uint = skins.length();
			var i : uint;
			for( i=0; i<l; i++ )
			{
				var x : XML = skins[i];
				createStyleWithMeta ( x );
			}
		}

		protected function createStyleWithMeta ( meta : XML ) : void
		{
			var define : String  = meta.arg.( @key == "define" ).@value;

			if( _defaultSkin.hasOwnProperty( define ) )
				return;
			var inherit : String = meta.arg.( @key == "inherit" ).@value;			var sshotcuts : String = meta.arg.( @key == "shortcuts" ).@value;
			var shortcuts : Object = {};
			var shortcutsKeys : Array = [];
			var hasShortcuts: Boolean = false;

			if( sshotcuts != "" )
			{
				var ashortcuts : Array = sshotcuts.split(",");
				var l : uint = ashortcuts.length;
				var i : uint;
				var b : Array;
				for(i=0;i<l;i++)
				{
					b = ashortcuts[i].split("=");
					shortcuts[b[0]] = b[1];
					shortcutsKeys.push(b[0]);
				}
				hasShortcuts = i>0;
			}

			var props : XMLList  = meta.arg.( @key != "define" &&
											  @key != "inherit" &&
											  @key != "shortcuts" &&
											  @key != "preview" );
			var res : Array;

			var cs : ComponentStyle = new ComponentStyle( inherit, define );

			/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
			var preview : String = meta.arg.( @key == "preview" ).@value;			if( preview )
			{
				var f : Function = Reflection.get( preview ) as Function;
				cs.previewProvider = f;
			}
			cs.previewAcceptStyleSetup = String(meta.arg.( @key == "previewAcceptStyleSetup" ).@value) !== "false";
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			for each ( var x : XML in props )
			{
				var prop : String = x.@key;
				var content : *;

				var sval : String = x.@value;
				if( hasShortcuts )
					sval = handleShortcuts( sval, shortcuts, shortcutsKeys );

				content = Reflection.get( sval );
				var styleProp : String;
				if( ( res = STATE_STYLE_VALIDATION_REGEXP.exec( prop ) ) )
				{
					var indices : Array = getStatesWithPropertyName( res[1] );
					if( res[3] )
						styleProp = res[3];
					else
						styleProp = res[2];

					cs.setStyleForStates( indices, styleProp, content );
				}
				else if( ( res = STYLE_PROPERTY_VALIDATION_REGEXP.exec( prop ) ) )
				{
					styleProp = res[1];
					cs.setCustomProperty( styleProp, content );
				}
				else
					continue;
			}
			_defaultSkin[ define ] = cs;
			cs.skinName = DEFAULT_SKIN_NAME;
		}

		protected function handleShortcuts (sval : String, shortcuts : Object, shortcutsKeys : Array ) : String
		{
			var sc : Object = shortcuts;
			function replaceFunction ( ... args ) : String
			{
				return args[1] + sc[ args[ 2 ] ] + args[ 3 ];
			}
			return sval.replace( new RegExp("([^\w]|^)(" + shortcutsKeys.join("|") + ")([^\w]|$)", "g" ), replaceFunction );
		}

		public function getStatesWithPropertyName ( s : String ) : Array
		{
			// cases to handle :

			// FLAGS :			// state_normal 				> [0]			// state_disabled 				> [1]			// state_over	 				> [2]
			// state_pressed	 			> [3]

			// FLAGS COMBINATIONS :			// state_normal_focus 			> [4]
			// state_focus_normal			> [4]			// state_over_focus				> [6]			// state_normal_selected 		> [8]
			// state_normal_focus_selected 	> [12]

			// INDEX :
			// state_4						> [4]

			// FLAGS FILTERS :
			// state__all					> [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
			// state__normal				> [0,4,8,12]
			// state__over					> [2,6,10,14]
			// state__normal_over			> [0,2,4,6,8,10,12,14]

			// GROUPS FILTERS
			// state__base					> [0,1,2,3]			// state__focus 				> [4,5,6,7]			// state__selected 				> [8,9,10,11]
			// state__focus_selected 		> [4,5,6,7,8,9,10,11]
			// state__focusandselected		> [12,13,14,15]

			// INDEX FILTERS
			// state__0_1_2_10_12			> [0,1,2,10,12]

			// SPECIAL CASES
			// state_normal_focus__focusandselected > [4,12,13,14,15]			// state_normal_focus__base_10_12 > [0,1,2,3,4,10,12]

			var a : Array = s.split("_");
			if( a[0] != "state" )
				return null;

			var l : uint = a.length;
			var i : uint;

			var isFilter : Boolean = false;
			var singleValue : uint = 0;
			var manyValues : Array = [];
			var curFilter : String;
			var usedFlags : Object = {};			var usedFilters : Object = {};
			var rtn : Array;
			var curVal : int;

			for(i=1;i<l;i++)
			{
				curFilter = a[ i ];

				if(!isFilter)
				{
					if( curFilter == "" )
					{
						isFilter = true;
						if( i > 1 )
							manyValues.push( singleValue );
					}
					else if( STATE_FLAGS_LEGAL_VALUES.hasOwnProperty( curFilter ) && !usedFlags.hasOwnProperty( curFilter ) )
					{
						singleValue += STATE_FLAGS_LEGAL_VALUES[ curFilter ];
						usedFlags[ curFilter ] = true;
					}
					else if( !isNaN( curVal = parseInt( curFilter ) ) )
					{
						return [ curVal ];
					}
				}
				else
				{
					if( STATE_FILTERS_LEGAL_VALUES.hasOwnProperty( curFilter ) && !usedFlags.hasOwnProperty( curFilter ) )
					{
						manyValues = manyValues.concat( STATE_FILTERS_LEGAL_VALUES[ curFilter ] );
						usedFilters[ curFilter ] = true;
					}
					else if( !isNaN( curVal = parseInt( curFilter ) ) )
					{
						manyValues.push(curVal);
					}
				}
			}
			if( manyValues.length > 0 )
			{
				removeDuplicateValues(manyValues);
				rtn = manyValues;
			}
			else
				rtn = [singleValue];

			return rtn;
		}
		static private function removeDuplicateValues ( a : Array ) : void
		{
			var i : uint, j : uint;
			for (i = 0; i < a.length - 1; i++)
				for (j = i + 1; j < a.length; j++)
					if (a[i] === a[j])
						a.splice(j, 1);

		}

		static private const STATE_STYLE_LEGAL_VALUES : Object = { 	background : true,
																	foreground : true,
																	textColor : true,
																	insets : true,
																	borders : true,
																	corners : true,
																	innerFilters : true,
																	outerFilters : true,
																	format:true
																	};
		static private const STATE_STYLE_LEGAL_VALUES_ARRAY : Array = [
																	"background",
																	"foreground",
																	"textColor",
																	"insets",
																	"borders",
																	"corners",
																	"innerFilters",
																	"outerFilters",
																	"format",																	"custom_(.+)",
																	 ];

		static private const STATE_STYLE_VALIDATION_REGEXP : RegExp = new RegExp( "^(state_.*)__(" +
																					STATE_STYLE_LEGAL_VALUES_ARRAY.join("|") +
																				  ")$" );

		static private const STYLE_PROPERTY_VALIDATION_REGEXP : RegExp = new RegExp( "^custom_(.+)$" );

		static private const STATE_FLAGS_LEGAL_VALUES : Object = { 	normal	 : 0,
																	disabled : 1,
																	over	 : 2,
																	pressed	 : 3,
																	focus	 : 4,
																	selected : 8
																  };

		static private const STATE_FILTERS_LEGAL_VALUES : Object = { normal	  			: [0,4,8,12],
																	 disabled 			: [1,5,9,13],
																	 over	  			: [2,6,10,14],
																	 pressed  			: [3,7,11,15],
																	 base	  			: [0,1,2,3],
																	 focus	  			: [4,5,6,7],
																	 selected 			: [8,9,10,11],
																	 focusandselected 	: [12,13,14,15],
																	 all	  			: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
																  };
	}
}
