/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._$;
	/**
	 * La classe <code>GGRCodec</code> permet d'encoder et de décoder des objets
	 * <code>Gradient</code> au format <code>GGR</code> de GIMP.
	 *
	 * @author Cédric Néhémie
	 * @see	http://docs.gimp.org/fr/gimp-concepts-gradients.html Dégradés GIMP
	 */
	public class GGRCodec implements Codec
	{
		/*
		GIMP Gradient
		Name: My Grad
		2
		0.000000 0.250000 0.500000 1.000000 0.000000 0.000000 1.000000 0.000000 1.000000 0.000000 1.000000 3 0 0 0
		0.500000 0.750000 1.000000 0.000000 1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 1.000000 4 0 0 0

		First line says it is a gimp gradient file.

		Second line gives your Gradient a suitable name.

		Third line tells the number of segments in the gradient.

		Each line following defines the property of each segment in following order.

		[position of left stoppoint]
		[pos. of middle point]
		[pos. of right stoppoint]
		[R for left stoppoint]
		[G for left stoppoint]
		[B for left stoppoint]
		[A for left stoppoint]
		[R for right stoppoint]
		[G for right stoppoint]
		[B for right stoppoint]
		[A for right stoppoint]
		[Blending function constant]
		[Blending function constant]
		[Blending function constant]
		[Blending function constant]
		 */
		/**
		 * @inheritDoc
		 */
		public function encode (o : *) : *
		{
			if( o is Gradient )
			{
				var g : Gradient = o as Gradient;
				var l : int = g.colors.length;
				var s : String = "GIMP Gradient\n";
				s += "Name: " + g.name + "\n";
				s += (g.colors.length-1) + "\n";

				for(var i:int=1;i<l;i++)
				{
					var c1 : Color = g.colors[i-1];					var c2 : Color = g.colors[i];
					var p1 : Number = g.positions[i-1];
					var p2 : Number = g.positions[i];

					s += _$("$0 $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14\n",
							p1,
							(p1+p2)/2,
							p2,
							c1.red/255, c1.green/255, c1.red/255, c1.alpha/255,							c2.red/255, c2.green/255, c2.red/255, c2.alpha/255,
							0,0,0,0 );
				}
				return s;
			}
			else throw new Error();
		}
		/**
		 * @inheritDoc
		 */
		public function decode (o : *) : *
		{
			if( o is String )
			{
				var ar : Array = (o as String).split("\n");
				ar.shift();
				var name : String = StringUtils.trim((ar.shift() as String).replace("Name:", ""));
				var segments : int = parseInt(ar.shift());
				var colors : Array = [];
				var positions : Array = [];

				var r : uint;
				var g : uint;
				var b : uint;
				var a : uint;

				for(var i:int;i<segments;i++)
				{
					var seg : Array = (ar[i] as String).split(/\s+/g);

					if( i==0 )
					{
						positions.push( parseFloat(seg[0]) );
						r = Math.floor( parseFloat(seg[3])*255 );
						g = Math.floor( parseFloat(seg[4])*255 );
						b = Math.floor( parseFloat(seg[5])*255 );
						a = Math.floor( parseFloat(seg[6])*255 );
						colors.push(new Color(r, g, b, a ) );
					}

					positions.push( parseFloat(seg[2]) );
					r = Math.floor( parseFloat(seg[7])*255 );
					g = Math.floor( parseFloat(seg[8])*255 );
					b = Math.floor( parseFloat(seg[9])*255 );
					a = Math.floor( parseFloat(seg[10])*255 );
					colors.push(new Color(r, g, b, a ) );
				}

				return new Gradient(colors, positions, name);
			}
			else throw new Error();
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return String; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return Gradient; }
	}
}
