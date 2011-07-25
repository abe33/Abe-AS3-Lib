/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
    import abe.com.mands.Command;
    import abe.com.mon.core.Cancelable;
    import abe.com.mon.utils.DateUtils;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.containers.Dialog;
    import abe.com.ponents.skinning.icons.Icon;

    import org.osflash.signals.Signal;
    /**
     * @author Cédric Néhémie
     */
    public class CalendarAction extends AbstractAction implements Cancelable
    {
        protected var _date : Date;
        protected var _dateFormat : String;
        protected var _cancelled : Boolean;
        protected var _dial : Dialog;
        
        protected var _commandCancelled : Signal;
        
        public function CalendarAction ( date : Date, dateFormat : String = "d/m/Y", icon : Icon = null, accelerator : KeyStroke = null)
        {
            _date = date;
            _dateFormat = dateFormat;
            _commandCancelled = new Signal(Command);
            super( DateUtils.format(_date, _dateFormat ), icon, _("Change date"), accelerator );
        }

        override public function execute( ... args ) : void
        {
            _isRunning = true;
            _cancelled = false;
            CalendarInstance.date = DateUtils.cloneDate(_date);
            
            _dial = new Dialog( _("Select Date"), 3, CalendarInstance );
            _dial.dialogResponded.add( dialogResponded );
            _dial.open();
        }
        private function dialogResponded ( d : Dialog, result : uint ) : void
        {
            switch( result )
            {
                case Dialog.RESULTS_OK : 
                    _date = CalendarInstance.date;
                    name = DateUtils.format( _date, _dateFormat );
                    _commandEnded.dispatch( this );
                    break;
                    
                default : 
                    _commandCancelled.dispatch( this );
                    break;
            }
            _isRunning = false;
            _dial.close();    
            _dial.dialogResponded.remove( dialogResponded );
            _dial = null;
        }

        public function get date () : Date { return _date; }        
        public function set date (date : Date) : void
        {
            _date = date;
            name = DateUtils.format( _date, _dateFormat );
        }
        public function cancel () : void
        {
            _dial.close();    
            _dial.dialogResponded.remove( dialogResponded );
            _dial = null;
            _cancelled = true;
            _isRunning = false;
            _commandCancelled.dispatch( this );
        }
        public function isCancelled () : Boolean { return _cancelled; }
        public function get commandCancelled () : Signal { return _commandCancelled; }
    }
}

import abe.com.ponents.tools.Calendar;

internal const CalendarInstance : Calendar = new Calendar();
