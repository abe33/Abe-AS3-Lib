package aesia.com.mon.geom 
{
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.utils.PointUtils;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.mon.utils.magicToReflectionSource;

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>SmoothSpline</code> permet la création de courbes
	 * dont le lissage automatique est paramétrable.
	 * <p>
	 * La classe <code>SmoothSpline</code> est une courbe de bezier cubique
	 * dont les sommets de contrôles sont calculés automatiquement par la
	 * courbe. L'utilisateur n'a donc qu'a définir les points par laquelle
	 * la courbe doit passer, et celle-ci fait le reste du travail en calculant
	 * les points de contrôles nécessaires pour le lissage de la courbe.
	 * </p>
	 * <p>
	 * Une instance de <code>SmoothSpline</code> peut utiliser différents modes
	 * pour le lissage, ces modes sont décris dans la classe 
	 * <code>SmoothSplineModes</code>.
	 * </p>
	 * <p>
	 * Quelque soit la méthode utilisée, il y a un certains nombres de principe
	 * qui seront appliqués systématiquement lors du calcul du lissage en un sommet : 
	 * </p>
	 * <ol>
	 * <li>Les points de contrôles seront toujours placé le long de la tangente
	 * au sommet correspondant.
	 * <p>
	 * Soit un ensemble de trois sommets <code>A-&gt;B-&gt;C</code>.
	 * Soit <code>B'</code> et <code>B"</code> les deux points de contrôles ayant comme
	 * pivôt le point <code>B</code>. Les points <code>B'</code> et <code>B"</code>
	 * seront tout les deux positionnés sur la droite passant par <code>B</code>
	 * et parallèle au vecteur <code>A-&gt;C</code>.
	 * </p></li>
	 * <li>Dans le cas d'une courbe ouverte, les points de contrôles pour le premier
	 * et le dernier sommet de la courbe seront des mirroirs du point de contrôle
	 * du sommet opposé par rapport au segment.
	 * <p>
	 * Soit pour un ensemble de trois sommets <code>A-&gt;B-&gt;C</code>.
	 * Soit <code>A'</code> le point de contrôle ayant pour pivôt le sommet
	 * <code>A</code> sur le segment <code>A-&gt;B</code> et <code>B'</code> 
	 * le point de contrôle ayant pour pivôt le sommet <code>B</code> 
	 * sur le segment <code>A-&gt;B</code>. Le point <code>A'</code> sera positionné
	 * de telle manière que l'angle <code>A'AB</code> soit égale à l'angle <code>ABB'</code>.
	 * </p></li>
	 * </ol> 
	 * 
	 * @author Cédric Néhémie
	 * @see SmoothSplineModes
	 */
	public class SmoothSpline extends CubicBezier implements Spline, Path, Geometry, Cloneable, Serializable
	{
/*--------------------------------------------------------------------------*
 * CLASS MEMBERS
 *--------------------------------------------------------------------------*/
		/**
		 * Un tableau contenant les fonctions des différents modes de lissage
		 * fournis par la classe <code>SmoothSpline</code>.
		 * <p>
		 * Les fonctions de calculs du lissage prennent la forme suivante :
		 * </p>
		 * <listing>function smoothingModeFunction ( spline : SmoothSpline, segmentStart : Point, segmentEnd : Point, segmentOpposite : Point, curvature : Number ) : Number</listing>
		 * @see SmoothSplineModes
		 */
		static public const SMOOTHING_METHODS : Array = [ 
															noSmoothingMode,
															absoluteSmoothingMode,
															absoluteCurveRatioSmoothingMode,
															correspondingSegmentRatioSmoothingMode,
															balancedWithOppositeSegmentRatioSmoothingMode,
															byVertexSmoothingMode
														];
		/**
		 * 
		 * @param	spline				l'objet <code>SmoothSpline</code> courant
		 * @param	segmentStart		le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle
		 * @param	segmentEnd			le point considéré comme la fin du segment
		 * @param	segmentOpposite		le point à l'opposé de la fin du segment par rapport au pivôt
		 * @param	curvature			la valeur de lissage courante
		 * @return	la distance à laquelle le point de contrôle sera éloigné de son pivôt
		 * @see SmoothSplineModes#CORRESPONDING_SEGMENT_RATIO
		 */
		static public function correspondingSegmentRatioSmoothingMode ( spline : SmoothSpline,
																		segmentStart : Point, 
																		segmentEnd : Point, 
																		segmentOpposite : Point,
																		curvature : Number ) : Number
		{
			return Point.distance( segmentStart, segmentEnd ) * curvature;
		}
		/**
		 * 
		 * @param	spline				l'objet <code>SmoothSpline</code> courant
		 * @param	segmentStart		le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle
		 * @param	segmentEnd			le point considéré comme la fin du segment
		 * @param	segmentOpposite		le point à l'opposé de la fin du segment par rapport au pivôt
		 * @param	curvature			la valeur de lissage courante
		 * @return	la distance à laquelle le point de contrôle sera éloigné de son pivôt
		 * @see SmoothSplineModes#BALANCED_WITH_OPPOSITE_SEGMENT_RATIO
		 */
		static public function balancedWithOppositeSegmentRatioSmoothingMode ( 	spline : SmoothSpline,
																				segmentStart : Point, 
																				segmentEnd : Point, 
																				segmentOpposite : Point,
																				curvature : Number ) : Number
		{
			return ( Point.distance( segmentStart, segmentEnd ) * curvature + 
					 Point.distance( segmentStart, segmentOpposite ) * curvature ) / 2;
		}
		/**
		 * 
		 * @param	spline				l'objet <code>SmoothSpline</code> courant
		 * @param	segmentStart		le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle
		 * @param	segmentEnd			le point considéré comme la fin du segment
		 * @param	segmentOpposite		le point à l'opposé de la fin du segment par rapport au pivôt
		 * @param	curvature			la valeur de lissage courante
		 * @return	la distance à laquelle le point de contrôle sera éloigné de son pivôt
		 * @see SmoothSplineModes#ABSOLUTE_CURVE_RATIO
		 */
		static public function absoluteCurveRatioSmoothingMode ( spline : SmoothSpline,
																 segmentStart : Point, 
																 segmentEnd : Point, 
																 segmentOpposite : Point,
																 curvature : Number ) : Number
		{
			
			var length : Number = 0;
			var a : Array = spline.vertices;
			var l : uint = a.length;
			for ( var i : uint = 1; i < l; i++ )
				length += Point.distance( a[i-1],a[i] );

			return length * curvature;
		}
		/**
		 * 
		 * @param	spline				l'objet <code>SmoothSpline</code> courant
		 * @param	segmentStart		le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle
		 * @param	segmentEnd			le point considéré comme la fin du segment
		 * @param	segmentOpposite		le point à l'opposé de la fin du segment par rapport au pivôt
		 * @param	curvature			la valeur de lissage courante
		 * @return	la distance à laquelle le point de contrôle sera éloigné de son pivôt
		 * @see SmoothSplineModes#ABSOLUTE
		 */
		static public function absoluteSmoothingMode ( spline : SmoothSpline,
													   segmentStart : Point, 
													   segmentEnd : Point, 
													   segmentOpposite : Point,
													   curvature : Number ) : Number
		{
			return curvature;
		}
		/**
		 * 
		 * @param	spline				l'objet <code>SmoothSpline</code> courant
		 * @param	segmentStart		le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle
		 * @param	segmentEnd			le point considéré comme la fin du segment
		 * @param	segmentOpposite		le point à l'opposé de la fin du segment par rapport au pivôt
		 * @param	curvature			la valeur de lissage courante
		 * @return	la distance à laquelle le point de contrôle sera éloigné de son pivôt
		 * @see SmoothSplineModes#NO_SMOOTHING
		 */
		static public function noSmoothingMode ( spline : SmoothSpline,
												 segmentStart : Point, 
												 segmentEnd : Point, 
												 segmentOpposite : Point,
												 curvature : Number ) : Number
		{
			return 0;
		}
		/**
		 * 
		 * @param	spline				l'objet <code>SmoothSpline</code> courant
		 * @param	segmentStart		le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle
		 * @param	segmentEnd			le point considéré comme la fin du segment
		 * @param	segmentOpposite		le point à l'opposé de la fin du segment par rapport au pivôt
		 * @param	curvature			la valeur de lissage courante
		 * @return	la distance à laquelle le point de contrôle sera éloigné de son pivôt
		 * @see SmoothSplineModes#BY_VERTEX_SMOOTHING_MODE
		 */
		static public function byVertexSmoothingMode ( spline : SmoothSpline,
													   segmentStart : Point, 
													   segmentEnd : Point, 
													   segmentOpposite : Point,
													   curvature : Number ) : Number
		{
			var index : int = spline.vertices.indexOf( segmentStart );
			var mode : uint = index < spline.verticesSmoothingModes.length ? 
									spline.verticesSmoothingModes[ index ] : 
									SmoothSplineModes.CORRESPONDING_SEGMENT_RATIO;
			
			if( mode == SmoothSplineModes.BY_VERTEX_SMOOTHING_MODE )
				mode = SmoothSplineModes.CORRESPONDING_SEGMENT_RATIO;
			
			return SMOOTHING_METHODS[ mode ]( spline, segmentStart, segmentEnd, segmentOpposite, spline.verticesCurvature[ index ] );
		}
/*--------------------------------------------------------------------------*
 * INSTANCE MEMBERS
 *--------------------------------------------------------------------------*/
		protected var _curvature : Number;
		protected var _splineVertices : Array;
		protected var _smoothingMode : uint;
		protected var _verticesSmoothingModes : Array;
		protected var _verticesCurvature : Array;
		
		public function SmoothSpline ( v : Array = null, 
									   curvature : Number = 0.4,
									   smoothingMode : uint = 3,
									   bias : uint = 20,
									   verticesSmoothingModes : Array = null,
									   verticesCurvature : Array = null )
		{
			_curvature = curvature;
			_smoothingMode = smoothingMode;
			if( smoothingMode == SmoothSplineModes.BY_VERTEX_SMOOTHING_MODE )
			{
				var i : uint;
				var l : uint = v.length;
				if( !verticesSmoothingModes )
				{
					verticesSmoothingModes = new Array(l);
					for( i = 0; i < l; i++ )
						verticesSmoothingModes[i] = SmoothSplineModes.CORRESPONDING_SEGMENT_RATIO;
				}
				if( !verticesCurvature )
				{
					verticesCurvature = new Array(l);
					for( i = 0; i < l; i++ )
						verticesCurvature[i] = curvature;
				}
			}
			_verticesSmoothingModes = verticesSmoothingModes;			_verticesCurvature = verticesCurvature;

			super( v, bias );
		}
		override public function get vertices () : Array { return _splineVertices; }
		override public function set vertices (v : Array) : void 
		{
			if( !v )
			{
				_splineVertices = new Array();
				return;
			}
			if( checkVertices( v ) )
			{
				_splineVertices = v;
				updateCurvaturePoints();
			}
		}
		public function get verticesSmoothingModes () : Array { return _verticesSmoothingModes; }
		public function set verticesSmoothingModes (verticesSmoothingModes : Array) : void
		{
			_verticesSmoothingModes = verticesSmoothingModes;
			updateCurvaturePoints();
		}
		public function get verticesCurvature () : Array { return _verticesCurvature; }
		public function set verticesCurvature (verticesCurvature : Array) : void
		{
			_verticesCurvature = verticesCurvature;
			updateCurvaturePoints();
		}
		public function get curvature () : Number { return _curvature; }
		public function set curvature (curvature : Number) : void
		{
			_curvature = curvature;
			updateCurvaturePoints();
		}
		public function get smoothingMode () : uint { return _smoothingMode; }
		public function set smoothingMode (smoothingMode : uint) : void
		{
			_smoothingMode = smoothingMode;
			updateCurvaturePoints();
		}
		public function updateCurvaturePoints () : void
		{
			var a : Array = [];
			var l : uint = _splineVertices.length;
			a.push( _splineVertices[0] );
			for ( var i : uint = 1; i < l; i++ )
			{
				a.push( getNextControl( i - 1, _curvature ) );				a.push( getPreviousControl( i, _curvature ) );
				a.push( _splineVertices[i] );
			}
			_vertices = a;
		}
		protected function getNextControl ( ptIndex : uint, curvature : Number ) : Point
		{
			var l : uint = _splineVertices.length;
			
			if( ptIndex == l-1 )
				return null;
			
			var curPoint : Point = _splineVertices[ptIndex];
			var prevPoint : Point;
			var nextPoint : Point;
			var output : Point;
			var isFirstPoint : Boolean = ptIndex == 0;
			var isLastPoint : Boolean = ptIndex == l-1;
			var ptDif : Point;
			
			if( isFirstPoint )
				prevPoint = _splineVertices[l-2];
			else
				prevPoint = _splineVertices[ptIndex-1];
			
			if( isLastPoint )
				nextPoint = _splineVertices[1];
			else
				nextPoint = _splineVertices[ptIndex+1];
			
			switch( true )
			{
				case isFirstPoint && !isClosedSpline : 
					output = curPoint.add( PointUtils.reflect( getPreviousControl( ptIndex + 1, curvature ).subtract( nextPoint ), nextPoint.subtract( curPoint ) ) ); 
					break;
				default :
					ptDif = nextPoint.subtract( prevPoint );
					ptDif.normalize( SMOOTHING_METHODS[_smoothingMode]( this, curPoint, nextPoint, prevPoint, curvature ) );
					output = curPoint.add( ptDif );
					break;
			}
			return output;		
		}
		protected function getPreviousControl ( ptIndex : uint, curvature : Number ) : Point
		{
			if( ptIndex == 0 )
				return null;
			
			var l : uint = _splineVertices.length;
			var curPoint : Point = _splineVertices[ptIndex];
			var prevPoint : Point;
			var nextPoint : Point;
			var output : Point;
			var isFirstPoint : Boolean = ptIndex == 0;
			var isLastPoint : Boolean = ptIndex == l-1;
			var ptDif : Point;
			
			if( isFirstPoint )
				prevPoint = _splineVertices[l-2];
			else
				prevPoint = _splineVertices[ptIndex-1];
			
			if( isLastPoint )
				nextPoint = _splineVertices[1];
			else
				nextPoint = _splineVertices[ptIndex+1];
			
			switch( true )
			{
				case isLastPoint && !isClosedSpline :
					output = curPoint.add( PointUtils.reflect( getNextControl( ptIndex - 1, curvature ).subtract( prevPoint ), prevPoint.subtract( curPoint ) ) ); 
					break;
				default :
					ptDif = prevPoint.subtract( nextPoint );
					ptDif.normalize( SMOOTHING_METHODS[_smoothingMode]( this, curPoint, prevPoint, nextPoint, curvature ) );
					output = curPoint.add( ptDif );
					break;
			}
			return output;
		}
		/**
		 * @inheritDoc
		 */
		override protected function checkVertices (v : Array ) : Boolean
		{
			return v.length >= 3;
		}
		/**
		 * @inheritDoc
		 */
		override public function get isClosedSpline () : Boolean { return (_splineVertices[0] as Point).equals( _splineVertices[_splineVertices.length-1] ); }
		/**
		 * Renvoie une copie parfaite de cet objet <code>SmoothSpline</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>SmoothSpline</code>
		 */
		override public function clone () : *
		{
			return new SmoothSpline( _splineVertices.concat( ), _curvature, drawBias );
		}
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace( "new $0 ($1,$2,$3)",
						getQualifiedClassName ( this ),
						magicToReflectionSource ( _vertices ),
						_curvature,
						drawBias );
		}
	}
}
