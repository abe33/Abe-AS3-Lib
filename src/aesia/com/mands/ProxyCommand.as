package aesia.com.mands 
{
	import aesia.com.mands.AbstractCommand;

	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class ProxyCommand extends AbstractCommand 
	{
		private var fn : Function;
		private var passEvent : Boolean;
		private var args : Array;

		public function ProxyCommand ( fn : Function, passEvent : Boolean = false, ... args )
		{
			super();
			this.fn = fn;
			this.passEvent = passEvent;
			this.args = args;
		}

		override public function execute (e : Event = null) : void
		{
			if( passEvent )
				fn.call( null, e );
			else
				fn.apply( null, args );
			fireCommandEnd();
		}
	}
}
