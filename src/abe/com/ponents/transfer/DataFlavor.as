/**
 * @license
 */
package  abe.com.ponents.transfer 
{
	import abe.com.mon.utils.StringUtils;
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Serializable;

	import flash.utils.getQualifiedClassName;

	/**
	 * Un objet <code>DataFlavor</code> représente un type de saveur 
	 * pour un objet <code>Transferable</code>.
	 */
	public class DataFlavor implements Cloneable, Serializable
	{
		/**
		 * Le type de cette saveur.
		 */
		public var type : String;
		
		/**
		 * Créer une nouvelle instance de la classe <code>DataFlavor</code>.
		 * 
		 * @param	type le type de cette saveur
		 */
		public function DataFlavor ( type : String )
		{
			this.type = type;
		}
		/**
		 * Renvoie <code>true</code> si l'instance courante est de la même
		 * nature de saveur que l'objet <code>DataFlavor</code> passé en
		 * paramètre.
		 * 
		 * @param	flavor	objet <code>DataFlavor</code> à comparer à cette instance
		 * @return	<code>true</code> si l'instance courante est de la même
		 * 			nature de saveur que l'objet <code>DataFlavor</code> passé en
		 * 			paramètre
		 */
		public function equals ( flavor : DataFlavor ) : Boolean
		{
			return flavor.type == type;
		}
		
		/**
		 * Renvoie <code>true</code> si la saveur de l'instance courante est
		 * présente dans le tableau de saveur passé en paramètre.
		 * 
		 * @param	flavor	objet <code>DataFlavor</code> à comparer à cette instance
		 * @return	<code>true</code> si la saveur de l'instance courante est
		 * 			présente dans le tableau de saveur passé en paramètre
		 */
		public function isSupported ( a : Array ) : Boolean
		{
			var t : DataFlavor = this;
			return a.some( function( f : DataFlavor, ... args ) : Boolean
			{
				return f.equals( t );
			} );		
		}

		/**
		 * @inheritDoc
		 */
		public function clone () : *
		{
			return new DataFlavor( this.type );
		}
		/**
		 * @inheritDoc
		 */
		public function toSource () : String
		{
			return "new abe.com.ponents.transfer.DataFlavor( '" + this.type +"' )";
		}
		public function toReflectionSource () : String
		{
			return "new abe.com.ponents.transfer::DataFlavor( '" + this.type +"' )";
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString () : String
		{
			return StringUtils.stringify(this, {"type":type});
		}
	}
}
