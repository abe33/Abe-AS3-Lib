package abe.com.mands
{
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class TimedCommands extends AbstractMacroCommand
    {
        
        protected var _delay : Number;
        protected var _callbackCount : int;
        protected var _iterator : int;
        
        public function TimedCommands ( delay : Number = 100, ... commands )
        {
            super ();
            reset();
            
            _delay = delay;
            
            for each( var c : Command in commands )
                addCommand( c );
        }
        override public function execute ( ...args ) : void
        {
            runNext();
        }
        protected function runNext():void
        {
            var c : Command = _aCommands[_iterator++];
            c.commandEnded.add(onSubCommandEnded);
            c.execute();
            if( _iterator < _aCommands.length )
            	setTimeout( runNext, _delay );
        }
        private function onSubCommandEnded( c : Command ) : void {
            _callbackCount++;
            if( _callbackCount == _aCommands.length )
            	commandEnded.dispatch( this );
        }
        public function reset():void
        {
            _callbackCount = 0;
            _iterator = 0;
        }
    }
}
