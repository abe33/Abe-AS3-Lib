package abe.com.mands.load 
{
	import abe.com.mands.AbstractCommand;

	import org.osflash.signals.Signal;

	import flash.net.URLRequest;
	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractLoadingEntry extends AbstractCommand implements LoadEntry 
	{		
		protected var _estimator : Estimator;
		protected var _callback : Function;
		
		protected var _ioErrorOccured : Signal; 
		protected var _securityErrorOccured : Signal; 
		protected var _loadOpened : Signal; 
		protected var _loadProgressed : Signal; 
		protected var _loadCompleted : Signal; 
		
		public function AbstractLoadingEntry ( callback : Function = null )
		{
			_ioErrorOccured = new Signal(String);
			_securityErrorOccured = new Signal(String);
			_loadOpened = new Signal(LoadEntry);
			_loadProgressed = new Signal(LoadEntry, Number, Number);
			_loadCompleted = new Signal(LoadEntry);
			_callback = callback;
		}
		
		public function get callback () : Function { return _callback; }
		public function set callback ( f : Function ) : void { _callback = f; }
		
		public function get estimator () : Estimator { return _estimator; }
		public function get request() : URLRequest { return null; }
		public function get ioErrorOccured () : Signal { return _ioErrorOccured; }
		public function get securityErrorOccured () : Signal { return _securityErrorOccured; }
		public function get loadOpened () : Signal { return _loadOpened; }
		public function get loadProgressed () : Signal { return _loadProgressed; }
		public function get loadCompleted () : Signal {	return _loadCompleted; }

		override public function execute( ... args ) : void 
		{
			load();
		}

		public function load () : void {}		
		
		public function fireIOErrorOccuredSignal ( msg : String ) : void
		{
			_ioErrorOccured.dispatch(msg);
			_commandFailed.dispatch( this, msg );
		}
		public function fireSecurityErrorOccuredSignal ( msg : String ) : void
		{
			_securityErrorOccured.dispatch(msg);
			_commandFailed.dispatch( this, msg );
		}
		public function fireLoadOpenedSignal () : void
		{
			_loadOpened.dispatch(this);
		}			
		public function fireLoadCompletedSignal () : void
		{
			_callback( this );
			_loadCompleted.dispatch(this);
			_commandEnded.dispatch(this);
		}
		public function fireLoadProgressedSignal ( loaded : Number, total : Number ) : void
		{
			_loadProgressed.dispatch( this, loaded, total );
		}
	}
}
