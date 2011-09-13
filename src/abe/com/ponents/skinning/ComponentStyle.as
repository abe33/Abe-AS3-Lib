/**
 * @license
 */
package abe.com.ponents.skinning 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.StringUtils;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.skinning.decorations.NoDecoration;
    import abe.com.ponents.utils.Borders;
    import abe.com.ponents.utils.Corners;
    import abe.com.ponents.utils.Insets;

    import org.osflash.signals.Signal;

    import flash.display.Graphics;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
	/**
	 * @author Cédric Néhémie
	 */
	dynamic public class ComponentStyle extends Proxy
	{	
		static private const DEFAULTS : Object =
			{
				background : new NoDecoration(),
				foreground : new NoDecoration(),
				textColor : Color.Black,
				format : new TextFormat("Verdana",12,0,false,false,false,"","","left",0,0,0,0),
				insets : new Insets(),
				borders : new Borders(0),
				corners : new Corners(),
				innerFilters : null,
				outerFilters : null
			};

		public var styleChanged : Signal;
		public var propertyChanged : Signal;

		protected var _skinName : String;
		protected var _styleName : String;
		protected var _defaultStyleKey : String;
		protected var _defaultStyleCache : ComponentStyle;	
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _states : Array;
		
		TARGET::FLASH_10
		protected var _states : Vector.<ComponentStateStyle>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _states : Vector.<ComponentStateStyle>;
		
		protected var _currentState : uint;
		
		protected var _customProperties : Object;

		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function ComponentStyle ( defaultStyleKey : String = "", styleName : String = "", states : Array = null )
		{
			_states = states ? states : new Array( 16 );
			init ( defaultStyleKey, styleName );
		}
		TARGET::FLASH_10
		public function ComponentStyle ( defaultStyleKey : String = "", styleName : String = "", states : Vector.<ComponentStateStyle> = null )
		{
			_states = states ? states : new Vector.<ComponentStateStyle>( 16, true );
			init ( defaultStyleKey, styleName );
		}
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function ComponentStyle ( defaultStyleKey : String = "", styleName : String = "", states : Vector.<ComponentStateStyle> = null )
		{
			_states = states ? states : new Vector.<ComponentStateStyle>( 16, true );
			init ( defaultStyleKey, styleName );
		}
		
		private function init( defaultStyleKey : String = "", styleName : String = "" ) : void
		{
			styleChanged = new Signal( ComponentStyle );
			propertyChanged = new Signal();
			this.defaultStyleKey = defaultStyleKey;
			_styleName = styleName;
			_customProperties = {};
			_currentState = 0;
			
		
			// Dans le builder, les styles nommés ont forcement
			// des objets états pour pouvoir les éditer
			/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
			if( styleName != "" )
				fillStates();
			
			_previewAcceptStyleSetup = true;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/	
		}
		
/*-----------------------------------------------------------------
 * 	GETTERS / SETTERS
 *----------------------------------------------------------------*/
 		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
 		protected var _previewProvider : Function;
 		protected var _previewAcceptStyleSetup : Boolean;
 			
 		public function get previewProvider () : Function { return _previewProvider != null ? _previewProvider : _defaultStyleCache.previewProvider; }
		public function set previewProvider ( f : Function ): void
		{
			_previewProvider = f;
		}
		
		public function get previewAcceptStyleSetup () : Boolean { return _previewAcceptStyleSetup; }		
		public function set previewAcceptStyleSetup (previewAcceptStyleSetup : Boolean) : void
		{
			_previewAcceptStyleSetup = previewAcceptStyleSetup;
		}		
 		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
 
		public function get defaultStyleKey () : String { return _defaultStyleKey; }		
		public function set defaultStyleKey ( defaultStyleKey : String ) : void
		{
			if( _defaultStyleCache )
				unregisterToParentStyleEvent();
			
			_defaultStyleKey = defaultStyleKey;
			
			if( SkinManagerInstance )
				_defaultStyleCache = SkinManagerInstance.getStyle( _defaultStyleKey );
			
			if( _defaultStyleCache )
				registerToParentStyleEvent();
		}
		public function registerToParentStyleEvent () : void
		{
			_defaultStyleCache.propertyChanged.add( defaultStylePropertyChanged );
		}
		public function unregisterToParentStyleEvent () : void
		{
			_defaultStyleCache.propertyChanged.remove( defaultStylePropertyChanged );
		}
		
		public function get fullStyleName() : String
		{
			return _skinName + "#" + _styleName;
		}

		public function get skinName () : String { return _skinName; }		
		public function set skinName (skinName : String) : void
		{
			_skinName = skinName;
		}
		
		public function get currentStateStyle () : ComponentStateStyle { return _states[_currentState] ? _states[_currentState] : defaultStyle.states[_currentState]; }
			
		public function get background () : * { return retreiveStyleProperties( "background", _currentState ); } 																   
		public function get foreground () : * { return retreiveStyleProperties( "foreground", _currentState ); } 															   													   
		public function get textColor () : Color { return retreiveStyleProperties( "textColor", _currentState );} 		
		public function get format () : TextFormat { return retreiveStyleProperties( "format", _currentState ); } 		
		public function get outerFilters () : Array { return retreiveStyleProperties( "outerFilters", _currentState ); } 														 		public function get innerFilters () : Array { return retreiveStyleProperties( "innerFilters", _currentState ); } 														 
		public function get insets () : Insets { return retreiveStyleProperties( "insets", _currentState ); }		
		public function get corners () : Corners {  return retreiveStyleProperties( "corners", _currentState ); }									   		public function get borders () : Borders {  return retreiveStyleProperties( "borders", _currentState ); }	
		
		public function set background ( o : * ) : void { setForAllStates("background", o ); } 																   
		public function set foreground (o : * ) : void { setForAllStates("foreground", o ); } 		 															   													   
		public function set textColor ( o: Color ) : void{ setForAllStates("textColor", o ); } 		
		public function set format ( o : TextFormat) : void { setForAllStates("format", o ); } 					
		public function set outerFilters ( o : Array) : void { setForAllStates("outerFilters", o ); } 													 
		public function set innerFilters (o : Array ) : void { setForAllStates("innerFilters", o ); } 		 														 
		public function set insets (o : Insets ) : void { setForAllStates("insets", o ); } 			
		public function set corners (o : Corners) : void { setForAllStates("corners", o ); } 											   
		public function set borders (o : Borders) : void { setForAllStates("borders", o ); } 									   

		public function get defaultStyle () : ComponentStyle 
		{ 
			return _defaultStyleCache ? 
						_defaultStyleCache : 
						_defaultStyleKey != "" ? 
							_defaultStyleCache = SkinManagerInstance.getStyle( _defaultStyleKey ) : 
							null; 
		}
		/*FDT_IGNORE*/
		TARGET::FLASH_9 {
			public function get states () : Array { return _states; }
			public function set states ( o : Array ) : void 
			{
				clearStates();
				_states = o;
				dispatchEvent( new Event( Event.CHANGE ) );
			}
		}
		TARGET::FLASH_10 {
			public function get states () : Vector.<ComponentStateStyle> { return _states; }
			public function set states ( o : Vector.<ComponentStateStyle> ) : void 
			{
				clearStates();
				_states = o;
				dispatchEvent( new Event( Event.CHANGE ) );
			}
		}
		TARGET::FLASH_10_1 { /*FDT_IGNORE*/
		public function get states () : Vector.<ComponentStateStyle> { return _states; }
		public function set states ( o : Vector.<ComponentStateStyle> ) : void 
		{ 
			clearStates();
			_states = o;
			styleChanged.dispatch( this );
		}
		/*FDT_IGNORE*/}/*FDT_IGNORE*/
	
		public function get currentState () : uint { return _currentState; }		
		public function set currentState (currentState : uint) : void
		{
			_currentState = currentState;
		}
		
		public function get styleName () : String { return _styleName; }		
		public function set styleName (styleName : String) : void
		{
			_styleName = styleName;
		}
/*-----------------------------------------------------------------
 * 	FLUENT METHODS
 *----------------------------------------------------------------*/
		public function setStyleForState ( state : uint, name : String, value : * ) : ComponentStyle
		{
			createStateIfNull( state );
			
			_states[ state ][ name ] = value;

			return this;
		}
		public function setStyleForStates ( states : Array, name : String, value : * ) : ComponentStyle
		{
			for ( var i : * in states )
			{
				createStateIfNull( states[i] );
				_states[ states[ i ] ][ name ] = value;
			}

			return this;
		}		
		public function setForAllStates ( name : String, value : * ) : ComponentStyle
		{
			for( var i : int = 0; i<16; i++ )
			{
				createStateIfNull( i );
				_states[ i ][ name ] = value;
			}

			return this;
		}
/*-----------------------------------------------------------------
 * 	MISCS METHODS
 *----------------------------------------------------------------*/
 		public function hasCustomProperties () : Boolean
 		{
 			for( var i : String in _customProperties )
 				return true;
 			
 			return false;
		}

		public function hasCustomProperty ( name : String ) : Boolean 
		{
			return _customProperties.hasOwnProperty(name);
		}

		public function setCustomProperty ( pname : String, pvalue : * ) : ComponentStyle
		{
			_customProperties[pname] = pvalue;
			return this;
		}

		public function getPropertiesTable() : Array
 		{
 			var a : Array = [ "borders", 
 							  "insets", 
 							  "corners", 
 							  "background", 
 							  "foreground", 
 							  "innerFilters", 
 							  "outerFilters", 
 							  "textColor", 
 							  "format" ];
 			return a.sort();
 		}
 		public function getCustomPropertiesTable() : Array
 		{
 			var a : Array = [];
 			
 			for( var i : String in _customProperties )
 				a.push( i );
 			
 			return a.sort();
 		}
		public function retreiveStyleProperties ( name : String, state : uint ) : *
		{
			if( _states[state] && _states[state][name] != undefined )
				return _states[state][name];
			else if( _customProperties[name] != undefined )
				return _customProperties[name];	
			else if( defaultStyle )
			{
				var v : * = defaultStyle.retreiveStyleProperties(name, state);
				
				if( v != undefined )
					return v;
				else
					return DEFAULTS[name];
			}
		}
		public function draw ( r : Rectangle, g1 : Graphics, g2 : Graphics, c : Component ) : void
		{
			background.draw( r, g1, c, borders, corners );
			foreground.draw( r, g2, c, borders, corners );
		}
		public function clearStates () : void
		{
			for( var i : Number = 0; i<16;i++)
			{
				unregisterState( _states[i] );
			}
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _states = []; }
			TARGET::FLASH_10 { _states = new Vector.<ComponentStateStyle>(16, true); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_states = new Vector.<ComponentStateStyle>(16, true); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		public function toString() : String
		{
			if( _styleName == "" )
				return StringUtils.stringify( this, {'proxyOf':_defaultStyleKey} );			else
				return StringUtils.stringify( this, {'skin':_skinName, 'name':_styleName} );
		}
		protected function createStateIfNull ( state : uint ) : void
		{
			if( !_states[state] )
			{
				_states[state] = new ComponentStateStyle();
				registerState( _states[state] );
			}
		}
		protected function fillStates () : void
		{
			for( var i : Number = 0; i<16;i++)
			{
				if( !_states[i] )
					_states[i] = new ComponentStateStyle();
					
				registerState( _states[i] );					
			}
		}
/*-----------------------------------------------------------------
 * 	PROXY OVERRIDES
 *----------------------------------------------------------------*/
		override flash_proxy function getProperty (name : *) : *
		{
			return retreiveStyleProperties ( name, _currentState );
		}
		override flash_proxy function setProperty (name : *, value : *) : void
		{
			if( StyleProperties.ALL.indexOf( name ) )
				setForAllStates(name, value);
			else
				_customProperties[name]=value;
			
			firePropertyChangedSignal(name, value);
		}

		override flash_proxy function callProperty (name : *, ...args : *) : *
		{
		}

		override flash_proxy function deleteProperty (name : *) : Boolean 
		{
			if( hasCustomProperty(name) )
				return delete _customProperties[name];
			else
				return false;
				
			fireStyleChangedSignal();
		}
		override flash_proxy function hasProperty (name : *) : Boolean 
		{
			return _customProperties.hasOwnProperty(name) || 
				   ["background",
					"foreground",
					"textColor",
					"corners",
					"format",
					"insets",
					"borders",
					"outerFilters",
					"innerFilters"].indexOf(name) != -1 || 
					( _defaultStyleCache ? _defaultStyleCache.hasOwnProperty( name ) : false );
		}
		/*-----------------------------------------------------------------
 * 	EVENT HANDLERS
 *----------------------------------------------------------------*/		
		protected function onPropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			firePropertyChangedSignal( propertyName, propertyValue );
		}
		protected function defaultStylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			firePropertyChangedSignal( propertyName, propertyValue );
		}
/*-----------------------------------------------------------------
 * 	EVENT MANAGEMENTS
 *----------------------------------------------------------------*/
		protected function registerState ( c : ComponentStateStyle ) : void
		{
			c.propertyChanged.add( onPropertyChanged );
		}
		protected function unregisterState ( c : ComponentStateStyle ) : void
		{
			c.propertyChanged.remove( onPropertyChanged );
		}
/*-----------------------------------------------------------------
 * 	IEVENTDISPATCHER IMPLEMENTATION
 *----------------------------------------------------------------*/
		protected function firePropertyChangedSignal ( pname : String, pvalue : * ) : void
		{
			propertyChanged.dispatch( pname, pvalue );
		}
		protected function fireStyleChangedSignal () : void
		{
			styleChanged.dispatch( this );
		}
	}
}
