package aesia.com.mon.core.impl 
{
	import aesia.com.mon.core.Allocable;
	import aesia.com.mon.core.Allocator;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Reflection;

	import flash.utils.Dictionary;

	/**
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
	 * 
	 * @author Cédric Néhémie
	 * @see aesia.com.mon.core.Allocator	 * @see aesia.com.mon.core.Allocable	 * @see aesia.com.mon.utils.AllocatorInstance
	 */
	public class AllocatorImpl implements Allocator
	{
		/**
		 * Valeur par défaut pour la limite d'instances.
		 */
		static public var MAXIMUM_UNUSED_OBJECTS : Number = 50;
		
		/**
		 * Objet <code>Dictionary</code> contenant valeurs maximum d'instances inutilisées
		 * par types.
		 * 
		 * @default	new Dictionary()
		 */
		protected var maxUnusedObjects : Dictionary;
		/**
		 * Objet <code>Dictionary</code> contenant les différentes piles d'objets
		 * inutilisés, accessible par le type d'objet.
		 * 
		 * @default	new Dictionary()
		 */
		protected var unusedObjects : Dictionary;
		/**
		 * Un dictionnaire contenant le nombre d'instances inutilisées par type. 
		 */		protected var unusedObjectsCount : Dictionary;
		/**
		 * Un entier représetant le nombre d'instances inutilisées total
		 * quelque soit le type.
		 */		protected var unusedObjectsTotal : int;
		
		/**
		 * Objet <code>Dictionary</code> contenant les différentes piles d'objets
		 * utilisés, accessible par le type d'objet.
		 * 
		 * @default new Dictionary()
		 */
		protected var usedObjects : Dictionary;
		/**
		 * Un dictionnaire contenant le nombre d'instances utilisées par type. 
		 */		protected var usedObjectsCount : Dictionary;
		/**
		 * Un entier représetant le nombre d'instances utilisées total
		 * quelque soit le type.
		 */		protected var usedObjectsTotal : int;
		
		/**
		 * Rien à voir par ici. Les dictionnaires sont juste initialisés.
		 */
		public function AllocatorImpl ()
		{
			maxUnusedObjects = new Dictionary();			unusedObjects = new Dictionary();			unusedObjectsCount = new Dictionary();			usedObjects = new Dictionary();			usedObjectsCount = new Dictionary();
			
			usedObjectsTotal = 0;			unusedObjectsTotal = 0;
		}
		
		/**
		 * Renvoie une instance de la classe <code>c</code> initialisées avec
		 * les données présentes dans <code>defaults</code>. 
		 * <p>
		 * Si la classe <code>c</code> implémente l'interface <code>Allocable</code>,
		 * la fonction <code>init</code> de l'objet sera appelée. 
		 * La fontion <code>init</code> sera appelée <u>après</u> l'affectation
		 * des valeurs par défauts.
		 * </p>
		 * 
		 * @param	c			la classe de l'objet à allouer
		 * @param	defaults 	un objet contenant les valeurs par défaut pour les 
		 * 					   	propriétés de l'objet alloué. 
		 * @return	une instance de la classe <code>c</code>
		 * @see		Allocable
		 */
		public function get ( c : Class, defaults : Object = null ) : *
		{
			// on initialise les vecteurs si aucun n'existe pour ce type
			if( !usedObjects[ c ] )
			{
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
				usedObjects[ c ] = v1;				unusedObjects[ c ] = v2;
				usedObjectsCount[ c ] = 0;
				unusedObjectsCount[ c ] = 0;
			}
			
			// récupération de références aux vecteurs typés
			var used : Vector.<*> = ( usedObjects[ c ] as Vector.<*> );			var unused : Vector.<*>  = ( unusedObjects[ c ] as Vector.<*> );			var o : Object;
			
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
		 * Libère l'instance passée en paramètre de la pile des instances
		 * utilisées et la déplace vers la pile des instances inutilisées.
		 * <p>
		 * Si l'instance implémente <code>Allocable</code> alors la méthode
		 * <code>dispose</code> sera appelée sur l'objet durant sa libération.
		 * </p>
		 * <p>
		 * La collection à laquelle l'instance appartient est déterminé à l'aide
		 * de la fonction <code>Reflection.getClass()</code>.
		 * </p>
		 * 
		 * @param	o	l'objet à libérer de la pile d'allocation
		 * @param	c	[optionel] le type définissant la collection d'instances 
		 * 				à laquelle appartient l'objet courant.
		 * @see		aesia.com.mon.utils.Reflection#getClass()		 * @see		Allocable
		 */
		public function release ( o : *, c : Class = null ) : void
		{
			var cl : Class = Reflection.getClass( o );
			var used : Vector.<*>  = ( usedObjects[ cl ] as Vector.<*> );
			var unused : Vector.<*>  = ( unusedObjects[ cl ] as Vector.<*> );
			
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
		 * Définie le nombre limite d'instance inutilisées de la classe <code>cl</code> que cet allocateur
		 * peut contenir à un instant <code>t</code>.
		 * 
		 * @param	cl	la classe pour laquelle on opère la restriction
		 * @param	max	le nombre maximum d'instance de la classe que peut contenir
		 * 				le dictionnaire des instances inutilisées.
		 */
		public function setMaximumUnusedCapacity( cl : Class, max : uint ) : void
		{
			maxUnusedObjects[cl] = max;
		}
		/**
		 * Renvoie le nombre d'instances en cours d'utilisation pour le 
		 * type <code>cl</code>.
		 * 
		 * @param	cl	type dont on souhaite connaitre le compte
		 * 				d'instances utilisées
		 * @return	le nombre d'instances en cours d'utilisation
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
		 * Renvoie le nombre d'instances inutilisées pour le 
		 * type <code>cl</code>.
		 * 
		 * @param	cl	type dont on souhaite connaitre le compte
		 * 				d'instances inutilisées
		 * @return	le nombre d'instances inutilisées
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
		 * Renvoie le nombre d'instances créées pour le type <code>cl</code>.
		 * Ce compte comprend les instances en cours d'utilisation et celle
		 * dans la piles des instances inutilisées.
		 * 
		 * @param	cl	type dont on souhaite connaitre le compte
		 * 				d'instances total
		 * @return	le nombre d'instances total
		 */
		public function getTotalAllocated ( cl : Class ) : int
		{
			return getUnusedObjectsCount(cl) + getUsedObjectsCount(cl);
		}
	}
}
