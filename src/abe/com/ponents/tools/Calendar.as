package abe.com.ponents.tools 
{
	import abe.com.mon.utils.DateUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.events.CalendarEvent;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.layouts.components.HBoxLayout;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.text.Label;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="Calendar")]
	[Skin(define="Calendar",
			  inherit="EmptyComponent"
			  
	)]
	[Skin(define="Calendar_IncrementDecrementButtons",
		  inherit="Button", 
		  state__all__insets="new cutils::Insets(3)",
		  state__all__corners="new cutils::Corners(2)"
	)]
	[Skin(define="Calendar_DayCell",
		  inherit="EmptyComponent", 
		  state__over__background="skin.overBackgroundColor",
		  state__disabled__background="skin.disabledBackgroundColor",
		  state__selected_focusandselected__background="skin.focusSelectedBackgroundColor"
	)]
	public class Calendar extends Panel 
	{
		[Embed(source="../skinning/icons/scrollleft.png")]
		static public var DEC_MONTH : Class;		
		[Embed(source="../skinning/icons/scrollright.png")]
		static public var INC_MONTH : Class;		
		[Embed(source="../skinning/icons/scrollleft2.png")]
		static public var DEC_YEAR : Class;		
		[Embed(source="../skinning/icons/scrollright2.png")]
		static public var INC_YEAR : Class;	
		
		protected var _date : Date;
		protected var _daysWeekPanel : Panel;
		protected var _yearMonthHeader : Panel;
		protected var _yearMonthLabel : Label;
		protected var _decrementYear : Button;
		protected var _incrementYear : Button;
		protected var _decrementMonth : Button;
		protected var _incrementMonth : Button;
		protected var _daysGrid : Panel;
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _daysButtons : Array;
		TARGET::FLASH_10
		protected var _daysButtons : Vector.<Button>;
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _daysButtons : Vector.<Button>;

		public function Calendar ( date : Date = null )
		{
			super();
			_date = date ? DateUtils.cloneDate( date ) : new Date();
			
			_daysWeekPanel = new Panel();
			_yearMonthLabel = new Label( _( DateUtils.MONTHS_NAMES[ _date.month ] ) + " " + _date.fullYear );
			
			_decrementYear = new Button( new ProxyAction( decrementYear, _("Previous Year"), magicIconBuild(DEC_YEAR)) );
			_incrementYear = new Button( new ProxyAction( incrementYear, _("Next Year"), magicIconBuild(INC_YEAR) ) );
			_decrementMonth = new Button( new ProxyAction( decrementMonth, _("Previous Month"), magicIconBuild(DEC_MONTH)) );
			_incrementMonth = new Button( new ProxyAction( incrementMonth, _("Next Month"), magicIconBuild(INC_MONTH)) );
			
			_decrementYear.styleKey = "Calendar_IncrementDecrementButtons";
			_incrementYear.styleKey = "Calendar_IncrementDecrementButtons";
			_decrementMonth.styleKey = "Calendar_IncrementDecrementButtons";
			_incrementMonth.styleKey = "Calendar_IncrementDecrementButtons";
			
			_decrementYear.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_incrementYear.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_decrementMonth.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_incrementMonth.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			
			_decrementMonth.disableButtonDuringActionExecution = false;
			_incrementMonth.disableButtonDuringActionExecution = false;
			_decrementYear.disableButtonDuringActionExecution = false;
			_incrementYear.disableButtonDuringActionExecution = false;
			
			_yearMonthHeader = new Panel();
			_yearMonthHeader.addComponents( _decrementYear, _decrementMonth, _yearMonthLabel, _incrementMonth, _incrementYear );
			_yearMonthHeader.childrenLayout = new HBoxLayout( _yearMonthHeader,1,
												new BoxSettings(0,"left","center", _decrementYear ),
												new BoxSettings(0,"left","center", _decrementMonth ),
												new BoxSettings(0,"center","center", _yearMonthLabel, false, false, true ),
												new BoxSettings(0,"right","center", _incrementMonth ),
												new BoxSettings(0,"right","center", _incrementYear )
											 );
			
			createGrid ();
			_childrenLayout = new BorderLayout(this);
			var l : BorderLayout = _childrenLayout as BorderLayout;
			l.north = _yearMonthHeader;
			l.center = _daysGrid;
			addComponents( _yearMonthHeader, _daysGrid );
			updateDaysGrid ();
		}
		
		public function get date () : Date { return _date; }		
		public function set date (date : Date) : void
		{
			_date = date;
			fireCalendarEvent( CalendarEvent.DATE_CHANGE );
			updateYearMonthLabel();
		}
		public function get year() : Number { return _date.fullYear; }
		public function set year( y : Number ) : void
		{
			_date.setFullYear( y );
			fireCalendarEvent( CalendarEvent.YEAR_CHANGE );
			fireCalendarEvent( CalendarEvent.DATE_CHANGE );
			updateYearMonthLabel();
		}
		public function get month() : Number { return  _date.month; }
		public function set month( m : Number ) : void
		{
			_date.setMonth( m );
			fireCalendarEvent( CalendarEvent.MONTH_CHANGE );
			fireCalendarEvent( CalendarEvent.DATE_CHANGE );
			updateYearMonthLabel();
		}
		
		public function decrementYear () : void { year--; }
		public function incrementYear () : void { year++; }
		
		public function decrementMonth () : void { month--; }
		public function incrementMonth () : void { month++; }
		
		protected function createGrid () : void
		{
			_daysGrid = new Panel( );
			_daysGrid.childrenLayout = new GridLayout( _daysGrid, 7, 7, 0, 0 );
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _daysButtons = new Array( 7 * 6 ); }
			TARGET::FLASH_10 { _daysButtons = new Vector.<Button>( 7 * 6 ); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_daysButtons = new Vector.<Button>( 7 * 6 ); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			var i : uint = 0;
			var x : int;
			var y : int;
			for(y=0;y<7;y++)
			{
				for(x=0;x<7;x++)
				{
					if(y==0)
					{
						var l : Label = new Label(DateUtils.getDayName(x).substr(0,3)+".");
						_daysGrid.addComponent(l);
					}
					else
					{
						var b : Button = new Button("0");
						b.styleKey = "Calendar_DayCell";
						_daysGrid.addComponent(b);
						_daysButtons[i]=b;
						i++;	
					}
				}
			}
		}

		protected function releaseGrid () : void
		{
			_daysGrid.removeAllComponents();
			removeComponent( _daysGrid );
			_daysGrid = null;
			_daysButtons = null;
		}
		protected function updateYearMonthLabel() : void
		{
			_yearMonthLabel.value = "<p align='center'>"+ _( DateUtils.MONTHS_NAMES[ _date.month ] ) + " " + _date.fullYear + "</p>";
			_yearMonthHeader.invalidate(true);
			updateDaysGrid();
		}
		protected function selectDate( d : uint ) : void
		{
			_date.date = d;
			fireCalendarEvent( CalendarEvent.DATE_CHANGE );
			updateYearMonthLabel(); 
		}
		protected function updateDaysGrid () : void
		{
			var month : uint = _date.month;
			var date : uint = _date.date;
			var fullYear : uint = _date.fullYear;
			var startDay : Number = new Date( fullYear, month, 1).getDay() > 0 ? new Date( fullYear, month, 1).getDay() : 6;
			
			var monthLength : Number = DateUtils.getMonthLength(fullYear, month);
			var l : uint = _daysButtons.length;
			var i : uint;
			
			for(i=0;i<l;i++)
			{
				var bt : Button = _daysButtons[i];
				var btd : Date = new Date( fullYear, month, i + 1 - startDay );
				bt.label = btd.date.toString();
				bt.action = new ProxyAction( selectDate, null, null, null, null, btd.date );
				
				if( i < startDay || i >= startDay + monthLength )
				{
					bt.enabled = false;
					bt.selected = false;
				}
				else
				{
					bt.enabled = true;
					if( btd.date == date )
						bt.selected = true;
					else
						bt.selected = false;
				}
				
			}
		}

		protected function fireCalendarEvent ( type : String) : void
		{
			dispatchEvent(new CalendarEvent(type));
		}
	}
}
