package abe.com.mands 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class ProxyCommand extends AbstractCommand 
	{
		private var fn : Function;
		private var args : Array;

		public function ProxyCommand ( fn : Function, ... args )
		{
			super();
			this.fn = fn;
			this.args = args;
		}

		override public function execute( ... a ) : void
		{
			fn.apply( null, args );
			commandEnded.dispatch( this );
		}
	}
}
