/**
 * @license
 */
package abe.com.edia.camera
{
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.Range;
    import abe.com.mon.geom.Rectangle2;
    import abe.com.mon.geom.pt;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.PointUtils;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.StringUtils;
    import abe.com.motion.Impulse;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	/**
	 * Un objet <code>Camera</code> permet de créer des effets de scrolling,
	 * de zoom et de parallax sur toute une scène flash de façon naturelle.
	 * le champ de la caméra est défini à l'aide d'un objet <code>Rectangle2</code>.
	 * Ce rectangle sert de référence pour tout les objets interagissant avec cette caméra.
	 * Lorsque ce rectangle change (position, taille) un évènement est diffusé et les objets
	 * écouteurs peuvent alors modifier leur état en fonction du nouvel état de la caméra.
	 * <p>
	 * Pour accomplir le scrolling, les écouteurs ont juste à transformer leur position tel que :
	 * <listing>
	 * object.x = -camera.screen.x;
	 * object.y = -camera.screen.y;</listing>
	 * </p><p>
	 * Pour accomplir la parallax, les écouteurs ont juste à altérer la position calculée en fonction
	 * du facteur de parallax, tel que :
	 * <listing>
	 * object.x = -camera.screen.x &#42; parallax;
	 * object.y = -camera.screen.y &#42; parallax;</listing>
	 * </p><p>
	 * Pour accomplir le zoom, les écouteurs doivent à la fois modifier leur position et leur échelle
	 * tel que :
	 * <listing>
	 * object.x = -camera.screen.x &#42; zoom &#42; parallax;
	 * object.y = -camera.screen.y &#42; zoom &#42; parallax;
	 * object.scaleX = zoom;
	 * object.scaleY = zoom;</listing>
	 * </p><p>
	 * La classe <code>CameraLayer</code> implémente de base tout ces comportements. Il suffit
	 * d'étendre cette classe, et d'ajouter chaque instance comme écouteur de l'évènement
	 * </p>
	 */
	public class Camera implements Runnable, Randomizable
	{
/*--------------------------------------------------------------------
 *	PROTECTED PROPERTIES
 *-------------------------------------------------------------------*/
		/**
		 * Détermine si le facteur d'incrément du zoom utilisé par les méthodes
		 * <code>zoomIn</code> et <code>zoomOut</code> multiplie/divise la valeur
		 * de zoom actuelle (<code>true</code>) ou est additionné/soustrait
		 * à la valeur de zoom (<code>false</code>).
		 * <p>
		 * Par défaut la valeur est ajouté au zoom.
		 * </p>
		 * @default	false
		 */
		public var multiplyZoom : Boolean = false;
		/**
		 * Valeur courante du zoom.
		 *
		 * @default 1
		 */
		protected var _zoom : Number;
		/**
		 * Valeur courante de l'incrément de zoom utilisé par les méthodes
		 * <code>zoomIn</code> et <code>zoomOut</code>.
		 *
		 * @default 0.1
		 */
		protected var _zoomIncrement : Number;
		/**
		 * Plage des valeurs autorisées pour le zoom.
		 */
		protected var _zoomRange : Range;
		/**
		 * Longueur du champ de la caméra sans les transformations opérées
		 * lors du zoom.
		 * <p>
		 * Cette valeur sert de référence lors des calculs de zoom.
		 * </p>
		 */
		protected var _safeWidth : Number;
		/**
		 * Hauteur du champ de la caméra sans les transformations opérées
		 * lors du zoom.
		 * <p>
		 * Cette valeur sert de référence lors des calculs de zoom.
		 * </p>
		 */
		protected var _safeHeight : Number;
		/**
		 * Un objet <code>Point</code> stockant le centre du champ de la caméra
		 * avant des modifications sur la taille de celui-ci.
		 *
		 * @default null
		 */
		protected var _safeCenter : Point;
		/**
		 * Valeur booléenne indiquant si la caméra est actuellement en train de trembler.
		 *
		 * @default false
		 */
		protected var _shaking : Boolean;
		/**
		 * La force du tremblement de la caméra en pixel. Le tremblement produit un décalage
		 * allant de <code>-_shakingStrength</code> à <code>_shakingStrength</code> sur les axes
		 * <code>x</code> et <code>y</code>.
		 */
		protected var _shakingStrength : Number;
		/**
		 * Un nombre représentant le temps écoulé depuis le lancement du tremblement de la caméra.
		 */
		protected var _shakingTime : Number;
		/**
		 * La durée courante du tremblement de la caméra.
		 */
		protected var _shakingDuration : Number;
		/**
		 * <code>Rectangle2</code> représentant le champ de la caméra.
		 */
		protected var _screen : Rectangle2;
		/**
		 * Une valeur booléenne indiquant si l'objet caméra diffuse un évènement
		 * <code>CAMERA_CHANGE</code> lors du changement d'une de ses propriétés.
		 * <p>
		 * Si <code>silentMode</code> vaut <code>true</code> aucun évènement n'est
		 * diffusé. La diffusion devra se faire de manière manuelle en utilisant
		 * la méthode <code>fireCameraChangedSignal</code>.
		 * </p>
		 * @default false
		 */
		public var silentMode : Boolean;
		/**
		 * Une valeur booléenne indiquant si la caméra est en cours d'animation.
		 *
		 * @default	false
		 */
		protected var _isRunning : Boolean;
		/**
		 * Un nombre représentant l'angle, en radians, de la rotation de la caméra.
		 *
		 * @default 0
		 */
		protected var _rotation : Number;
		/**
		 * 
		 */
		protected var _randomSource : Random;
		
        public var cameraChanged : Signal;
        protected var _zoomPrecision : Number;
		
		/**
		 * Créer une nouvelle instance de la classe <code>Camera</code>. Si aucun paramètre n'est
		 * renseigné, la caméra est initialisé aux dimensions du fichier SWF tel que renvoyer par
		 * l'instance de <code>Stage</code>, elle n'est soumise à aucune contrainte, et la plage
		 * de zoom va de <code>Number.NEGATIVE_INFINITY</code> à <code>Number.POSITIVE_INFINITY</code>.
		 *
		 * @param	screen			position et dimension initiale du champ de la caméra
		 * @param	constraints		espace autorisé à la caméra, par défaut la caméra n'est
		 * 							pas contraintes.
		 * @param	initialZoom		valeur de zoom initiale
		 * @param	zoomRange		plage de valeurs autorisées pour le zoom de la caméra
		 * @param	zoomIncrement	pas du zoom pour l'usage des fonctions <code>zoomIn</code>
		 * 							et <code>zoomOut</code>
		 * @param	silent			si <code>true</code> les modifications de la caméra ne diffusent
		 * 							aucun évènements. La diffusion devra être faite manuellement
		 * 							en appelant la méthode <code>fireCameraChangedSignal</code>
		 * @example On construit une nouvelle instance de la classe <code>Camera</code> :
		 * <listing>var camera : Camera = new Camera();</listing>
		 * On construit une nouvelle instance de la classe <code>Camera</code> avec des contraintes sur
		 * ses déplacements :
		 * <listing>var camera : Camera = new Camera( new Rectangle2( 100,100,480,320 ),
		 * 					new Rectangle2 (0,0,1000,1000) );</listing>
		 */
		public function Camera ( screen : Rectangle2 = null,
								 initialZoom : Number = 1,
								 zoomRange : Range = null,
								 zoomIncrement : Number = 0.1,
								 silent : Boolean = false )
		{
			cameraChanged = new Signal(Camera);
			_randomSource = RandomUtils;
            
        	_screen = screen ? screen : new Rectangle2( 0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );

			_safeWidth = _screen.width;
			_safeHeight = _screen.height;
			_safeCenter = _screen.center;
			_zoom = initialZoom;
			_zoomIncrement = zoomIncrement;
			_zoomRange = zoomRange ? zoomRange : new Range( Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY );
			_rotation = _screen.rotation;
			silentMode = silent;
            _zoomPrecision = 1000;
			_shaking = false;
			zoom = _zoom;
		}
/*--------------------------------------------------------------------
 *	GETTERS & SETTERS
 *-------------------------------------------------------------------*/
		/**
		 * Accès en lecture seule au <code>Rectangle2</code> du champ de la caméra.
		 * @example	Récupère une référence vers le rectangle visible de la caméra :
		 * <listing>var r : Rectangle2 = camera.screen;</listing>
		 */
		public function get screen () : Rectangle2 { return _screen; }
		/**
		 * Accès en lecture et en écriture à la position en x du coin supérieur
		 * gauche du champ de la caméra.
		 */
		public function get x () : Number { return _screen.x; }
		public function set x ( n : Number ) : void
		{
			moveToX( n );
		}
		/**
		 * Accès en lecture et en écriture à la position en y du coin supérieur
		 * gauche du champ de la caméra.
		 */
		public function get y () : Number { return _screen.y; }
		public function set y ( n : Number ) : void
		{
			moveToY( n );
		}
		/**
		 * Accès en lecture et en écriture à la longueur du champ de la caméra.
		 */
		public function get width () : Number { return _screen.width; }
		public function set width ( n : Number ) : void
		{
			resizeToW( n );
		}
		/**
		 * Accès en lecture et en écriture à la hauteur du champ de la caméra.
		 */
		public function get height () : Number { return _screen.height; }
		public function set height ( n : Number ) : void
		{
			resizeToH( n );
		}
		/**
		 * Un nombre représentant l'angle, en radians, de la rotation de la caméra.
		 */
		public function get rotation () : Number { return _rotation; }
		public function set rotation ( rotation : Number ) : void
		{
			_screen.rotateAroundCenter ( rotation - _screen.rotation );
			_rotation = _screen.rotation;
			fireSilentCameraChangedSignal();
		}
		/**
		 * Accès en lecture et en écriture au facteur de zoom de la caméra courante.
		 */
		public function get zoom () : Number { return _zoom; }
		public function set zoom ( zoom : Number ) : void
		{
			if( _zoomRange.surround( zoom ) )
			{
                var c : Point = _screen.center;
				_zoom = Math.floor( zoom * _zoomPrecision ) / _zoomPrecision;
				computeZoom();
                center( c );
			}
		}
		/**
		 * Accès en lecture et en écriture au facteur d'increment du zoom utilisé
		 * par les méthode <code>zoomIn</code> et <code>zoomOut</code>.
		 */
		public function get zoomIncrement () : Number { return _zoomIncrement; }
		public function set zoomIncrement ( n : Number ) : void
		{
			_zoomIncrement = n;
		}
		/**
		 * Accès en lecture et en écriture à la plage de zoom autorisé pour
		 * cette instance la classe <code>Camera</code>.
		 */
		public function get zoomRange () : Range { return _zoomRange; }
		public function set zoomRange ( zoomRange : Range ) : void
		{
			_zoomRange = zoomRange;
			solveZoom();
		}
		/**
		 * Longueur du champ de la caméra sans les transformations opérées
		 * lors du zoom.
		 * <p>
		 * Cette valeur sert de référence lors des calculs de zoom.
		 * </p>
		 */
		public function get safeWidth () : Number { return _safeWidth; }
		public function set safeWidth ( n : Number ) : void 
		{ 
			var z : Number = zoom;
			var c : Point = screenCenter;
			zoom = 1;
			width = n;
			zoom = z;
			screenCenter = c;
		}
		/**
		 * Hauteur du champ de la caméra sans les transformations opérées
		 * lors du zoom.
		 * <p>
		 * Cette valeur sert de référence lors des calculs de zoom.
		 * </p>
		 */
		public function get safeHeight () : Number { return _safeHeight; }
		public function set safeHeight ( n : Number ): void
		{ 
			var z : Number = zoom;
			var c : Point = screenCenter;
			zoom = 1;
			height = n;
			zoom = z;
			screenCenter = c;
		}
/*--------------------------------------------------------------------
 *	CENTER GETTER & SETTERS
 *-------------------------------------------------------------------*/
		/**
		 * Accès en lecture et en écriture au point figurant le centre du champ de la caméra.
		 * <p>
		 * Lorsque ce champs est accéder en lecture, une nouvelle instance de la classe
		 * <code>Point</code> est renvoyée, modifier ce point est donc inutile. Pour modifier
		 * le centre du champ de la caméra à l'aide de cette propriété il suffit de lui affecter
		 * un nouvel objet <code>Point</code>.
		 * </p><p>
		 * Il est aussi possible de modifier une seule coordonnée du centre à l'aide des propriétés
		 * <code>screenCenterX</code> et <code>screenCenterY</code>.
		 * </p>
		 */
		public function get screenCenter () : Point	{ return _screen.center; }
		public function set screenCenter ( p : Point ) : void
		{
			center ( p );
		}
		/**
		 * Accès en lecture et en écriture à la coordonnée en x du centre du champ de la caméra.
		 */
		public function get screenCenterX () : Number { return screenCenter.x; }
		public function set screenCenterX ( n : Number ) : void
		{
			centerX( n );
		}
		/**
		 * Accès en lecture et en écriture à la coordonnée en y du centre du champ de la caméra.
		 */
		public function get screenCenterY () : Number { return screenCenter.y; }
		public function set screenCenterY ( n : Number ) : void
		{
			centerY( n );
		}
		/**
		 * @inheritDoc
		 */
		public function get randomSource () : Random { return _randomSource;	}
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}
/*--------------------------------------------------------------------
 *	CENTER METHODS
 *-------------------------------------------------------------------*/
		/**
		 * Centre le champ de la caméra sur le point passé en paramètre. Si à l'issue
		 * de cette transformation la caméra se retrouve en dehors du cadre de contrainte,
		 * celle-ci sera déplacée afin de respecter les contraintes.
		 * @param	p	nouvelles coordonnées du centre
		 */
		public function center ( p : Point ) : void
		{
			centerXY ( p.x, p.y );
		}
		/**
		 * Centre le champ de la caméra sur les coordonnées passés en paramètre. Si à l'issue
		 * de cette transformation la caméra se retrouve en dehors du cadre de contrainte,
		 * celle-ci sera déplacée afin de respecter les contraintes.
		 * @param	x	nouvelle coordonnée en x du centre de la caméra
		 * @param	y	nouvelle coordonnée en y du centre de la caméra
		 */
		public function centerXY ( x : Number, y : Number ) : void
		{
			if( x != _safeCenter.x || y != _safeCenter.y )
			{
				_safeCenter.x = x;
				_safeCenter.y = y;

				if( !_shaking )
				{
					_screen.center = pt(x,y);
					fireSilentCameraChangedSignal ();
				}
			}
		}
		/**
		 * Centre le champ de la caméra en x sur la coordonnée passée en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	x	nouvelle coordonnée en x du centre de la caméra
		 */
		public function centerX ( x : Number ) : void
		{
			if( x != _safeCenter.x )
			{
				_safeCenter.x = x;

				if( !_shaking )
				{
					_screen.center = pt ( x, _safeCenter.y ) ;
					fireSilentCameraChangedSignal ();
				}
			}
		}
		/**
		 * Centre le champ de la caméra en y sur la coordonnée passée en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	y	nouvelle coordonnée en y du centre de la caméra
		 */
		public function centerY ( y : Number ) : void
		{
			if( y != _safeCenter.y )
			{
				_safeCenter.y = y;

				if( !_shaking )
				{
					_screen.center = pt ( _safeCenter.x, y ) ;
					fireSilentCameraChangedSignal ();
				}
			}
		}
		/**
		 * Centre le champ de la caméra sur le centre du <code>DisplayObject</code> passé
		 * en paramètre. Le centre de l'objet est déterminé à l'aide de la méthode <code>getBounds</code>,
		 * le centre étant le centre du rectangle retourné par la fonction.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	display	objet surlequel on souhaite centrer la caméra
		 */
		public function centerDisplayObject ( display : DisplayObject ) : void
		{
			if( display.parent )
			{
				var r : Rectangle = display.getBounds( display.parent );
				var x : Number = r.x + r.width / 2;
				var y : Number = r.y + r.height / 2;
				centerXY( x, y );
			}
			else
				centerXY( display.x, display.y );
		}
/*--------------------------------------------------------------------
 *	MOVE & TRANSLATE METHODS
 *-------------------------------------------------------------------*/
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra au coordonnées contenues
		 * dans l'objet <code>Point</code> passé en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	p	nouvelles coordonnées pour le coin supérieur gauche du champ de la
		 * 				caméra
		 */
		public function moveTo ( p : Point ) : void
		{
			moveToXY( p.x, p.y );
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra aux coordonnées passées en
		 * paramètres. Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	x	nouvelle coordonnée en x du coin supérieur gauche du champ de la
		 * 				caméra
		 * @param	y	nouvelle coordonnée en x du coin supérieur gauche du champ de la
		 * 				caméra
		 */
		public function moveToXY ( x : Number, y : Number ) : void
		{
			_safeCenter.x = x + _screen.width/2;
			_safeCenter.y = y + _screen.height/2;

			if( !_shaking )
			{
				_screen.x = x;
				_screen.y = y;
				fireSilentCameraChangedSignal ();
			}
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra sur l'axe x à la coordonnée
		 * passée en paramètre. Si à l'issue de cette transformation la caméra se retrouve en
		 * dehors du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	x	nouvelle coordonnée en x du coin supérieur gauche du champ de la
		 * 				caméra
		 */
		public function moveToX ( x : Number ) : void
		{
			_safeCenter.x = x+_screen.width/2;

			if( !_shaking )
			{
				_screen.x = x;
				fireSilentCameraChangedSignal ();
			}
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra sur l'axe y à la coordonnée
		 * passée en paramètre. Si à l'issue de cette transformation la caméra se retrouve en
		 * dehors du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	y	nouvelle coordonnée en y du coin supérieur gauche du champ de la
		 * 				caméra
		 */
		public function moveToY ( y : Number ) : void
		{
			_safeCenter.y = y+_screen.height/2;

			if( !_shaking )
			{
				_screen.y = y;
				fireSilentCameraChangedSignal ();
			}
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra d'autant de pixels que spécifié
		 * dans l'objet <code>Point</code> passé en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	p	valeur de translation de la caméra sur chaque axe
		 */
		public function translate ( p : Point ) : void
		{
			translateXY ( p.x, p.y );
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra d'autant de pixels
		 * que spécifié en paramètres.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	x	valeur de translation sur l'axe x
		 * @param	y	valeur de translation sur l'axe y
		 */
		public function translateXY ( x : Number, y : Number ) : void
		{
			_safeCenter.x += x;
			_safeCenter.y += y;

			if( !_shaking )
			{
				_screen.offset( x, y );
				fireSilentCameraChangedSignal ();
			}
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra d'autant de pixels
		 * que spécifié en paramètres.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	x	valeur de translation sur l'axe x
		 */
		public function translateX ( x : Number ) : void
		{
			_safeCenter.x += x;

			if( !_shaking )
			{
				_screen.offset( x, 0 );
				fireSilentCameraChangedSignal ();
			}
		}
		/**
		 * Déplace le coin supérieur gauche du champ de la caméra d'autant de pixels
		 * que spécifié en paramètres.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 *
		 * @param	y	valeur de translation sur l'axe y
		 */
		public function translateY ( y : Number ) : void
		{
			_safeCenter.y += y;

			if( !_shaking )
			{
				_screen.offset( 0, y );
				fireSilentCameraChangedSignal ();
			}
		}
/*--------------------------------------------------------------------
 *	RESIZING METHODS
 *-------------------------------------------------------------------*/
		/**
		 * Redimensionne la caméra au dimension fournies dans l'objet <code>Dimension</code>
		 * passé en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 * <p>
		 * Le redimensionnement d'une caméra en utilisant les méthodes <code>resizeTo&#42;</code>
		 * n'affectent pas la position du champ de la caméra. Cela signifie que le centre de
		 * la caméra aura été modifié après un appel à l'une des méthode de redimensionnement.
		 * </p>
		 *
		 * @param	d	nouvelle dimension du champ de la caméra.
		 */
		public function resizeTo ( d : Dimension ) : void
		{
			resizeToWH ( d.width, d.height );
		}
		/**
		 * Redimensionne la caméra au dimension fournies en paramètres.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 * <p>
		 * Le redimensionnement d'une caméra en utilisant les méthodes <code>resizeTo&#42;</code>
		 * n'affectent pas la position du champ de la caméra. Cela signifie que le centre de
		 * la caméra aura été modifié après un appel à l'une des méthode de redimensionnement.
		 * </p>
		 * @param	w	nouvelle longueur du champ de la caméra
		 * @param	h	nouvelle hauteur du champ de la caméra
		 */
		public function resizeToWH ( w : Number, h : Number ) : void
		{
			_safeWidth = w;
			_safeHeight = h;

			solveZoom();
		}
		/**
		 * Redimensionne la longueur du champ de la caméra à la dimension fournie en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 * <p>
		 * Le redimensionnement d'une caméra en utilisant les méthodes <code>resizeTo&#42;</code>
		 * n'affectent pas la position du champ de la caméra. Cela signifie que le centre de
		 * la caméra aura été modifié après un appel à l'une des méthode de redimensionnement.
		 * </p>
		 *
		 * @param	w	nouvelle longueur du champ de la caméra
		 */
		public function resizeToW ( w : Number ) : void
		{
			_safeWidth = w;

			solveZoom();
		}
		/**
		 * Redimensionne la hauteur du champ de la caméra à la dimension fournie en paramètre.
		 * Si à l'issue de cette transformation la caméra se retrouve en dehors
		 * du cadre de contrainte, celle-ci sera déplacée afin de respecter les contraintes.
		 * <p>
		 * Le redimensionnement d'une caméra en utilisant les méthodes <code>resizeTo&#42;</code>
		 * n'affectent pas la position du champ de la caméra. Cela signifie que le centre de
		 * la caméra aura été modifié après un appel à l'une des méthode de redimensionnement.
		 * </p>
		 *
		 * @param	h	nouvelle hauteur du champ de la caméra
		 */
		public function resizeToH ( h : Number ) : void
		{
			_safeHeight = h;

			solveZoom();
		}
/*--------------------------------------------------------------------
 *	ZOOM METHODS
 *-------------------------------------------------------------------*/
		/**
		 * Incrémente ou multiplie la valeur de zoom selon que la propriété
		 * <code>multiplyZoom</code> est à <code>true</code> ou à <code>false</code>.
		 * <p>
		 * Le zoom est incrémenté ou multiplier par la valeur de <code>_zoomIncrement</code>.
		 * </p>
		 */
		public function zoomIn() : void
		{
			if( multiplyZoom )
				zoom *= _zoomIncrement;
			else
				zoom += _zoomIncrement;
		}
		/**
		 * Réalise un zoom avant autour du point <code>pt</code> passé en paramètre.
		 *
		 * @param	pt	point de référence pour le zoom avant
		 */
		public function zoomInAroundPoint ( pt : Point ) : void
		{
			var c : Point = screenCenter;
			var dif : Point = c.subtract(pt);
			var z : Number = zoom;

			zoomIn();
			var r : Number = z/zoom;
			PointUtils.scale( dif, r );
			centerXY( pt.x + dif.x, pt.y + dif.y );
		}
		/**
		 * Décrémente ou divise la valeur de zoom selon que la propriété
		 * <code>multiplyZoom</code> est à <code>true</code> ou à <code>false</code>.
		 * <p>
		 * Le zoom est décrémenté ou diviser par la valeur de <code>_zoomIncrement</code>.
		 * </p>
		 */
		public function zoomOut() : void
		{
			if( multiplyZoom )
				zoom /= _zoomIncrement;
			else
				zoom -= _zoomIncrement;
		}
		/**
		 * Réalise un zoom arrière autour du point <code>pt</code> passé en paramètre.
		 *
		 * @param	pt	point de référence pour le zoom arrière
		 */
		public function zoomOutAroundPoint ( pt : Point ) : void
		{
			var c : Point = screenCenter;
			var dif : Point = c.subtract(pt);
			var z : Number = zoom;

			zoomOut();
			var r : Number = z/zoom;
			PointUtils.scale( dif, r );
			centerXY( pt.x + dif.x, pt.y + dif.y );
		}
/*--------------------------------------------------------------------
 *	PROTECTED METHODS
 *-------------------------------------------------------------------*/
		/**
		 * Résout les contraintes liées à la plage de valeurs de zoom autorisé
		 * puis appelle la méthode <code>computeZoom</code>.
		 */
		protected function solveZoom () : void
		{
			if( _zoom < _zoomRange.min )
				_zoom = _zoomRange.min;

			if( _zoom > _zoomRange.max  )
				_zoom = _zoomRange.max;

			computeZoom();
		}
		/**
		 * Calcule les nouvelles dimensions du champ de la caméras en fonction
		 * de la valeur de zoom courante. Le centre de la caméra est preservé, la
		 * méthode center est donc rappelée à la fin de l'appel afin de retrouver
		 * la position correcte de la caméra puis notifier les écouteurs de la
		 * transformation opérée.
		 */
		protected function computeZoom () : void
		{
			if( _zoom == 0)
				return;
            
            var r : Number = _screen.rotation;
            var c : Point = screenCenter;
            
            _screen.rotation = 0;
            _screen.width = _safeWidth;
            _screen.height = _safeHeight;
			_screen.center = c;
			_screen.scaleAroundCenter ( _zoom );
            _screen.rotateAroundCenter( r );

			fireCameraChangedSignal();
		}
/*--------------------------------------------------------------------
 *	EFFECTS METHODS
 *-------------------------------------------------------------------*/
		/**
		 * Déclenche un tremblement sur la caméra.
		 * <p>
		 * Le tremblement aura une durée d'exécution égale à <code>duration</code>
		 * et dont la force de tremblement sera égale à <code>strength</code>.
		 * </p>
		 * <p>
		 * La force du tremblement de la caméra est exprimée en pixel. Le tremblement produit un décalage
		 * allant de <code>-strength</code> à <code>strength</code> sur les axes <code>x</code> et <code>y</code>.
		 * </p>
		 * @param	duration	la durée du tremblement de la caméra
		 * @param	strength	la force du tremblement de la caméra
		 */
		public function shake ( duration : Number = 500, strength : Number = 2 ) : void
		{
			start();
			_shaking = true;
			_shakingStrength = strength;
			_shakingTime = 0;
			_shakingDuration = duration;
		}
		/**
		 * Termine le tremblement de la caméra
		 */
		protected function endShake () : void
		{
			_shaking = false;
			stop();
		}
		/**
		 * Réalise le tremblement de la caméra.
		 */
		protected function tick (  bias : Number, biasInSeconds : Number, currentTime : Number ) : void
		{
			var nx : Number = _safeCenter.x - _screen.width / 2 + _randomSource.balance( _shakingStrength ) ;
			var ny : Number = _safeCenter.y - _screen.height / 2 + _randomSource.balance( _shakingStrength );

			if( nx !=  _screen.x || ny != _screen.y )
			{
				_screen.x = nx;
				_screen.y = ny;
				fireSilentCameraChangedSignal ();
			}
			if( ( _shakingTime += bias ) > _shakingDuration )
				endShake();
		}
		/**
		 * Stop l'animation de la caméra.
		 *
		 */
		public function stop() : void
		{
			if( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister( tick );
			}
		}
		/**
		 * Démarre l'animation de la caméra.
		 */
		public function start() : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}
/*--------------------------------------------------------------------
 *	MISC
 *-------------------------------------------------------------------*/
		/**
		 * Renvoie la représentation sous forme de chaîne de l'instance courante.
		 *
		 * @return	la représentation sous forme de chaîne de l'instance courante
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this, {'screen':screen, 'zoom':zoom})
		}
		/**
		 * Renvoie <code>true</code> si la caméra est actuellement en cours d'animation.
		 *
		 * @return <code>true</code> si la caméra est actuellement en cours d'animation
		 */
		public function isRunning() : Boolean
		{
			return _isRunning;
		}
/*--------------------------------------------------------------------
 *	SIGNALS
 *-------------------------------------------------------------------*/
		public function fireCameraChangedSignal () : void
		{
			cameraChanged.dispatch( this );
		}
		protected function fireSilentCameraChangedSignal () : void
		{
			if( !silentMode )
				fireCameraChangedSignal();
		}
	}
}
