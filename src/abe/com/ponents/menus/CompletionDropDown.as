package abe.com.ponents.menus 
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.StageUtils;
	import abe.com.mon.utils.StringUtils;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.completion.AutoCompletion;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.events.AutoCompletionEvent;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.text.AbstractTextComponent;
	import abe.com.ponents.utils.ToolKit;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="CompletionDropDown")]
	[Skin(define="CompletionDropDown",
		  inherit="DefaultComponent",
		  
		  state__all__background="new deco::SimpleFill( skin.containerBackgroundColor )"
	)]
	public class CompletionDropDown extends Panel 
	{
		protected var _targetText : AbstractTextComponent;
		protected var _autoComplete : AutoCompletion;
		protected var _autoCompletePopup : ScrollPane;
		protected var _autoCompleteList : List;
		protected var _maxVisibleItems : Number;
		
		public function CompletionDropDown ( target : AbstractTextComponent, autoComplete : AutoCompletion )
		{
			super();
			
			_targetText = target;
			this.autoComplete = autoComplete;
			
			_autoCompleteList = new List();
			_autoCompleteList.dragEnabled = false;
			_autoCompleteList.dropEnabled = false;
			_autoCompleteList.editEnabled = false;
			_autoCompleteList.loseSelectionOnFocusOut = false;
			
			_autoCompletePopup = new ScrollPane();
			_autoCompletePopup.view = _autoCompleteList;
			
			_childrenLayout = new GridLayout(this,1, 1 );
			_maxVisibleItems = 5;
			
			addComponent( _autoCompletePopup );
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
			childrenContextEnabled = false;
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] =  new ProxyCommand(down);
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] =  new ProxyCommand(up);
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] =  new ProxyCommand(validateCompletion);
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.ESCAPE ) ] = new ProxyCommand(hide);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		public function get autoComplete () : AutoCompletion { return _autoComplete; }		
		public function set autoComplete (autoComplete : AutoCompletion) : void
		{
			if( _autoComplete )
				_autoComplete.removeEventListener( AutoCompletionEvent.ENTRIES_FOUND, entriesFound );
			
			_autoComplete = autoComplete;
			
			if( _autoComplete )
				_autoComplete.addEventListener( AutoCompletionEvent.ENTRIES_FOUND, entriesFound );
		}
		
		public function get targetText () : AbstractTextComponent { return _targetText;}	
		public function set targetText (targetText : AbstractTextComponent) : void
		{
			_targetText = targetText;
		}
		public function get maxVisibleItems () : Number { return _maxVisibleItems; }		
		public function set maxVisibleItems (maxVisibleItems : Number) : void
		{
			_maxVisibleItems = maxVisibleItems;
		}
		public function get hasSelection () : Boolean
		{
			return _autoCompleteList.selectedIndex != -1;
		}
		protected function entriesFound ( e : AutoCompletionEvent ) : void
		{
			if( !_targetText.displayed || !_targetText.hasFocus() )
				return;
			
			var autoComplete : AutoCompletion = (e.target as AutoCompletion);
			var lastCount : Number = autoComplete.lastSuggestionsCount;
			var lastSuggestions : Array = autoComplete.lastSuggestions;
			
			var hasEntries : Boolean = lastCount > 0;
			var hasMoreThanOneEntries : Boolean = lastCount > 1;
			var firstResultLongerThanMatch : Boolean = hasEntries && autoComplete.last.length < ( lastSuggestions[0] as String ).length;
			var hasPopup : Boolean = _autoCompletePopup != null;
			
			if( hasEntries )
			{
				if( hasMoreThanOneEntries || firstResultLongerThanMatch )
				{
					var a : Array = lastSuggestions.concat();
					
					for( var i : String in a )
					{
						a[ i ] = (a[i] as String).replace( new RegExp( "^("+ autoComplete.last+")", "i" ), "<font color='#888888'>$1</font>" );
					}
					
					( _autoCompleteList.model as DefaultListModel ).removeAllElements();
					( _autoCompleteList.model as DefaultListModel ).addMany(0, a);
					
					show();
				}
				else if( hasPopup && !firstResultLongerThanMatch )
				{
					hide();
				}
			}
			else if( !hasEntries && hasPopup )
			{
				hide();
			}
		}
		
		protected function updateSize () : void
		{
			var h : Number = Math.min( _autoCompleteList.preferredHeight, 
									   _autoCompleteList.getItemPreferredSize(0).height * _maxVisibleItems );
			
			var bb : Rectangle = _targetText.getBounds( ToolKit.popupLevel );
						
			x = bb.x;
			
			if( bb.y + bb.height + h > StageUtils.stage.stageHeight )
				y = bb.y - h;				
			else
				y = bb.y + bb.height;
			size = new Dimension( bb.width, h );
		}

		public function show () : void
		{
			updateSize();
			_autoCompleteList.selectedIndex = -1;
			ToolKit.popupLevel.addChild( this );
			_autoCompleteList.selectionChanged.add( selectionChanged );
			_autoCompleteList.mouseReleased.add( validateCompletion );
		}

		public function hide () : void
		{
			if( ToolKit.popupLevel.contains( this ) )
				ToolKit.popupLevel.removeChild( this );
			
			_autoCompleteList.selectionChanged.remove( selectionChanged );
			_autoCompleteList.mouseReleased.remove( validateCompletion );
			_autoCompleteList.selectedIndex = -1;
		}
		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents();
			stage.addEventListener( MouseEvent.CLICK, stageClick );
		}
		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents();
			stage.removeEventListener( MouseEvent.CLICK, stageClick );
		}
		protected function stageClick (event : MouseEvent) : void
		{
			if( !this.hitTestPoint( event.stageX , event.stageY ) )
				hide();
		}
		public function selectionChanged ( sel : * ) : void
		{	
		}
		public function validateCompletion ( c : Component = null ) : void
		{
			if( _autoCompletePopup )
			{
				_targetText.value = StringUtils.stripTags( _autoCompleteList.selectedValue as String );
				_targetText.setSelection( _targetText.text.length, _targetText.text.length );
				
				hide();
			}
		}
		
		public function up () : void
		{
			if( _autoCompleteList && _autoCompleteList.length > 0 )
			{
				if( !displayed )
					show();
				
				_autoCompleteList.selectPrevious();
			}
			else
				_autoComplete.forceChanged();
		}

		public function down () : void
		{
			if( _autoCompleteList && _autoCompleteList.length > 0 )
			{
				if( !displayed )
					show();
				
				_autoCompleteList.selectNext();
			}
			else
				_autoComplete.forceChanged();
		}
	}
}
