package abe.com.mon.core.impl 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Allocator;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.Reflection;

	import flash.utils.Dictionary;

	/**
	 * The <code>AllocatorImpl</code> class is a standard implementation of
	 * the <code>Allocator</code> interface. That implementation is fully generic,
	 * it means an <code>AllocatorImpl</code> instance can instanciate any type
	 * of objects, each type will have its own pool of instances. The objects
	 * implementing the <code>Allocable</code> interface are handled by the 
	 * <code>AllocatorImpl</code>.
	 * <p>
	 * Internally, each pool for each type are stored in a <code>Dictionary</code>
	 * with the type of the pool as the key and a typed <code>Vector</code> as value.
	 * The <code>Vector</code> is typed using the type of the pool.
	 * </p>
	 * 
	 * <fr>
	 * La classe <code>AllocatorImpl</code> fournie une implémentation standard
	 * de l'interface <code>Allocator</code>. Cette implémentation est complètement
	 * générique, c'est-à-dire qu'elle permet d'instancier n'importe quel type d'objet, 
	 * chaque type d'objets ayant ses propres piles d'instances. Elle prend aussi 
	 * en charge les objets de type <code>Allocable</code>.
	 * <p>
	 * En interne, chaque pile de chaque type est conservé dans un objet <code>Dictionary</code>
	 * avec le type d'objet en clé d'accès et un <code>Vector</code> typé en valeur. Le type
	 * du vecteur est bien entendu celui des instances qu'il contient.
	 * </p>
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 * @see abe.com.mon.core.Allocator	 * @see abe.com.mon.core.Allocable	 * @see abe.com.mon.utils.AllocatorInstance
	 */
	public class AllocatorImpl implements Allocator
	{
		/**
		 * Default value for the unused instances limitations.
		 * 
		 * <fr>Valeur par défaut pour la limite d'instances.</fr>
		 */
		static public var MAXIMUM_UNUSED_OBJECTS : Number = 50;
		
		/**
		 * A <code>Dictionary</code> that store the maximum unused instances
		 * per type.
		 * <fr>
		 * Objet <code>Dictionary</code> contenant valeurs maximum d'instances inutilisées
		 * par types.
		 * </fr>
		 * @default	new Dictionary()
		 */
		protected var maxUnusedObjects : Dictionary;
		/**
		 * A <code>Dictionary</code> that stores the pools of unused instances
		 * for each type.
		 * <fr>
		 * Objet <code>Dictionary</code> contenant les différentes piles d'objets
		 * inutilisés, accessible par le type d'objet.
		 * </fr>
		 * @default	new Dictionary()
		 */
		protected var unusedObjects : Dictionary;
		/**
		 * A <code>Dictionary</code> that stores the size of each pool of unused instances.
		 * <fr>
		 * Un dictionnaire contenant le nombre d'instances inutilisées par type.
		 * </fr>
		 * @default	new Dictionary()
		 */		protected var unusedObjectsCount : Dictionary;
		/**
		 * An integer which store the total count of unused instances accross all the pools
		 * of this instance.
		 * <fr>
		 * Un entier représetant le nombre d'instances inutilisées total
		 * quelque soit le type.
		 * </fr>
		 */		protected var unusedObjectsTotal : int;
		
		/**
		 * A <code>Dictionary</code> that stores the pools of used instances
		 * for each type.
		 * <fr>
		 * Objet <code>Dictionary</code> contenant les différentes piles d'objets
		 * utilisés, accessible par le type d'objet.
		 * </fr>
		 * @default new Dictionary()
		 */
		protected var usedObjects : Dictionary;
		/**
		 * A <code>Dictionary</code> that stores the size of each pool of used instances.
		 * <fr>
		 * Un dictionnaire contenant le nombre d'instances utilisées par type. 
		 * </fr>
		 */		protected var usedObjectsCount : Dictionary;
		/**
		 * An integer which store the total count of used instances accross all the pools
		 * of this instance.
		 * <fr>
		 * Un entier représetant le nombre d'instances utilisées total
		 * quelque soit le type.
		 * </fr>
		 */		protected var usedObjectsTotal : int;
		
		/**
		 * Nothing special in the constructor, the different dictionaries
		 * are initialized. 
		 * <fr>
		 * Rien à voir par ici. Les dictionnaires sont juste initialisés.
		 * </fr>
		 */
		public function AllocatorImpl ()
		{
			maxUnusedObjects = new Dictionary();			unusedObjects = new Dictionary();			unusedObjectsCount = new Dictionary();			usedObjects = new Dictionary();			usedObjectsCount = new Dictionary();
			
			usedObjectsTotal = 0;			unusedObjectsTotal = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get ( c : Class, defaults : Object = null ) : *
		{
			// on initialise les vecteurs si aucun n'existe pour ce type
			if( !usedObjects[ c ] )
			{
				/*FDT_IGNORE*/ TARGET::FLASH_9 { /*FDT_IGNORE*/
				var v1 : Array = [];				var v2 : Array = [];
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				/*FDT_IGNORE*/ TARGET::FLASH_10 { /*FDT_IGNORE*/
				var v1 : Vector.<*>;
				var v2 : Vector.<*>;
				try
				{
					var def : Class = Reflection.getVectorDefinition( c );
					v1 = new def();					v2 = new def();				}
				catch( e : Error )
				{
					v1 = new Vector.<*>();
					v2 = new Vector.<*>();
				}	
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				/*FDT_IGNORE*/ TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				var v1 : Vector.<*>;
				var v2 : Vector.<*>;
				try
				{
					var def : Class = Reflection.getVectorDefinition( c );
					v1 = new def();
					v2 = new def();
				}
				catch( e : Error )
				{
					v1 = new Vector.<*>();
					v2 = new Vector.<*>();
				}
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				usedObjects[ c ] = v1;
				unusedObjects[ c ] = v2;
				usedObjectsCount[ c ] = 0;
				unusedObjectsCount[ c ] = 0;	
			}
			
			// récupération de références aux vecteurs typés
			/*FDT_IGNORE*/ TARGET::FLASH_9 { /*FDT_IGNORE*/
			var used : Array = usedObjects[ c ] as Array;
			var unused : Array  = unusedObjects[ c ] as Array;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ TARGET::FLASH_10 { /*FDT_IGNORE*/
			var used : Vector.<*> = usedObjects[ c ] as Vector.<*>;			var unused : Vector.<*>  = unusedObjects[ c ] as Vector.<*>;				
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var used : Vector.<*> = usedObjects[ c ] as Vector.<*>;
			var unused : Vector.<*>  = unusedObjects[ c ] as Vector.<*>;				
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
						var o : Object;
			
			// on récupère prioritairement une instance 
			// déjà existante si il en existe
			if( unused.length > 0 ) 
			{
				o = unused.pop();
				unusedObjectsCount[ c ] = unused.length;
				unusedObjectsTotal--;
			}
			else
				o = new c();
			
			// on affecte les valeurs par défaut si il en existe
			if( defaults )
			{
				if( o.hasOwnProperty( "setDefaults" ) )
					o["setDefaults"]( defaults );
				else
					for(var i : String in defaults)
						if( o.hasOwnProperty( i ) )
							o[ i ] = defaults[ i ]; 
			}
			
			// initialisation des objets Allocable
			if( o is Allocable )
			  ( o as Allocable ).init();
			
			// on place l'instance dans la pile des instances utilisées  
			used.push( o );
			usedObjectsCount[ c ] = used.length;
			usedObjectsTotal++;
			//Log.debug( "in get for class " + c + " used:" + used.length + ", unused:" + unused.length );
			
			return o;
		}
		
		/**
		 * @inheritDoc
		 */
		public function release ( o : *, c : Class = null ) : void
		{
			var cl : Class = Reflection.getClass( o );
			
			/*FDT_IGNORE*/ TARGET::FLASH_9 { /*FDT_IGNORE*/
			var used : Array = usedObjects[ c ] as Array;
			var unused : Array  = unusedObjects[ c ] as Array;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ TARGET::FLASH_10 { /*FDT_IGNORE*/
			var used : Vector.<*> = usedObjects[ c ] as Vector.<*>;
			var unused : Vector.<*>  = unusedObjects[ c ] as Vector.<*>;				
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var used : Vector.<*> = usedObjects[ c ] as Vector.<*>;
			var unused : Vector.<*>  = unusedObjects[ c ] as Vector.<*>;				
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			if( !used || !unused )
				return;
			
			if( used.indexOf( o ) == -1 )
			{
				Log.warn( "The instance " + o + " can't be released by this allocator" );
				return;
			}
	
			// libération des objets Allocable
			if( o is Allocable )
			  ( o as Allocable ).dispose();
			
			used.splice( used.indexOf(o), 1 );
			usedObjectsCount[ c ] = used.length;
			usedObjectsTotal--;
			/*
			if( unused.length < ( !isNaN(maxUnusedObjects[cl]) ? maxUnusedObjects[cl] : MAXIMUM_UNUSED_OBJECTS ) )
			{*/
				unused.push(o);
				unusedObjectsTotal++;
			//}
			unusedObjectsCount[ c ] = unused.length;
		}
		/**
		 * Set the maximum of unused instances of the type <code>cl</code> that this allocator
		 * can store.
		 * <fr>
		 * Définie le nombre limite d'instance inutilisées de la classe <code>cl</code> que cet allocateur
		 * peut contenir à un instant <code>t</code>.
		 * </fr>
		 * @param	cl	the class for which set a maximum
		 * 				<fr>la classe pour laquelle on opère la restriction</fr>
		 * @param	max	the maximum amount of instance this instance can store
		 * 				<fr>le nombre maximum d'instance de la classe que peut contenir
		 * 				le dictionnaire des instances inutilisées</fr>
		 */
		public function setMaximumUnusedCapacity( cl : Class, max : uint ) : void
		{
			maxUnusedObjects[cl] = max;
		}
		/**
		 * Returns the count of used instance of the type <code>cl</code>.
		 * <fr>
		 * Renvoie le nombre d'instances en cours d'utilisation pour le 
		 * type <code>cl</code>.
		 * </fr>
		 * @param	cl	the type for which returning the used instances count
		 * 				<fr>type dont on souhaite connaitre le compte
		 * 				d'instances utilisées</fr>
		 * @return	the count of used instance of the type <code>cl</code>
		 * 			<fr>le nombre d'instances en cours d'utilisation</fr>
		 */
		public function getUsedObjectsCount( cl : Class = null ) : int
		{
			if( !cl )
			{
				return usedObjectsTotal;
			}
			else
			{
				if( usedObjectsCount[cl] != undefined )
					return usedObjectsCount[cl];
				else 
					return 0;
			}
		}
		/**
		 * Returns the count of unused instance of the type <code>cl</code>.
		 * <fr>
		 * Renvoie le nombre d'instances inutilisées pour le 
		 * type <code>cl</code>.
		 * </fr>
		 * @param	cl	the type for which returning the unused instances count
		 * 				<fr>type dont on souhaite connaitre le compte
		 * 				d'instances inutilisées</fr>
		 * @return	the count of unused instance of the type <code>cl</code>
		 * 			<fr>le nombre d'instances inutilisées</fr>
		 */
		public function getUnusedObjectsCount( cl : Class = null ) : int
		{
			if( !cl )
			{
				return unusedObjectsTotal;
			}
			else
			{
				if( unusedObjectsCount[cl] != undefined )
					return unusedObjectsCount[cl];
				else 
					return 0;
			}
		}
		/**
		 * Returns the number of instances of the type <code>cl</code>
		 * created by this instance. The returned value is the sum
		 * of the unused instances count and the used instances count.
		 * <fr>
		 * Renvoie le nombre d'instances créées pour le type <code>cl</code>.
		 * Ce compte comprend les instances en cours d'utilisation et celle
		 * dans la piles des instances inutilisées.
		 * </fr>
		 * @param	cl	the class for which computing the total count
		 * 				<fr>type dont on souhaite connaitre le compte
		 * 				d'instances total</fr>
		 * @return	the number of instances of the type <code>cl</code>
		 * 			created by this instance
		 * 			<fr>le nombre d'instances total</fr>
		 */
		public function getTotalAllocated ( cl : Class ) : int
		{
			return getUnusedObjectsCount(cl) + getUsedObjectsCount(cl);
		}
	}
}
