/**
 * @license
 */
package abe.com.mon.geom 
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.StringUtils;
	import abe.com.mon.utils.magicToReflectionSource;

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * Class <code>SmoothSpline</code> allows the creation of smooth 
	 * curves with automatic customizable.
	 * <p>
	 * The <code>SmoothSpline</code> class is a <code>CubicBezier</code>
	 * curve whose control vertices are automatically calculated by the curve. 
	 * The user therefore has only to define the points where the curve must
	 * pass, and it does the rest of the work by calculating the control
	 * points needed to smooth the curve.
	 * </p>
	 * <p>
	 * An instance of <code>SmoothSpline</code> can use different methods
	 * for smoothing, these modes are described in the class <code>SmoothSplineModes</code>
	 * </p>
	 * <p>
	 * Whatever method is used, there is a certain number of principles
	 * that will be consistently applied in calculating the smoothing vertex:
	 * </p>
	 * <ol>
	 * <li>Control points are always placed along the tangent to the corresponding vertex.
	 * <p>
	 * Given a set of three vertices <code>A->B->C</code>.
	 * Let <code>B'</code> and <code>B"</code> both controls points for the the vertex
	 * <code>B</code>. Points <code>B'</code> and <code>B"</code> will be just two points 
	 * placed on the line passing through <code>B</code> and parallel to the vector 
	 * <code>A-> C</code>.
	 * </p></li>
	 * <li>In the case of an open curve, control points for the first and last vertex
	 * of the curve will be mirrors of the controls points from the opposite vertex
	 * relative to the segment. 
	 * <p>
	 * Given a set of three vertices <code>A->B->C</code>. 
	 * Let <code>A'</code> a control point for the vertex <code>A</code> in segment 
	 * <code>A->B</code> and <code>B'</code> a control point for the vertex <code>B</code>
	 * in segment <code>A->B</code>. 
	 * Point <code>A'</code> will be positioned such that the angle <code>A'AB</code>
	 * is equal to the angle <code>ABB'</code>.
	 * </p></li>
	 * </ol>
	 * <fr> 
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
	 * </fr>
	 * @author Cédric Néhémie
	 * @see SmoothSplineModes
	 */
	public class SmoothSpline extends CubicBezier implements Spline, Path, Geometry, Cloneable, Serializable
	{
/*--------------------------------------------------------------------------*
 * CLASS MEMBERS
 *--------------------------------------------------------------------------*/
		/**
		 * An array containing the functions of different modes of smoothing
		 * provided by the class <code>SmoothSpline</code>.
		 * <p>
		 * The functions of the smoothing calculations are as follows:
		 * </p>
		 * <fr>
		 * Un tableau contenant les fonctions des différents modes de lissage
		 * fournis par la classe <code>SmoothSpline</code>.
		 * <p>
		 * Les fonctions de calculs du lissage prennent la forme suivante :
		 * </p>
		 * </fr>
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
		 * The control point associated to a pivot point is distant from the latter by
		 * a distance calculated as shown below : 
		 * <listing>Point.distance( segmentStart, segmentEnd ) &#42; curvature;</listing>
		 * 
		 * @param	spline				the current <code>SmoothSpline</code> instance
		 * 								<fr>l'objet <code>SmoothSpline</code> courant</fr>
		 * @param	segmentStart		point considered as the starting point of the segment, 
		 * 								the pivot point for the control vertex
		 * 								<fr>le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle</fr>
		 * @param	segmentEnd			point considered as the end of the segment
		 * 								<fr>le point considéré comme la fin du segment</fr>
		 * @param	segmentOpposite		point to the opposite end of the segment relative to the pivot
		 * 								<fr>le point à l'opposé de la fin du segment par rapport au pivôt</fr>
		 * @param	curvature			vurrent value of smoothing
		 * 								<fr>la valeur de lissage courante</fr>
		 * @return	the distance at which the control point will be from its pivot
		 * 			<fr>la distance à laquelle le point de contrôle sera éloigné de son pivôt</fr>
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
		 * The control point associated to a pivot point is distant from the latter by
		 * a distance calculated as shown below : 
		 * <listing>( Point.distance( segmentStart, segmentEnd ) &#42; curvature + 
		 * Point.distance( segmentStart, segmentOpposite ) &#42; curvature ) / 2;</listing>
		 * 
		 * @param	spline				the current <code>SmoothSpline</code> instance
		 * 								<fr>l'objet <code>SmoothSpline</code> courant</fr>
		 * @param	segmentStart		point considered as the starting point of the segment, 
		 * 								the pivot point for the control vertex
		 * 								<fr>le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle</fr>
		 * @param	segmentEnd			point considered as the end of the segment
		 * 								<fr>le point considéré comme la fin du segment</fr>
		 * @param	segmentOpposite		point to the opposite end of the segment relative to the pivot
		 * 								<fr>le point à l'opposé de la fin du segment par rapport au pivôt</fr>
		 * @param	curvature			vurrent value of smoothing
		 * 								<fr>la valeur de lissage courante</fr>
		 * @return	the distance at which the control point will be from its pivot
		 * 			<fr>la distance à laquelle le point de contrôle sera éloigné de son pivôt</fr>
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
		 * The control point associated to a pivot point is distant from the latter by
		 * a distance calculated as shown below : 
		 * <listing>spline.length &#42; curvature;</listing>
		 * 
		 * @param	spline				the current <code>SmoothSpline</code> instance
		 * 								<fr>l'objet <code>SmoothSpline</code> courant</fr>
		 * @param	segmentStart		point considered as the starting point of the segment, 
		 * 								the pivot point for the control vertex
		 * 								<fr>le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle</fr>
		 * @param	segmentEnd			point considered as the end of the segment
		 * 								<fr>le point considéré comme la fin du segment</fr>
		 * @param	segmentOpposite		point to the opposite end of the segment relative to the pivot
		 * 								<fr>le point à l'opposé de la fin du segment par rapport au pivôt</fr>
		 * @param	curvature			vurrent value of smoothing
		 * 								<fr>la valeur de lissage courante</fr>
		 * @return	the distance at which the control point will be from its pivot
		 * 			<fr>la distance à laquelle le point de contrôle sera éloigné de son pivôt</fr>
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
		 * The control point associated to a pivot point is distant from the latter by
		 * a distance defined by the <code>curvature</code> value passed to the function.
		 * 
		 * @param	spline				the current <code>SmoothSpline</code> instance
		 * 								<fr>l'objet <code>SmoothSpline</code> courant</fr>
		 * @param	segmentStart		point considered as the starting point of the segment, 
		 * 								the pivot point for the control vertex
		 * 								<fr>le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle</fr>
		 * @param	segmentEnd			point considered as the end of the segment
		 * 								<fr>le point considéré comme la fin du segment</fr>
		 * @param	segmentOpposite		point to the opposite end of the segment relative to the pivot
		 * 								<fr>le point à l'opposé de la fin du segment par rapport au pivôt</fr>
		 * @param	curvature			vurrent value of smoothing
		 * 								<fr>la valeur de lissage courante</fr>
		 * @return	the distance at which the control point will be from its pivot
		 * 			<fr>la distance à laquelle le point de contrôle sera éloigné de son pivôt</fr>
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
		 * In this case, the distance between the control point and its pivot will 
		 * always be equal to <code>0</code>.
		 * 
		 * @param	spline				the current <code>SmoothSpline</code> instance
		 * 								<fr>l'objet <code>SmoothSpline</code> courant</fr>
		 * @param	segmentStart		point considered as the starting point of the segment, 
		 * 								the pivot point for the control vertex
		 * 								<fr>le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle</fr>
		 * @param	segmentEnd			point considered as the end of the segment
		 * 								<fr>le point considéré comme la fin du segment</fr>
		 * @param	segmentOpposite		point to the opposite end of the segment relative to the pivot
		 * 								<fr>le point à l'opposé de la fin du segment par rapport au pivôt</fr>
		 * @param	curvature			vurrent value of smoothing
		 * 								<fr>la valeur de lissage courante</fr>
		 * @return	the distance at which the control point will be from its pivot
		 * 			<fr>la distance à laquelle le point de contrôle sera éloigné de son pivôt</fr>
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
		 * The control point associated to a pivot point is distant from the latter by
		 * a distance calculated using the per-vertex smoothing functions and curvatures.
		 * 
		 * @param	spline				the current <code>SmoothSpline</code> instance
		 * 								<fr>l'objet <code>SmoothSpline</code> courant</fr>
		 * @param	segmentStart		point considered as the starting point of the segment, 
		 * 								the pivot point for the control vertex
		 * 								<fr>le point considéré comme le point de départ du segment,
		 * 								soit le point de pivot pour le sommet de contrôle</fr>
		 * @param	segmentEnd			point considered as the end of the segment
		 * 								<fr>le point considéré comme la fin du segment</fr>
		 * @param	segmentOpposite		point to the opposite end of the segment relative to the pivot
		 * 								<fr>le point à l'opposé de la fin du segment par rapport au pivôt</fr>
		 * @param	curvature			vurrent value of smoothing
		 * 								<fr>la valeur de lissage courante</fr>
		 * @return	the distance at which the control point will be from its pivot
		 * 			<fr>la distance à laquelle le point de contrôle sera éloigné de son pivôt</fr>
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
 		/**
 		 * A general curvature value for the whole curves vertices.
 		 */
		protected var _curvature : Number;
		/**
		 * An array which contains the pivot points of the curve. 
		 */
		protected var _splineVertices : Array;
		/**
		 * An integer which represent the default smoothing mode
		 * for this curve pivot points.
		 */
		protected var _smoothingMode : uint;
		/**
		 * An array of integer which hold the smoothing modes 
		 * on a per-vertices basis.
		 */
		protected var _verticesSmoothingModes : Array;
		/**
		 * An array of numbers which hold the curvatures on
		 * a per-vertices basis.
		 */
		protected var _verticesCurvature : Array;
        protected var _originalPoints : Array;
		
		/**
		 * <code>SmoothSpline</code> class constructor.
		 * 
		 * @param	v						an array which contains the control points
		 * 									for this curve
		 * @param	curvature				a curvature value for all the vertices
		 * @param	smoothingMode			a smoothing mode for all the vertices
		 * @param	bias					the refinement parameter for this curve
		 * @param	verticesSmoothingModes	an array of smoothing modes for each vertex
		 * @param	verticesCurvature		an array of curvatures for each vertex
		 */
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
            _originalPoints = v.concat();
			_verticesSmoothingModes = verticesSmoothingModes;			_verticesCurvature = verticesCurvature;

			super( v, bias );
		}
		/**
		 * @inheritDoc
		 */
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
		/**
		 * Reference to the array containing the smoothing modes for each vertex.
		 */
		public function get verticesSmoothingModes () : Array { return _verticesSmoothingModes; }
		public function set verticesSmoothingModes (verticesSmoothingModes : Array) : void
		{
			_verticesSmoothingModes = verticesSmoothingModes;
			updateCurvaturePoints();
		}
		/**
		 * Reference to the array containing the curvatures for each vertex.
		 */
		public function get verticesCurvature () : Array { return _verticesCurvature; }
		public function set verticesCurvature (verticesCurvature : Array) : void
		{
			_verticesCurvature = verticesCurvature;
			updateCurvaturePoints();
		}
		/**
		 * The value of the curvature for the vertex of this spline.
		 */
		public function get curvature () : Number { return _curvature; }
		public function set curvature (curvature : Number) : void
		{
			_curvature = curvature;
			updateCurvaturePoints();
		}
		/**
		 * The current smoothingMode for this spline.
		 */
		public function get smoothingMode () : uint { return _smoothingMode; }
		public function set smoothingMode (smoothingMode : uint) : void
		{
			_smoothingMode = smoothingMode;
			updateCurvaturePoints();
		}
		/**
		 * Perform the update of the control points according to their pivot.
		 */
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
		/**
		 * Returns the position of the control point for the next segment after the pivot.
		 * 
		 * @param	ptIndex		index of the vertex
		 * @param	curvature	curvature to use in the control point computation
		 * @return	the position of the control point
		 */
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
		/**
		 * Returns the position of the control point for the previous segment before the pivot.
		 * 
		 * @param	ptIndex		index of the vertex
		 * @param	curvature	curvature to use in the control point computation
		 * @return	the position of the control point
		 */
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
		 * @inheritDoc
		 */
		override public function clone () : * { return new SmoothSpline( _splineVertices.concat( ), _curvature, drawBias ); }
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace( "new $0 ($1,$2,$3)",
						getQualifiedClassName ( this ),
						magicToReflectionSource ( _originalPoints ),
						_curvature,
						drawBias );
		}
	}
}
