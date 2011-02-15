package aesia.com.ponents.builder.styles 
{
	import aesia.com.ponents.builder.events.StyleSelectionEvent;
	import aesia.com.mon.utils.Delegate;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.builder.models.StyleSelectionModel;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.ComponentStates;
	import aesia.com.ponents.core.Dockable;
	import aesia.com.ponents.core.SimpleDockable;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.Box9Layout;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.skinning.icons.magicIconBuild;

	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="selectionChange", type="aesia.com.ponents.events.ComponentEvent")]
	/**
	 * @author cedric
	 */
	public class StyleStateGrid extends AbstractContainer 
	{
		[Embed(source="../../skinning/icons/components/states-grid.png")]
		static private var stateGridIcon : Class;
		
		protected var _targetStyle : ComponentStyle;
		protected var _statesGrid : Panel;
		protected var _model : StyleSelectionModel;
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9 {
			protected var _statesPreview : Array;
			protected var _selectedStates : Array;
		}
		TARGET::FLASH_10 {
			protected var _statesPreview : Vector.<StyleStatePreview>;
			protected var _selectedStates : Vector.<uint>;
		}
		TARGET::FLASH_10_1 { /*FDT_IGNORE*/		protected var _statesPreview : Vector.<StyleStatePreview>;		protected var _selectedStates : Vector.<uint>;
		
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function StyleStateGrid ()
		{
			var l : Box9Layout = new Box9Layout(this);
			_childrenLayout = l;
			super();
			_allowFocus = false;
			
			_statesGrid = new Panel();
			_statesGrid.childrenLayout = new GridLayout(this, 4, 4, 0, 0 );
			_statesGrid.styleKey = "DefaultComponent";
			l.center = _statesGrid;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _selectedStates = []; }
			TARGET::FLASH_10 { _selectedStates = new Vector.<uint>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_selectedStates = new Vector.<uint>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			createStates();
			addComponent( _statesGrid );
			createHeaders();
		}
		public function get dockable () : Dockable { return new SimpleDockable( this, "statesGrid", _("States"), magicIconBuild(stateGridIcon)); }
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get selection () : Array { return _selectedStates; }
		
		TARGET::FLASH_10
		public function get selection () : Vector.<uint> { return _selectedStates; }
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function get selection () : Vector.<uint> { return _selectedStates; }
		
		public function get model () : StyleSelectionModel { return _model; }
		public function set model (model : StyleSelectionModel) : void
		{
			if( _model )
				_model.removeEventListener( StyleSelectionEvent.STYLE_SELECT, styleSelectionChange );
			_model = model;
		
			if( _model )
				_model.addEventListener( StyleSelectionEvent.STYLE_SELECT, styleSelectionChange );
		}
		public function get targetStyle () : ComponentStyle { return _targetStyle; }		
		public function set targetStyle (targetStyle : ComponentStyle) : void
		{
			_targetStyle = targetStyle;
			var i:int;
			
			if( _targetStyle )
			{
				for( i=0;i<16;i++ )
				{
					_statesPreview[i].targetStyle = _targetStyle;
					_statesPreview[i].targetState = i;
				}
				enabled = true;
			}
			else
			{
				for( i=0;i<16;i++ )
				{
					_statesPreview[i].targetStyle = SkinManagerInstance.getStyle("NoDecorationComponent");
					_statesPreview[i].targetState = 1;
				}
				enabled = false;
			}
		}			
		
		public function clearSelection():void
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _selectedStates = []; }
			TARGET::FLASH_10 { _selectedStates = new Vector.<uint>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_selectedStates = new Vector.<uint>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			updateSelection();
			fireSelectionEvent( );
		}
		
		private function updateSelection () : void
		{
			for( var i:int=0;i<16;i++ )
			{
				_statesPreview[i].selected = selectionContains(i);
			}
		}

		public function selectAll () : void
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _selectedStates = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; }
			TARGET::FLASH_10 { _selectedStates = Vector.<uint>([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_selectedStates = Vector.<uint>([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			updateSelection();
			fireSelectionEvent();
		}
		protected function createHeaders () : void
		{
			var l : Box9Layout = _childrenLayout as Box9Layout;
			var rowHeader : Panel = new Panel( );
			rowHeader.childrenLayout = new GridLayout(rowHeader, 4, 1, 0, 0);
			
			var normal1 : HeaderLabel = new HeaderLabel( "NORMAL" );
			var focus : HeaderLabel = new HeaderLabel( "FOCUS" );
			var selected : HeaderLabel = new HeaderLabel( "SELECTED" );
			var fselected : HeaderLabel = new HeaderLabel( "FOCUS\nSELECTED" );
			
			normal1.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allNormal2 ) );			focus.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allFocus ) );			selected.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allSelected ) );			fselected.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allFocusSelected ) );
			
			rowHeader.addComponent( normal1 );
			rowHeader.addComponent( focus );
			rowHeader.addComponent( selected );
			rowHeader.addComponent( fselected );
			l.left = rowHeader;
			
			var colHeader : Panel = new Panel( );
			colHeader.childrenLayout = new GridLayout(colHeader, 1, 4, 0, 0);
			
			var normal2 : HeaderLabel = new HeaderLabel( "NORMAL" );
			var disabled : HeaderLabel = new HeaderLabel( "DISABLED" );
			var over : HeaderLabel = new HeaderLabel( "OVER" );
			var pressed : HeaderLabel = new HeaderLabel( "PRESSED" );

			normal2.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allNormal ) );
			disabled.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allDisabled ) );
			over.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allOver ) );
			pressed.addEventListener(MouseEvent.CLICK, Delegate.create( selectGroup, ComponentStates.allPressed ) );
			
			colHeader.addComponent( normal2 );
			colHeader.addComponent( disabled );
			colHeader.addComponent( over );
			colHeader.addComponent( pressed );
			l.upper = colHeader;
			
			var all : HeaderLabel = new HeaderLabel("ALL");
			l.upperLeft = all;
			all.addEventListener(MouseEvent.CLICK, clickAll);
			
			addComponent( rowHeader );
			addComponent( colHeader );			addComponent( all );
		}
		
		protected function selectGroup ( e : Event, a : Array ) : void
		{
			if( !_enabled )
				return;
				
			var i:uint;
			if( selectionContainsAll(a) )
				for each ( i in a )
					removeFromSelection( i, false );	
					
			else for each ( i in a )				addToSelection( i, false );
			
			updateSelection();
			fireSelectionEvent();
		}
		
		protected function removeFromSelection (i : uint, event : Boolean = true) : void
		{
			if( !_enabled )
				return;
				
			if( selectionContains(i ) )
				_selectedStates.splice( _selectedStates.indexOf(i), 1);
			
			if( event )
			{
				updateSelection();
				fireSelectionEvent();
			}
		}

		protected function addToSelection (i : uint, event : Boolean = true) : void
		{
			if( !_enabled )
				return;
				
			if( !selectionContains( i ) )
				_selectedStates.push( i );
			
			if( event )
			{
				updateSelection();
				fireSelectionEvent();
			}
		}
		
		protected function selectionContainsSome ( a : Array ) : Boolean
		{
			var b : Boolean = false;
			
			for each ( var i:uint in a )
				b ||= selectionContains(i);
			
			return b;
		}
		protected function selectionContainsAll ( a : Array ) : Boolean
		{
			var b : Boolean = true;
			
			for each ( var i:uint in a )
				b &&= selectionContains(i);
			
			return b;
		}
		
		protected function selectionContains (i : uint) : Boolean
		{
			return _selectedStates.indexOf( i ) != -1;
		}
		protected function styleSelectionChange (event : StyleSelectionEvent) : void 
		{
			clearSelection();
			targetStyle = event.style;
		}
		protected function clickAll (event : MouseEvent) : void
		{
			if( !_enabled )
				return;
			
			if( _selectedStates.length == 16 )
				clearSelection();
			else
				selectAll();
		}
		
		protected function clickOnCell (event : MouseEvent) : void
		{
			if( !_enabled )
				return;
			
			var prev : StyleStatePreview = event.target as StyleStatePreview;
			var index : int = _selectedStates.indexOf( prev.targetState);
			if( index == -1 )
			{
				_selectedStates.push( prev.targetState );
				prev.selected = true;
			}
			else
			{
				_selectedStates.splice( index, 1);
				prev.selected = false;
			}
			fireSelectionEvent ();
		}
		protected function createStates () : void
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _statesPreview = new Array(16); }
			TARGET::FLASH_10 { _statesPreview = new Vector.<StyleStatePreview>(16,true); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_statesPreview = new Vector.<StyleStatePreview>(16,true); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			for( var i:int=0;i<16;i++ )
			{
				var p : StyleStatePreview = new StyleStatePreview();
				p.addEventListener(MouseEvent.CLICK, clickOnCell );
				_statesPreview[i] = p;
				_statesGrid.addComponent( p );
			}
		}
		protected function fireSelectionEvent () : void
		{
			_model.selectedStates = _selectedStates;
			dispatchEvent( new ComponentEvent(ComponentEvent.SELECTION_CHANGE ) );
		}
	}
}

import aesia.com.ponents.builder.styles.DefaultComponentPreview;
import aesia.com.ponents.core.AbstractContainer;
import aesia.com.ponents.layouts.components.GridLayout;
import aesia.com.ponents.layouts.display.DOInlineLayout;
import aesia.com.ponents.skinning.ComponentStyle;
import aesia.com.ponents.text.Label;

[Skinable(skin="StyleStatePreview")]
[Skin(define="StyleStatePreview",
		  inherit="DefaultComponent",
		  
		  state__all__insets="new aesia.com.ponents.utils::Insets(5)",
		  state__all__foreground="new aesia.com.ponents.skinning.decorations::NoDecoration()"
)]
internal class StyleStatePreview extends AbstractContainer
{
	protected var _preview : StyleStateDisplay;
	protected var _targetStyle : ComponentStyle;
	protected var _targetState : uint;

	public function StyleStatePreview ()
	{
		_childrenLayout = new GridLayout(this, 1, 1, 0, 0);
		super();
		_preview = new StyleStateDisplay();
		mouseChildren = false;
		_allowMask = false;
			
		addComponent( _preview );
	}
	public function set selected ( b : Boolean ) : void
	{
		_selected = b;
		invalidate(true); 
	}

	public function get targetStyle () : ComponentStyle { return _targetStyle; }
	public function set targetStyle (targetStyle : ComponentStyle) : void
	{
		_targetStyle = targetStyle;
		_preview.style = _targetStyle;
	}
	
	public function get targetState () : uint { return _targetState; }	
	public function set targetState (state : uint) : void
	{
		_targetState = state;
		/*
		if( _targetState == ComponentStates.DISABLED + ComponentStates.FOCUS ||
			_targetState == ComponentStates.DISABLED + ComponentStates.FOCUS + ComponentStates.SELECTED )
			
			removeComponent( _preview );
		*/
		_preview.state = _targetState;
	}
}
[Skinable(skin="NoDecorationComponent")]
internal class StyleStateDisplay extends DefaultComponentPreview
{
	public function StyleStateDisplay ()
	{
		super( );
		_state = 1;
		interactive = false;
		invalidate(true);
	}
	public function set state( n : uint ) : void
	{
		_state = n;		
		invalidate(true);
	}

	override protected function checkState () : void
	{
		_style.currentState = _state;
	}

	public function set style ( s : ComponentStyle ) : void
	{
		_style.defaultStyleKey = s.fullStyleName;
		
		invalidate(true );
	}
}
[Skinable(skin="HeaderLabel")]
[Skin(define="HeaderLabel",
		  inherit="EmptyComponent",
		  
		  state__all__format="new flash.text::TextFormat('Verdana', 8)",
		  state__over__background="new aesia.com.ponents.skinning.decorations::SimpleFill(color(Gainsboro))"
		  
)]
internal class HeaderLabel extends Label
{
	public function HeaderLabel ( l : String )
	{
		super( l );
		allowOver = true;
		childrenLayout = new DOInlineLayout( _childrenContainer );
	}
}