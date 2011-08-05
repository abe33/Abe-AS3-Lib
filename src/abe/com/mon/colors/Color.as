/**
 * @license
 */
package  abe.com.mon.colors 
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Copyable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.StringUtils;
	import abe.com.mon.utils.objects.safePropertyCopy;

	import flash.geom.ColorTransform;
	import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>Color</code> fournit des contrôles de base
	 * pour manipuler des couleurs au format RGB et RGBA. De même
	 * la classe <code>Color</code> fournit sous forme de constantes
	 * l'ensemble des couleurs définit par la norme SVG 1.0.
	 * <p>
	 * <h2>Couleurs de la norme SVG 1.0 regroupées par teintes</h2>
	 * </p>
	 * <h3>Couleurs rouge</h3>
	 * <a href="#IndianRed" title="IndianRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : IndianRed;">&#xA0;</div></a>
	 * <a href="#LightCoral" title="LightCoral"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightCoral;">&#xA0;</div></a>
	 * <a href="#Salmon" title="Salmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Salmon;">&#xA0;</div></a>
	 * <a href="#DarkSalmon" title="DarkSalmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSalmon;">&#xA0;</div></a>
	 * <a href="#LightSalmon" title="LightSalmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSalmon;">&#xA0;</div></a>
	 * <a href="#Crimson" title="Crimson"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Crimson;">&#xA0;</div></a>
	 * <a href="#Red" title="Red"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Red;">&#xA0;</div></a>
	 * <a href="#FireBrick" title="FireBrick"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : FireBrick;">&#xA0;</div></a>
	 * <a href="#DarkRed" title="DarkRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkRed;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs roses</h3>
	 * <a href="#Pink" title="Pink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Pink;">&#xA0;</div></a>
	 * <a href="#LightPink" title="LightPink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightPink;">&#xA0;</div></a>
	 * <a href="#HotPink" title="HotPink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : HotPink;">&#xA0;</div></a>
	 * <a href="#DeepPink" title="DeepPink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DeepPink;">&#xA0;</div></a>
	 * <a href="#MediumVioletRed" title="MediumVioletRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumVioletRed;">&#xA0;</div></a>
	 * <a href="#PaleVioletRed" title="PaleVioletRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleVioletRed;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs oranges</h3>
	 * <a href="#LightSalmon" title="LightSalmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSalmon;">&#xA0;</div></a>
	 * <a href="#Coral" title="Coral"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Coral;">&#xA0;</div></a>
	 * <a href="#Tomato" title="Tomato"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Tomato;">&#xA0;</div></a>
	 * <a href="#OrangeRed" title="OrangeRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : OrangeRed;">&#xA0;</div></a>
	 * <a href="#DarkOrange" title="DarkOrange"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkOrange;">&#xA0;</div></a>
	 * <a href="#Orange" title="Orange"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Orange;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs jaunes</h3>
	 * <a href="#Gold" title="Gold"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Gold;">&#xA0;</div></a>
	 * <a href="#Yellow" title="Yellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Yellow;">&#xA0;</div></a>
	 * <a href="#LightYellow" title="LightYellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightYellow;">&#xA0;</div></a>
	 * <a href="#LemonChiffon" title="LemonChiffon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LemonChiffon;">&#xA0;</div></a>
	 * <a href="#LightGoldenrodYellow" title="LightGoldenrodYellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightGoldenrodYellow;">&#xA0;</div></a>
	 * <a href="#PapayaWhip" title="PapayaWhip"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PapayaWhip;">&#xA0;</div></a>
	 * <a href="#Moccasin" title="Moccasin"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Moccasin;">&#xA0;</div></a>
	 * <a href="#PeachPuff" title="PeachPuff"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PeachPuff;">&#xA0;</div></a>
	 * <a href="#PaleGoldenrod" title="PaleGoldenrod"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleGoldenrod;">&#xA0;</div></a>
	 * <a href="#Khaki" title="Khaki"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Khaki;">&#xA0;</div></a>
	 * <a href="#DarkKhaki" title="DarkKhaki"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkKhaki;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs violettes</h3>
	 * <a href="#Lavender" title="Lavender"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Lavender;">&#xA0;</div></a>
	 * <a href="#Thistle" title="Thistle"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Thistle;">&#xA0;</div></a>
	 * <a href="#Plum" title="Plum"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Plum;">&#xA0;</div></a>
	 * <a href="#Violet" title="Violet"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Violet;">&#xA0;</div></a>
	 * <a href="#Orchid" title="Orchid"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Orchid;">&#xA0;</div></a>
	 * <a href="#Fuchsia" title="Fuchsia"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Fuchsia;">&#xA0;</div></a>
	 * <a href="#Magenta" title="Magenta"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Magenta;">&#xA0;</div></a>
	 * <a href="#MediumOrchid" title="MediumOrchid"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumOrchid;">&#xA0;</div></a>
	 * <a href="#MediumPurple" title="MediumPurple"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumPurple;">&#xA0;</div></a>
	 * <a href="#BlueViolet" title="BlueViolet"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : BlueViolet;">&#xA0;</div></a>
	 * <a href="#DarkViolet" title="DarkViolet"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkViolet;">&#xA0;</div></a>
	 * <a href="#DarkOrchid" title="DarkOrchid"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkOrchid;">&#xA0;</div></a>
	 * <a href="#DarkMagenta" title="DarkMagenta"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkMagenta;">&#xA0;</div></a>
	 * <a href="#Purple" title="Purple"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Purple;">&#xA0;</div></a>
	 * <a href="#Indigo" title="Indigo"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Indigo;">&#xA0;</div></a>
	 * <a href="#SlateBlue" title="SlateBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SlateBlue;">&#xA0;</div></a>
	 * <a href="#DarkSlateBlue" title="DarkSlateBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSlateBlue;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs vertes</h3>
	 * <a href="#GreenYellow" title="GreenYellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : GreenYellow;">&#xA0;</div></a>
	 * <a href="#Chartreuse" title="Chartreuse"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Chartreuse;">&#xA0;</div></a>
	 * <a href="#LawnGreen" title="LawnGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LawnGreen;">&#xA0;</div></a>
	 * <a href="#Lime" title="Lime"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Lime;">&#xA0;</div></a>
	 * <a href="#LimeGreen" title="LimeGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LimeGreen;">&#xA0;</div></a>
	 * <a href="#PaleGreen" title="PaleGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleGreen;">&#xA0;</div></a>
	 * <a href="#LightGreen" title="LightGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightGreen;">&#xA0;</div></a>
	 * <a href="#MediumSpringGreen" title="MediumSpringGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumSpringGreen;">&#xA0;</div></a>
	 * <a href="#SpringGreen" title="SpringGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SpringGreen;">&#xA0;</div></a>
	 * <a href="#MediumSeaGreen" title="MediumSeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumSeaGreen;">&#xA0;</div></a>
	 * <a href="#SeaGreen" title="SeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SeaGreen;">&#xA0;</div></a>
	 * <a href="#ForestGreen" title="ForestGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : ForestGreen;">&#xA0;</div></a>
	 * <a href="#Green" title="Green"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Green;">&#xA0;</div></a>
	 * <a href="#DarkGreen" title="DarkGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkGreen;">&#xA0;</div></a>
	 * <a href="#YellowGreen" title="YellowGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : YellowGreen;">&#xA0;</div></a>
	 * <a href="#OliveDrab" title="OliveDrab"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : OliveDrab;">&#xA0;</div></a>
	 * <a href="#Olive" title="Olive"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Olive;">&#xA0;</div></a>
	 * <a href="#DarkOliveGreen" title="DarkOliveGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkOliveGreen;">&#xA0;</div></a>
	 * <a href="#MediumAquamarine" title="MediumAquamarine"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumAquamarine;">&#xA0;</div></a>
	 * <a href="#DarkSeaGreen" title="DarkSeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSeaGreen;">&#xA0;</div></a>
	 * <a href="#LightSeaGreen" title="LightSeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSeaGreen;">&#xA0;</div></a>
	 * <a href="#DarkCyan" title="DarkCyan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkCyan;">&#xA0;</div></a>
	 * <a href="#Teal" title="Teal"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Teal;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs bleues</h3>
	 * <a href="#Aqua" title="Aqua"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Aqua;">&#xA0;</div></a>
	 * <a href="#Cyan" title="Cyan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Cyan;">&#xA0;</div></a>
	 * <a href="#LightCyan" title="LightCyan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightCyan;">&#xA0;</div></a>
	 * <a href="#PaleTurquoise" title="PaleTurquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleTurquoise;">&#xA0;</div></a>
	 * <a href="#Aquamarine" title="Aquamarine"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Aquamarine;">&#xA0;</div></a>
	 * <a href="#Turquoise" title="Turquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Turquoise;">&#xA0;</div></a>
	 * <a href="#MediumTurquoise" title="MediumTurquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumTurquoise;">&#xA0;</div></a>
	 * <a href="#DarkTurquoise" title="DarkTurquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkTurquoise;">&#xA0;</div></a>
	 * <a href="#CadetBlue" title="CadetBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : CadetBlue;">&#xA0;</div></a>
	 * <a href="#SteelBlue" title="SteelBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SteelBlue;">&#xA0;</div></a>
	 * <a href="#LightSteelBlue" title="LightSteelBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSteelBlue;">&#xA0;</div></a>
	 * <a href="#PowderBlue" title="PowderBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PowderBlue;">&#xA0;</div></a>
	 * <a href="#LightBlue" title="LightBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightBlue;">&#xA0;</div></a>
	 * <a href="#SkyBlue" title="SkyBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SkyBlue;">&#xA0;</div></a>
	 * <a href="#LightSkyBlue" title="LightSkyBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSkyBlue;">&#xA0;</div></a>
	 * <a href="#DeepSkyBlue" title="DeepSkyBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DeepSkyBlue;">&#xA0;</div></a>
	 * <a href="#DodgerBlue" title="DodgerBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DodgerBlue;">&#xA0;</div></a>
	 * <a href="#CornflowerBlue" title="CornflowerBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : CornflowerBlue;">&#xA0;</div></a>
	 * <a href="#MediumSlateBlue" title="MediumSlateBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumSlateBlue;">&#xA0;</div></a>
	 * <a href="#RoyalBlue" title="RoyalBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : RoyalBlue;">&#xA0;</div></a>
	 * <a href="#Blue" title="Blue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Blue;">&#xA0;</div></a>
	 * <a href="#MediumBlue" title="MediumBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumBlue;">&#xA0;</div></a>
	 * <a href="#DarkBlue" title="DarkBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkBlue;">&#xA0;</div></a>
	 * <a href="#Navy" title="Navy"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Navy;">&#xA0;</div></a>
	 * <a href="#MidnightBlue" title="MidnightBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MidnightBlue;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs marrons</h3>
	 * <a href="#Cornsilk" title="Cornsilk"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Cornsilk;">&#xA0;</div></a>
	 * <a href="#BlanchedAlmond" title="BlanchedAlmond"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : BlanchedAlmond;">&#xA0;</div></a>
	 * <a href="#Bisque" title="Bisque"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Bisque;">&#xA0;</div></a>
	 * <a href="#NavajoWhite" title="NavajoWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : NavajoWhite;">&#xA0;</div></a>
	 * <a href="#Wheat" title="Wheat"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Wheat;">&#xA0;</div></a>
	 * <a href="#BurlyWood" title="BurlyWood"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : BurlyWood;">&#xA0;</div></a>
	 * <a href="#Tan" title="Tan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Tan;">&#xA0;</div></a>
	 * <a href="#RosyBrown" title="RosyBrown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : RosyBrown;">&#xA0;</div></a>
	 * <a href="#SandyBrown" title="SandyBrown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SandyBrown;">&#xA0;</div></a>
	 * <a href="#Goldenrod" title="Goldenrod"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Goldenrod;">&#xA0;</div></a>
	 * <a href="#DarkGoldenrod" title="DarkGoldenrod"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkGoldenrod;">&#xA0;</div></a>
	 * <a href="#Peru" title="Peru"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Peru;">&#xA0;</div></a>
	 * <a href="#Chocolate" title="Chocolate"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Chocolate;">&#xA0;</div></a>
	 * <a href="#SaddleBrown" title="SaddleBrown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SaddleBrown;">&#xA0;</div></a>
	 * <a href="#Sienna" title="Sienna"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Sienna;">&#xA0;</div></a>
	 * <a href="#Brown" title="Brown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Brown;">&#xA0;</div></a>
	 * <a href="#Maroon" title="Maroon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Maroon;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs blanches</h3>
	 * <a href="#White" title="White"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : White;">&#xA0;</div></a>
	 * <a href="#Snow" title="Snow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Snow;">&#xA0;</div></a>
	 * <a href="#Honeydew" title="Honeydew"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Honeydew;">&#xA0;</div></a>
	 * <a href="#MintCream" title="MintCream"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MintCream;">&#xA0;</div></a>
	 * <a href="#Azure" title="Azure"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Azure;">&#xA0;</div></a>
	 * <a href="#AliceBlue" title="AliceBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : AliceBlue;">&#xA0;</div></a>
	 * <a href="#GhostWhite" title="GhostWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : GhostWhite;">&#xA0;</div></a>
	 * <a href="#WhiteSmoke" title="WhiteSmoke"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : WhiteSmoke;">&#xA0;</div></a>
	 * <a href="#Seashell" title="Seashell"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Seashell;">&#xA0;</div></a>
	 * <a href="#Beige" title="Beige"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Beige;">&#xA0;</div></a>
	 * <a href="#OldLace" title="OldLace"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : OldLace;">&#xA0;</div></a>
	 * <a href="#FloralWhite" title="FloralWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : FloralWhite;">&#xA0;</div></a>
	 * <a href="#Ivory" title="Ivory"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Ivory;">&#xA0;</div></a>
	 * <a href="#AntiqueWhite" title="AntiqueWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : AntiqueWhite;">&#xA0;</div></a>
	 * <a href="#Linen" title="Linen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Linen;">&#xA0;</div></a>
	 * <a href="#LavenderBlush" title="LavenderBlush"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LavenderBlush;">&#xA0;</div></a>
	 * <a href="#MistyRose" title="MistyRose"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MistyRose;">&#xA0;</div></a>
	 * 
	 * <h3>Couleurs grises</h3>
	 * <a href="#Gainsboro" title="Gainsboro"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Gainsboro;">&#xA0;</div></a>
	 * <a href="#LightGrey" title="LightGrey"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightGrey;">&#xA0;</div></a>
	 * <a href="#Silver" title="Silver"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Silver;">&#xA0;</div></a>
	 * <a href="#DarkGray" title="DarkGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkGray;">&#xA0;</div></a>
	 * <a href="#Gray" title="Gray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Gray;">&#xA0;</div></a>
	 * <a href="#DimGray" title="DimGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DimGray;">&#xA0;</div></a>
	 * <a href="#LightSlateGray" title="LightSlateGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSlateGray;">&#xA0;</div></a>
	 * <a href="#SlateGray" title="SlateGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SlateGray;">&#xA0;</div></a>
	 * <a href="#DarkSlateGray" title="DarkSlateGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSlateGray;">&#xA0;</div></a>
	 * <a href="#Black" title="Black"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Black;">&#xA0;</div></a>
	 * 
	 * @author 	Cédric Néhémie
	 */
	public class Color implements Serializable, Equatable, Cloneable, Copyable, FormMetaProvider
	{
		
		/*
		 * CLASS MEMBERS
		 */
		
		// tableau stockant toutes les instances nommées de la classe
		static private const INSTANCES : Object = new Object( );
		
		/**
		 * Renvoie la couleur enregistrée avec la chaîne passée en paramètre.
		 * Si aucune n'est enregistrée à ce nom, la fonction renvoie <code>null</code>.
		 * 
		 * @param	key	clé d'accès à la couleur
		 * @return	la couleur enregistrée avec la chaîne passée en paramètre
		 */
		static public function get ( key : String ) : Color
		{
			if( INSTANCES.hasOwnProperty( key ) )
			{
				return INSTANCES[ key ] as Color;
			}
			else return null;
		}
		 		 
		/*
		 * SVG 1.0 COLORS ENUM
		 * 
		 * Une énumération sous forme de constantes de l'ensemble
		 * des couleurs prédéfinies dans la norme SVG 1.0
		 * 
		 * voir : http://fr.wikipedia.org/wiki/Couleurs_du_Web#Noms_de_couleurs_SVG_1.0
		 * 
		 * RegExp pour manipuler les constantes : 
		 * static public const ([^\s:]+)\s*: Color = new Color\( ([0-9]+),\s+([0-9]+),\s+([0-9]+),\s+([0-9]+),\s+("[^"]+")\s+\);
		 * Remplacement pour la doc (penser à virer le backslash devant le slash de fermeture de commentaire) : 
		 * /**\n\t\t * <div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; \n\t\t * border : 1px solid #333; background-color : $1;">&#xA0;</div>\n\t\t * <strong>R : </strong> $2, <strong>G : </strong> $3, <strong>B : </strong> $4.\n\t\t * <p>\n\t\t * Instance de la classe <code>Color</code> représentant \n\t\t * la couleur <code>$1</code> de la norme SVG 1.0\n\t\t * </p>\n\t\t *\/\n\t\t$0
		 */		
		
		// Couleurs rouge
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : IndianRed;">&#xA0;</div>
		 * <strong>R : </strong> 205, <strong>G : </strong> 92, <strong>B : </strong> 92.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>IndianRed</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const IndianRed : Color = new Color( 205, 92, 92, 255, "IndianRed" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightCoral;">&#xA0;</div>
		 * <strong>R : </strong> 240, <strong>G : </strong> 128, <strong>B : </strong> 128.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightCoral</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightCoral : Color = new Color( 240, 128, 128, 255, "LightCoral" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Salmon;">&#xA0;</div>
		 * <strong>R : </strong> 250, <strong>G : </strong> 128, <strong>B : </strong> 114.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Salmon</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Salmon : Color = new Color( 250, 128, 114, 255, "Salmon" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkSalmon;">&#xA0;</div>
		 * <strong>R : </strong> 233, <strong>G : </strong> 150, <strong>B : </strong> 122.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkSalmon</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkSalmon : Color = new Color( 233, 150, 122, 255, "DarkSalmon" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightSalmon;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 160, <strong>B : </strong> 122.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightSalmon</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightSalmon : Color = new Color( 255, 160, 122, 255, "LightSalmon" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Crimson;">&#xA0;</div>
		 * <strong>R : </strong> 220, <strong>G : </strong> 20, <strong>B : </strong> 60.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Crimson</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Crimson : Color = new Color( 220, 20, 60, 255, "Crimson" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Red;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 0, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Red</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Red : Color = new Color( 255, 0, 0, 255, "Red" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : FireBrick;">&#xA0;</div>
		 * <strong>R : </strong> 178, <strong>G : </strong> 34, <strong>B : </strong> 34.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>FireBrick</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const FireBrick : Color = new Color( 178, 34, 34, 255, "FireBrick" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkRed;">&#xA0;</div>
		 * <strong>R : </strong> 139, <strong>G : </strong> 0, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkRed</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkRed : Color = new Color( 139, 0, 0, 255, "DarkRed" );
		
		// Couleurs roses
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Pink;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 192, <strong>B : </strong> 203.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Pink</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Pink : Color = new Color( 255, 192, 203, 255, "Pink" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightPink;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 182, <strong>B : </strong> 193.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightPink</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightPink : Color = new Color( 255, 182, 193, 255, "LightPink" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : HotPink;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 105, <strong>B : </strong> 180.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>HotPink</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const HotPink : Color = new Color( 255, 105, 180, 255, "HotPink" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DeepPink;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 20, <strong>B : </strong> 147.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DeepPink</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DeepPink : Color = new Color( 255, 20, 147, 255, "DeepPink" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumVioletRed;">&#xA0;</div>
		 * <strong>R : </strong> 199, <strong>G : </strong> 21, <strong>B : </strong> 133.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumVioletRed</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumVioletRed : Color = new Color( 199, 21, 133, 255, "MediumVioletRed" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PaleVioletRed;">&#xA0;</div>
		 * <strong>R : </strong> 219, <strong>G : </strong> 112, <strong>B : </strong> 147.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PaleVioletRed</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PaleVioletRed : Color = new Color( 219, 112, 147, 255, "PaleVioletRed" );
		
		// Couleurs oranges
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Coral;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 127, <strong>B : </strong> 80.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Coral</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Coral : Color = new Color( 255, 127, 80, 255, "Coral" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Tomato;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 99, <strong>B : </strong> 71.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Tomato</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Tomato : Color = new Color( 255, 99, 71, 255, "Tomato" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : OrangeRed;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 69, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>OrangeRed</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const OrangeRed : Color = new Color( 255, 69, 0, 255, "OrangeRed" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkOrange;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 140, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkOrange</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkOrange : Color = new Color( 255, 140, 0, 255, "DarkOrange" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Orange;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 165, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Orange</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Orange : Color = new Color( 255, 165, 0, 255, "Orange" );
		
		// Couleurs jaunes
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Gold;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 215, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Gold</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Gold : Color = new Color( 255, 215, 0, 255, "Gold" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Yellow;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 255, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Yellow</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Yellow : Color = new Color( 255, 255, 0, 255, "Yellow" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightYellow;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 255, <strong>B : </strong> 224.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightYellow</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightYellow : Color = new Color( 255, 255, 224, 255, "LightYellow" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LemonChiffon;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 250, <strong>B : </strong> 205.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LemonChiffon</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LemonChiffon : Color = new Color( 255, 250, 205, 255, "LemonChiffon" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightGoldenrodYellow;">&#xA0;</div>
		 * <strong>R : </strong> 250, <strong>G : </strong> 250, <strong>B : </strong> 210.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightGoldenrodYellow</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightGoldenrodYellow : Color = new Color( 250, 250, 210, 255, "LightGoldenrodYellow" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PapayaWhip;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 239, <strong>B : </strong> 213.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PapayaWhip</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PapayaWhip : Color = new Color( 255, 239, 213, 255, "PapayaWhip" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Moccasin;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 228, <strong>B : </strong> 181.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Moccasin</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Moccasin : Color = new Color( 255, 228, 181, 255, "Moccasin" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PeachPuff;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 218, <strong>B : </strong> 185.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PeachPuff</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PeachPuff : Color = new Color( 255, 218, 185, 255, "PeachPuff" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PaleGoldenrod;">&#xA0;</div>
		 * <strong>R : </strong> 238, <strong>G : </strong> 232, <strong>B : </strong> 170.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PaleGoldenrod</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PaleGoldenrod : Color = new Color( 238, 232, 170, 255, "PaleGoldenrod" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Khaki;">&#xA0;</div>
		 * <strong>R : </strong> 240, <strong>G : </strong> 230, <strong>B : </strong> 140.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Khaki</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Khaki : Color = new Color( 240, 230, 140, 255, "Khaki" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkKhaki;">&#xA0;</div>
		 * <strong>R : </strong> 189, <strong>G : </strong> 183, <strong>B : </strong> 107.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkKhaki</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkKhaki : Color = new Color( 189, 183, 107, 255, "DarkKhaki" );
		
		// Couleurs violettes
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Lavender;">&#xA0;</div>
		 * <strong>R : </strong> 230, <strong>G : </strong> 230, <strong>B : </strong> 250.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Lavender</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Lavender : Color = new Color( 230, 230, 250, 255, "Lavender" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Thistle;">&#xA0;</div>
		 * <strong>R : </strong> 216, <strong>G : </strong> 191, <strong>B : </strong> 216.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Thistle</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Thistle : Color = new Color( 216, 191, 216, 255, "Thistle" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Plum;">&#xA0;</div>
		 * <strong>R : </strong> 221, <strong>G : </strong> 160, <strong>B : </strong> 221.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Plum</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Plum : Color = new Color( 221, 160, 221, 255, "Plum" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Violet;">&#xA0;</div>
		 * <strong>R : </strong> 238, <strong>G : </strong> 130, <strong>B : </strong> 238.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Violet</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Violet : Color = new Color( 238, 130, 238, 255, "Violet" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Orchid;">&#xA0;</div>
		 * <strong>R : </strong> 218, <strong>G : </strong> 112, <strong>B : </strong> 214.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Orchid</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Orchid : Color = new Color( 218, 112, 214, 255, "Orchid" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Fuchsia;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 0, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Fuchsia</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Fuchsia : Color = new Color( 255, 0, 255, 255, "Fuchsia" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Magenta;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 0, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Magenta</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Magenta : Color = new Color( 255, 0, 255, 255, "Magenta" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumOrchid;">&#xA0;</div>
		 * <strong>R : </strong> 186, <strong>G : </strong> 85, <strong>B : </strong> 211.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumOrchid</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumOrchid : Color = new Color( 186, 85, 211, 255, "MediumOrchid" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumPurple;">&#xA0;</div>
		 * <strong>R : </strong> 147, <strong>G : </strong> 112, <strong>B : </strong> 219.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumPurple</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumPurple : Color = new Color( 147, 112, 219, 255, "MediumPurple" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : BlueViolet;">&#xA0;</div>
		 * <strong>R : </strong> 138, <strong>G : </strong> 43, <strong>B : </strong> 226.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>BlueViolet</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const BlueViolet : Color = new Color( 138, 43, 226, 255, "BlueViolet" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkViolet;">&#xA0;</div>
		 * <strong>R : </strong> 148, <strong>G : </strong> 0, <strong>B : </strong> 211.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkViolet</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkViolet : Color = new Color( 148, 0, 211, 255, "DarkViolet" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkOrchid;">&#xA0;</div>
		 * <strong>R : </strong> 153, <strong>G : </strong> 50, <strong>B : </strong> 204.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkOrchid</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkOrchid : Color = new Color( 153, 50, 204, 255, "DarkOrchid" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkMagenta;">&#xA0;</div>
		 * <strong>R : </strong> 139, <strong>G : </strong> 0, <strong>B : </strong> 139.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkMagenta</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkMagenta : Color = new Color( 139, 0, 139, 255, "DarkMagenta" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Purple;">&#xA0;</div>
		 * <strong>R : </strong> 128, <strong>G : </strong> 0, <strong>B : </strong> 128.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Purple</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Purple : Color = new Color( 128, 0, 128, 255, "Purple" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Indigo;">&#xA0;</div>
		 * <strong>R : </strong> 75, <strong>G : </strong> 0, <strong>B : </strong> 130.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Indigo</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Indigo : Color = new Color( 75, 0, 130, 255, "Indigo" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SlateBlue;">&#xA0;</div>
		 * <strong>R : </strong> 106, <strong>G : </strong> 90, <strong>B : </strong> 205.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SlateBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SlateBlue : Color = new Color( 106, 90, 205, 255, "SlateBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkSlateBlue;">&#xA0;</div>
		 * <strong>R : </strong> 72, <strong>G : </strong> 61, <strong>B : </strong> 139.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkSlateBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkSlateBlue : Color = new Color( 72, 61, 139, 255, "DarkSlateBlue" );
		
		// Couleurs vertes
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : GreenYellow;">&#xA0;</div>
		 * <strong>R : </strong> 173, <strong>G : </strong> 255, <strong>B : </strong> 47.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>GreenYellow</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const GreenYellow : Color = new Color( 173, 255, 47, 255, "GreenYellow" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Chartreuse;">&#xA0;</div>
		 * <strong>R : </strong> 127, <strong>G : </strong> 255, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Chartreuse</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Chartreuse : Color = new Color( 127, 255, 0, 255, "Chartreuse" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LawnGreen;">&#xA0;</div>
		 * <strong>R : </strong> 124, <strong>G : </strong> 252, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LawnGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LawnGreen : Color = new Color( 124, 252, 0, 255, "LawnGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Lime;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 255, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Lime</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Lime : Color = new Color( 0, 255, 0, 255, "Lime" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LimeGreen;">&#xA0;</div>
		 * <strong>R : </strong> 50, <strong>G : </strong> 205, <strong>B : </strong> 50.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LimeGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LimeGreen : Color = new Color( 50, 205, 50, 255, "LimeGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PaleGreen;">&#xA0;</div>
		 * <strong>R : </strong> 152, <strong>G : </strong> 251, <strong>B : </strong> 152.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PaleGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PaleGreen : Color = new Color( 152, 251, 152, 255, "PaleGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightGreen;">&#xA0;</div>
		 * <strong>R : </strong> 144, <strong>G : </strong> 238, <strong>B : </strong> 144.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightGreen : Color = new Color( 144, 238, 144, 255, "LightGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumSpringGreen;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 250, <strong>B : </strong> 154.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumSpringGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumSpringGreen : Color = new Color( 0, 250, 154, 255, "MediumSpringGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SpringGreen;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 255, <strong>B : </strong> 127.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SpringGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SpringGreen : Color = new Color( 0, 255, 127, 255, "SpringGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumSeaGreen;">&#xA0;</div>
		 * <strong>R : </strong> 60, <strong>G : </strong> 179, <strong>B : </strong> 113.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumSeaGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumSeaGreen : Color = new Color( 60, 179, 113, 255, "MediumSeaGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SeaGreen;">&#xA0;</div>
		 * <strong>R : </strong> 46, <strong>G : </strong> 139, <strong>B : </strong> 87.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SeaGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SeaGreen : Color = new Color( 46, 139, 87, 255, "SeaGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : ForestGreen;">&#xA0;</div>
		 * <strong>R : </strong> 34, <strong>G : </strong> 139, <strong>B : </strong> 34.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>ForestGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const ForestGreen : Color = new Color( 34, 139, 34, 255, "ForestGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Green;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 128, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Green</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Green : Color = new Color( 0, 128, 0, 255, "Green" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkGreen;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 100, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkGreen : Color = new Color( 0, 100, 0, 255, "DarkGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : YellowGreen;">&#xA0;</div>
		 * <strong>R : </strong> 154, <strong>G : </strong> 205, <strong>B : </strong> 50.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>YellowGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const YellowGreen : Color = new Color( 154, 205, 50, 255, "YellowGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : OliveDrab;">&#xA0;</div>
		 * <strong>R : </strong> 107, <strong>G : </strong> 142, <strong>B : </strong> 35.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>OliveDrab</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const OliveDrab : Color = new Color( 107, 142, 35, 255, "OliveDrab" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Olive;">&#xA0;</div>
		 * <strong>R : </strong> 128, <strong>G : </strong> 128, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Olive</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Olive : Color = new Color( 128, 128, 0, 255, "Olive" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkOliveGreen;">&#xA0;</div>
		 * <strong>R : </strong> 85, <strong>G : </strong> 107, <strong>B : </strong> 47.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkOliveGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkOliveGreen : Color = new Color( 85, 107, 47, 255, "DarkOliveGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumAquamarine;">&#xA0;</div>
		 * <strong>R : </strong> 102, <strong>G : </strong> 205, <strong>B : </strong> 170.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumAquamarine</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumAquamarine : Color = new Color( 102, 205, 170, 255, "MediumAquamarine" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkSeaGreen;">&#xA0;</div>
		 * <strong>R : </strong> 143, <strong>G : </strong> 188, <strong>B : </strong> 143.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkSeaGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkSeaGreen : Color = new Color( 143, 188, 143, 255, "DarkSeaGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightSeaGreen;">&#xA0;</div>
		 * <strong>R : </strong> 32, <strong>G : </strong> 178, <strong>B : </strong> 170.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightSeaGreen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightSeaGreen : Color = new Color( 32, 178, 170, 255, "LightSeaGreen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkCyan;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 139, <strong>B : </strong> 139.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkCyan</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkCyan : Color = new Color( 0, 139, 139, 255, "DarkCyan" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Teal;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 128, <strong>B : </strong> 128.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Teal</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Teal : Color = new Color( 0, 128, 128, 255, "Teal" );
		
		// Couleurs bleues
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Aqua;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 255, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Aqua</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Aqua : Color = new Color( 0, 255, 255, 255, "Aqua" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Cyan;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 255, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Cyan</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Cyan : Color = new Color( 0, 255, 255, 255, "Cyan" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightCyan;">&#xA0;</div>
		 * <strong>R : </strong> 224, <strong>G : </strong> 255, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightCyan</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightCyan : Color = new Color( 224, 255, 255, 255, "LightCyan" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PaleTurquoise;">&#xA0;</div>
		 * <strong>R : </strong> 175, <strong>G : </strong> 238, <strong>B : </strong> 238.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PaleTurquoise</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PaleTurquoise : Color = new Color( 175, 238, 238, 255, "PaleTurquoise" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Aquamarine;">&#xA0;</div>
		 * <strong>R : </strong> 127, <strong>G : </strong> 255, <strong>B : </strong> 212.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Aquamarine</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Aquamarine : Color = new Color( 127, 255, 212, 255, "Aquamarine" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Turquoise;">&#xA0;</div>
		 * <strong>R : </strong> 64, <strong>G : </strong> 224, <strong>B : </strong> 208.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Turquoise</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Turquoise : Color = new Color( 64, 224, 208, 255, "Turquoise" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumTurquoise;">&#xA0;</div>
		 * <strong>R : </strong> 72, <strong>G : </strong> 209, <strong>B : </strong> 204.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumTurquoise</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumTurquoise : Color = new Color( 72, 209, 204, 255, "MediumTurquoise" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkTurquoise;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 206, <strong>B : </strong> 209.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkTurquoise</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkTurquoise : Color = new Color( 0, 206, 209, 255, "DarkTurquoise" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : CadetBlue;">&#xA0;</div>
		 * <strong>R : </strong> 95, <strong>G : </strong> 158, <strong>B : </strong> 160.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>CadetBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const CadetBlue : Color = new Color( 95, 158, 160, 255, "CadetBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SteelBlue;">&#xA0;</div>
		 * <strong>R : </strong> 70, <strong>G : </strong> 130, <strong>B : </strong> 180.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SteelBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SteelBlue : Color = new Color( 70, 130, 180, 255, "SteelBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightSteelBlue;">&#xA0;</div>
		 * <strong>R : </strong> 176, <strong>G : </strong> 196, <strong>B : </strong> 222.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightSteelBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightSteelBlue : Color = new Color( 176, 196, 222, 255, "LightSteelBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : PowderBlue;">&#xA0;</div>
		 * <strong>R : </strong> 176, <strong>G : </strong> 224, <strong>B : </strong> 230.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>PowderBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const PowderBlue : Color = new Color( 176, 224, 230, 255, "PowderBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightBlue;">&#xA0;</div>
		 * <strong>R : </strong> 173, <strong>G : </strong> 216, <strong>B : </strong> 230.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightBlue : Color = new Color( 173, 216, 230, 255, "LightBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SkyBlue;">&#xA0;</div>
		 * <strong>R : </strong> 135, <strong>G : </strong> 206, <strong>B : </strong> 235.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SkyBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SkyBlue : Color = new Color( 135, 206, 235, 255, "SkyBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightSkyBlue;">&#xA0;</div>
		 * <strong>R : </strong> 135, <strong>G : </strong> 206, <strong>B : </strong> 250.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightSkyBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightSkyBlue : Color = new Color( 135, 206, 250, 255, "LightSkyBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DeepSkyBlue;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 191, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DeepSkyBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DeepSkyBlue : Color = new Color( 0, 191, 255, 255, "DeepSkyBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DodgerBlue;">&#xA0;</div>
		 * <strong>R : </strong> 30, <strong>G : </strong> 144, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DodgerBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DodgerBlue : Color = new Color( 30, 144, 255, 255, "DodgerBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : CornflowerBlue;">&#xA0;</div>
		 * <strong>R : </strong> 100, <strong>G : </strong> 149, <strong>B : </strong> 237.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>CornflowerBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const CornflowerBlue : Color = new Color( 100, 149, 237, 255, "CornflowerBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumSlateBlue;">&#xA0;</div>
		 * <strong>R : </strong> 123, <strong>G : </strong> 104, <strong>B : </strong> 238.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumSlateBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumSlateBlue : Color = new Color( 123, 104, 238, 255, "MediumSlateBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : RoyalBlue;">&#xA0;</div>
		 * <strong>R : </strong> 65, <strong>G : </strong> 105, <strong>B : </strong> 225.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>RoyalBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const RoyalBlue : Color = new Color( 65, 105, 225, 255, "RoyalBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Blue;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 0, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Blue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Blue : Color = new Color( 0, 0, 255, 255, "Blue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MediumBlue;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 0, <strong>B : </strong> 205.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MediumBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MediumBlue : Color = new Color( 0, 0, 205, 255, "MediumBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkBlue;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 0, <strong>B : </strong> 139.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkBlue : Color = new Color( 0, 0, 139, 255, "DarkBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Navy;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 0, <strong>B : </strong> 128.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Navy</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Navy : Color = new Color( 0, 0, 128, 255, "Navy" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MidnightBlue;">&#xA0;</div>
		 * <strong>R : </strong> 25, <strong>G : </strong> 25, <strong>B : </strong> 112.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MidnightBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MidnightBlue : Color = new Color( 25, 25, 112, 255, "MidnightBlue" );
		
		// Couleurs marrons
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Cornsilk;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 248, <strong>B : </strong> 220.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Cornsilk</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Cornsilk : Color = new Color( 255, 248, 220, 255, "Cornsilk" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : BlanchedAlmond;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 235, <strong>B : </strong> 205.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>BlanchedAlmond</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const BlanchedAlmond : Color = new Color( 255, 235, 205, 255, "BlanchedAlmond" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Bisque;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 228, <strong>B : </strong> 196.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Bisque</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Bisque : Color = new Color( 255, 228, 196, 255, "Bisque" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : NavajoWhite;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 222, <strong>B : </strong> 173.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>NavajoWhite</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const NavajoWhite : Color = new Color( 255, 222, 173, 255, "NavajoWhite" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Wheat;">&#xA0;</div>
		 * <strong>R : </strong> 245, <strong>G : </strong> 222, <strong>B : </strong> 179.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Wheat</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Wheat : Color = new Color( 245, 222, 179, 255, "Wheat" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : BurlyWood;">&#xA0;</div>
		 * <strong>R : </strong> 222, <strong>G : </strong> 184, <strong>B : </strong> 135.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>BurlyWood</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const BurlyWood : Color = new Color( 222, 184, 135, 255, "BurlyWood" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Tan;">&#xA0;</div>
		 * <strong>R : </strong> 210, <strong>G : </strong> 180, <strong>B : </strong> 140.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Tan</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Tan : Color = new Color( 210, 180, 140, 255, "Tan" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : RosyBrown;">&#xA0;</div>
		 * <strong>R : </strong> 188, <strong>G : </strong> 143, <strong>B : </strong> 143.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>RosyBrown</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const RosyBrown : Color = new Color( 188, 143, 143, 255, "RosyBrown" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SandyBrown;">&#xA0;</div>
		 * <strong>R : </strong> 244, <strong>G : </strong> 164, <strong>B : </strong> 96.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SandyBrown</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SandyBrown : Color = new Color( 244, 164, 96, 255, "SandyBrown" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Goldenrod;">&#xA0;</div>
		 * <strong>R : </strong> 218, <strong>G : </strong> 165, <strong>B : </strong> 32.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Goldenrod</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Goldenrod : Color = new Color( 218, 165, 32, 255, "Goldenrod" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkGoldenrod;">&#xA0;</div>
		 * <strong>R : </strong> 184, <strong>G : </strong> 134, <strong>B : </strong> 11.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkGoldenrod</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkGoldenrod : Color = new Color( 184, 134, 11, 255, "DarkGoldenrod" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Peru;">&#xA0;</div>
		 * <strong>R : </strong> 205, <strong>G : </strong> 133, <strong>B : </strong> 63.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Peru</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Peru : Color = new Color( 205, 133, 63, 255, "Peru" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Chocolate;">&#xA0;</div>
		 * <strong>R : </strong> 210, <strong>G : </strong> 105, <strong>B : </strong> 30.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Chocolate</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Chocolate : Color = new Color( 210, 105, 30, 255, "Chocolate" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SaddleBrown;">&#xA0;</div>
		 * <strong>R : </strong> 139, <strong>G : </strong> 69, <strong>B : </strong> 19.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SaddleBrown</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SaddleBrown : Color = new Color( 139, 69, 19, 255, "SaddleBrown" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Sienna;">&#xA0;</div>
		 * <strong>R : </strong> 160, <strong>G : </strong> 82, <strong>B : </strong> 45.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Sienna</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Sienna : Color = new Color( 160, 82, 45, 255, "Sienna" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Brown;">&#xA0;</div>
		 * <strong>R : </strong> 165, <strong>G : </strong> 42, <strong>B : </strong> 42.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Brown</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Brown : Color = new Color( 165, 42, 42, 255, "Brown" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Maroon;">&#xA0;</div>
		 * <strong>R : </strong> 128, <strong>G : </strong> 0, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Maroon</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Maroon : Color = new Color( 128, 0, 0, 255, "Maroon" );
		
		// Couleurs blanches
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : White;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 255, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>White</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const White : Color = new Color( 255, 255, 255, 255, "White" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Snow;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 250, <strong>B : </strong> 250.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Snow</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Snow : Color = new Color( 255, 250, 250, 255, "Snow" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Honeydew;">&#xA0;</div>
		 * <strong>R : </strong> 240, <strong>G : </strong> 255, <strong>B : </strong> 240.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Honeydew</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Honeydew : Color = new Color( 240, 255, 240, 255, "Honeydew" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MintCream;">&#xA0;</div>
		 * <strong>R : </strong> 245, <strong>G : </strong> 255, <strong>B : </strong> 250.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MintCream</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MintCream : Color = new Color( 245, 255, 250, 255, "MintCream" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Azure;">&#xA0;</div>
		 * <strong>R : </strong> 240, <strong>G : </strong> 255, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Azure</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Azure : Color = new Color( 240, 255, 255, 255, "Azure" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : AliceBlue;">&#xA0;</div>
		 * <strong>R : </strong> 240, <strong>G : </strong> 248, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>AliceBlue</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const AliceBlue : Color = new Color( 240, 248, 255, 255, "AliceBlue" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : GhostWhite;">&#xA0;</div>
		 * <strong>R : </strong> 248, <strong>G : </strong> 248, <strong>B : </strong> 255.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>GhostWhite</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const GhostWhite : Color = new Color( 248, 248, 255, 255, "GhostWhite" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : WhiteSmoke;">&#xA0;</div>
		 * <strong>R : </strong> 245, <strong>G : </strong> 245, <strong>B : </strong> 245.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>WhiteSmoke</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const WhiteSmoke : Color = new Color( 245, 245, 245, 255, "WhiteSmoke" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Seashell;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 245, <strong>B : </strong> 238.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Seashell</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Seashell : Color = new Color( 255, 245, 238, 255, "Seashell" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Beige;">&#xA0;</div>
		 * <strong>R : </strong> 245, <strong>G : </strong> 245, <strong>B : </strong> 220.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Beige</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Beige : Color = new Color( 245, 245, 220, 255, "Beige" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : OldLace;">&#xA0;</div>
		 * <strong>R : </strong> 253, <strong>G : </strong> 245, <strong>B : </strong> 230.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>OldLace</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const OldLace : Color = new Color( 253, 245, 230, 255, "OldLace" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : FloralWhite;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 250, <strong>B : </strong> 240.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>FloralWhite</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const FloralWhite : Color = new Color( 255, 250, 240, 255, "FloralWhite" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Ivory;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 255, <strong>B : </strong> 240.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Ivory</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Ivory : Color = new Color( 255, 255, 240, 255, "Ivory" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : AntiqueWhite;">&#xA0;</div>
		 * <strong>R : </strong> 250, <strong>G : </strong> 235, <strong>B : </strong> 215.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>AntiqueWhite</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const AntiqueWhite : Color = new Color( 250, 235, 215, 255, "AntiqueWhite" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Linen;">&#xA0;</div>
		 * <strong>R : </strong> 250, <strong>G : </strong> 240, <strong>B : </strong> 230.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Linen</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Linen : Color = new Color( 250, 240, 230, 255, "Linen" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LavenderBlush;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 240, <strong>B : </strong> 245.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LavenderBlush</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LavenderBlush : Color = new Color( 255, 240, 245, 255, "LavenderBlush" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : MistyRose;">&#xA0;</div>
		 * <strong>R : </strong> 255, <strong>G : </strong> 228, <strong>B : </strong> 225.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>MistyRose</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const MistyRose : Color = new Color( 255, 228, 225, 255, "MistyRose" );
		
		// Couleurs grises
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Gainsboro;">&#xA0;</div>
		 * <strong>R : </strong> 220, <strong>G : </strong> 220, <strong>B : </strong> 220.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Gainsboro</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Gainsboro : Color = new Color( 220, 220, 220, 255, "Gainsboro" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightGrey;">&#xA0;</div>
		 * <strong>R : </strong> 211, <strong>G : </strong> 211, <strong>B : </strong> 211.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightGrey</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightGrey : Color = new Color( 211, 211, 211, 255, "LightGrey" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Silver;">&#xA0;</div>
		 * <strong>R : </strong> 192, <strong>G : </strong> 192, <strong>B : </strong> 192.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Silver</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Silver : Color = new Color( 192, 192, 192, 255, "Silver" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkGray;">&#xA0;</div>
		 * <strong>R : </strong> 169, <strong>G : </strong> 169, <strong>B : </strong> 169.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkGray</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkGray : Color = new Color( 169, 169, 169, 255, "DarkGray" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Gray;">&#xA0;</div>
		 * <strong>R : </strong> 128, <strong>G : </strong> 128, <strong>B : </strong> 128.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Gray</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Gray : Color = new Color( 128, 128, 128, 255, "Gray" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DimGray;">&#xA0;</div>
		 * <strong>R : </strong> 105, <strong>G : </strong> 105, <strong>B : </strong> 105.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DimGray</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DimGray : Color = new Color( 105, 105, 105, 255, "DimGray" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : LightSlateGray;">&#xA0;</div>
		 * <strong>R : </strong> 119, <strong>G : </strong> 136, <strong>B : </strong> 153.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>LightSlateGray</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const LightSlateGray : Color = new Color( 119, 136, 153, 255, "LightSlateGray" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : SlateGray;">&#xA0;</div>
		 * <strong>R : </strong> 112, <strong>G : </strong> 128, <strong>B : </strong> 144.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>SlateGray</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const SlateGray : Color = new Color( 112, 128, 144, 255, "SlateGray" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : DarkSlateGray;">&#xA0;</div>
		 * <strong>R : </strong> 47, <strong>G : </strong> 79, <strong>B : </strong> 79.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>DarkSlateGray</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const DarkSlateGray : Color = new Color( 47, 79, 79, 255, "DarkSlateGray" );
		/**
		 * <div style="display : inline;  padding-left : 10px; padding-right : 10px; 
		 * border : 1px solid #333; background-color : Black;">&#xA0;</div>
		 * <strong>R : </strong> 0, <strong>G : </strong> 0, <strong>B : </strong> 0.
		 * <p>
		 * Instance de la classe <code>Color</code> représentant 
		 * la couleur <code>Black</code> de la norme SVG 1.0
		 * </p>
		 */
		static public const Black : Color = new Color( 0, 0, 0, 255, "Black" );
		
		/**
		 * L'ensemble des couleurs de la norme SVG 1.0 sous la forme d'un objet <code>Palette</code>.
		 * Les couleurs sont ordonnées par familles de teintes (couleurs rouges, bleues, vertes, etc...)
		 * tel qu'on peut le voir ci dessous :
		 * 
		 * <h3>Couleurs rouge</h3>
		 * <a href="#IndianRed" title="IndianRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : IndianRed;">&#xA0;</div></a>
		 * <a href="#LightCoral" title="LightCoral"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightCoral;">&#xA0;</div></a>
		 * <a href="#Salmon" title="Salmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Salmon;">&#xA0;</div></a>
		 * <a href="#DarkSalmon" title="DarkSalmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSalmon;">&#xA0;</div></a>
		 * <a href="#LightSalmon" title="LightSalmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSalmon;">&#xA0;</div></a>
		 * <a href="#Crimson" title="Crimson"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Crimson;">&#xA0;</div></a>
		 * <a href="#Red" title="Red"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Red;">&#xA0;</div></a>
		 * <a href="#FireBrick" title="FireBrick"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : FireBrick;">&#xA0;</div></a>
		 * <a href="#DarkRed" title="DarkRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkRed;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs roses</h3>
		 * <a href="#Pink" title="Pink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Pink;">&#xA0;</div></a>
		 * <a href="#LightPink" title="LightPink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightPink;">&#xA0;</div></a>
		 * <a href="#HotPink" title="HotPink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : HotPink;">&#xA0;</div></a>
		 * <a href="#DeepPink" title="DeepPink"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DeepPink;">&#xA0;</div></a>
		 * <a href="#MediumVioletRed" title="MediumVioletRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumVioletRed;">&#xA0;</div></a>
		 * <a href="#PaleVioletRed" title="PaleVioletRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleVioletRed;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs oranges</h3>
		 * <a href="#LightSalmon" title="LightSalmon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSalmon;">&#xA0;</div></a>
		 * <a href="#Coral" title="Coral"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Coral;">&#xA0;</div></a>
		 * <a href="#Tomato" title="Tomato"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Tomato;">&#xA0;</div></a>
		 * <a href="#OrangeRed" title="OrangeRed"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : OrangeRed;">&#xA0;</div></a>
		 * <a href="#DarkOrange" title="DarkOrange"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkOrange;">&#xA0;</div></a>
		 * <a href="#Orange" title="Orange"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Orange;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs jaunes</h3>
		 * <a href="#Gold" title="Gold"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Gold;">&#xA0;</div></a>
		 * <a href="#Yellow" title="Yellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Yellow;">&#xA0;</div></a>
		 * <a href="#LightYellow" title="LightYellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightYellow;">&#xA0;</div></a>
		 * <a href="#LemonChiffon" title="LemonChiffon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LemonChiffon;">&#xA0;</div></a>
		 * <a href="#LightGoldenrodYellow" title="LightGoldenrodYellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightGoldenrodYellow;">&#xA0;</div></a>
		 * <a href="#PapayaWhip" title="PapayaWhip"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PapayaWhip;">&#xA0;</div></a>
		 * <a href="#Moccasin" title="Moccasin"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Moccasin;">&#xA0;</div></a>
		 * <a href="#PeachPuff" title="PeachPuff"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PeachPuff;">&#xA0;</div></a>
		 * <a href="#PaleGoldenrod" title="PaleGoldenrod"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleGoldenrod;">&#xA0;</div></a>
		 * <a href="#Khaki" title="Khaki"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Khaki;">&#xA0;</div></a>
		 * <a href="#DarkKhaki" title="DarkKhaki"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkKhaki;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs violettes</h3>
		 * <a href="#Lavender" title="Lavender"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Lavender;">&#xA0;</div></a>
		 * <a href="#Thistle" title="Thistle"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Thistle;">&#xA0;</div></a>
		 * <a href="#Plum" title="Plum"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Plum;">&#xA0;</div></a>
		 * <a href="#Violet" title="Violet"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Violet;">&#xA0;</div></a>
		 * <a href="#Orchid" title="Orchid"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Orchid;">&#xA0;</div></a>
		 * <a href="#Fuchsia" title="Fuchsia"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Fuchsia;">&#xA0;</div></a>
		 * <a href="#Magenta" title="Magenta"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Magenta;">&#xA0;</div></a>
		 * <a href="#MediumOrchid" title="MediumOrchid"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumOrchid;">&#xA0;</div></a>
		 * <a href="#MediumPurple" title="MediumPurple"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumPurple;">&#xA0;</div></a>
		 * <a href="#BlueViolet" title="BlueViolet"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : BlueViolet;">&#xA0;</div></a>
		 * <a href="#DarkViolet" title="DarkViolet"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkViolet;">&#xA0;</div></a>
		 * <a href="#DarkOrchid" title="DarkOrchid"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkOrchid;">&#xA0;</div></a>
		 * <a href="#DarkMagenta" title="DarkMagenta"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkMagenta;">&#xA0;</div></a>
		 * <a href="#Purple" title="Purple"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Purple;">&#xA0;</div></a>
		 * <a href="#Indigo" title="Indigo"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Indigo;">&#xA0;</div></a>
		 * <a href="#SlateBlue" title="SlateBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SlateBlue;">&#xA0;</div></a>
		 * <a href="#DarkSlateBlue" title="DarkSlateBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSlateBlue;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs vertes</h3>
		 * <a href="#GreenYellow" title="GreenYellow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : GreenYellow;">&#xA0;</div></a>
		 * <a href="#Chartreuse" title="Chartreuse"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Chartreuse;">&#xA0;</div></a>
		 * <a href="#LawnGreen" title="LawnGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LawnGreen;">&#xA0;</div></a>
		 * <a href="#Lime" title="Lime"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Lime;">&#xA0;</div></a>
		 * <a href="#LimeGreen" title="LimeGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LimeGreen;">&#xA0;</div></a>
		 * <a href="#PaleGreen" title="PaleGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleGreen;">&#xA0;</div></a>
		 * <a href="#LightGreen" title="LightGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightGreen;">&#xA0;</div></a>
		 * <a href="#MediumSpringGreen" title="MediumSpringGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumSpringGreen;">&#xA0;</div></a>
		 * <a href="#SpringGreen" title="SpringGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SpringGreen;">&#xA0;</div></a>
		 * <a href="#MediumSeaGreen" title="MediumSeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumSeaGreen;">&#xA0;</div></a>
		 * <a href="#SeaGreen" title="SeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SeaGreen;">&#xA0;</div></a>
		 * <a href="#ForestGreen" title="ForestGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : ForestGreen;">&#xA0;</div></a>
		 * <a href="#Green" title="Green"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Green;">&#xA0;</div></a>
		 * <a href="#DarkGreen" title="DarkGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkGreen;">&#xA0;</div></a>
		 * <a href="#YellowGreen" title="YellowGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : YellowGreen;">&#xA0;</div></a>
		 * <a href="#OliveDrab" title="OliveDrab"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : OliveDrab;">&#xA0;</div></a>
		 * <a href="#Olive" title="Olive"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Olive;">&#xA0;</div></a>
		 * <a href="#DarkOliveGreen" title="DarkOliveGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkOliveGreen;">&#xA0;</div></a>
		 * <a href="#MediumAquamarine" title="MediumAquamarine"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumAquamarine;">&#xA0;</div></a>
		 * <a href="#DarkSeaGreen" title="DarkSeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSeaGreen;">&#xA0;</div></a>
		 * <a href="#LightSeaGreen" title="LightSeaGreen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSeaGreen;">&#xA0;</div></a>
		 * <a href="#DarkCyan" title="DarkCyan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkCyan;">&#xA0;</div></a>
		 * <a href="#Teal" title="Teal"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Teal;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs bleues</h3>
		 * <a href="#Aqua" title="Aqua"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Aqua;">&#xA0;</div></a>
		 * <a href="#Cyan" title="Cyan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Cyan;">&#xA0;</div></a>
		 * <a href="#LightCyan" title="LightCyan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightCyan;">&#xA0;</div></a>
		 * <a href="#PaleTurquoise" title="PaleTurquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PaleTurquoise;">&#xA0;</div></a>
		 * <a href="#Aquamarine" title="Aquamarine"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Aquamarine;">&#xA0;</div></a>
		 * <a href="#Turquoise" title="Turquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Turquoise;">&#xA0;</div></a>
		 * <a href="#MediumTurquoise" title="MediumTurquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumTurquoise;">&#xA0;</div></a>
		 * <a href="#DarkTurquoise" title="DarkTurquoise"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkTurquoise;">&#xA0;</div></a>
		 * <a href="#CadetBlue" title="CadetBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : CadetBlue;">&#xA0;</div></a>
		 * <a href="#SteelBlue" title="SteelBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SteelBlue;">&#xA0;</div></a>
		 * <a href="#LightSteelBlue" title="LightSteelBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSteelBlue;">&#xA0;</div></a>
		 * <a href="#PowderBlue" title="PowderBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : PowderBlue;">&#xA0;</div></a>
		 * <a href="#LightBlue" title="LightBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightBlue;">&#xA0;</div></a>
		 * <a href="#SkyBlue" title="SkyBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SkyBlue;">&#xA0;</div></a>
		 * <a href="#LightSkyBlue" title="LightSkyBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSkyBlue;">&#xA0;</div></a>
		 * <a href="#DeepSkyBlue" title="DeepSkyBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DeepSkyBlue;">&#xA0;</div></a>
		 * <a href="#DodgerBlue" title="DodgerBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DodgerBlue;">&#xA0;</div></a>
		 * <a href="#CornflowerBlue" title="CornflowerBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : CornflowerBlue;">&#xA0;</div></a>
		 * <a href="#MediumSlateBlue" title="MediumSlateBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumSlateBlue;">&#xA0;</div></a>
		 * <a href="#RoyalBlue" title="RoyalBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : RoyalBlue;">&#xA0;</div></a>
		 * <a href="#Blue" title="Blue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Blue;">&#xA0;</div></a>
		 * <a href="#MediumBlue" title="MediumBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MediumBlue;">&#xA0;</div></a>
		 * <a href="#DarkBlue" title="DarkBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkBlue;">&#xA0;</div></a>
		 * <a href="#Navy" title="Navy"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Navy;">&#xA0;</div></a>
		 * <a href="#MidnightBlue" title="MidnightBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MidnightBlue;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs marrons</h3>
		 * <a href="#Cornsilk" title="Cornsilk"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Cornsilk;">&#xA0;</div></a>
		 * <a href="#BlanchedAlmond" title="BlanchedAlmond"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : BlanchedAlmond;">&#xA0;</div></a>
		 * <a href="#Bisque" title="Bisque"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Bisque;">&#xA0;</div></a>
		 * <a href="#NavajoWhite" title="NavajoWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : NavajoWhite;">&#xA0;</div></a>
		 * <a href="#Wheat" title="Wheat"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Wheat;">&#xA0;</div></a>
		 * <a href="#BurlyWood" title="BurlyWood"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : BurlyWood;">&#xA0;</div></a>
		 * <a href="#Tan" title="Tan"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Tan;">&#xA0;</div></a>
		 * <a href="#RosyBrown" title="RosyBrown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : RosyBrown;">&#xA0;</div></a>
		 * <a href="#SandyBrown" title="SandyBrown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SandyBrown;">&#xA0;</div></a>
		 * <a href="#Goldenrod" title="Goldenrod"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Goldenrod;">&#xA0;</div></a>
		 * <a href="#DarkGoldenrod" title="DarkGoldenrod"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkGoldenrod;">&#xA0;</div></a>
		 * <a href="#Peru" title="Peru"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Peru;">&#xA0;</div></a>
		 * <a href="#Chocolate" title="Chocolate"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Chocolate;">&#xA0;</div></a>
		 * <a href="#SaddleBrown" title="SaddleBrown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SaddleBrown;">&#xA0;</div></a>
		 * <a href="#Sienna" title="Sienna"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Sienna;">&#xA0;</div></a>
		 * <a href="#Brown" title="Brown"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Brown;">&#xA0;</div></a>
		 * <a href="#Maroon" title="Maroon"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Maroon;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs blanches</h3>
		 * <a href="#White" title="White"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : White;">&#xA0;</div></a>
		 * <a href="#Snow" title="Snow"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Snow;">&#xA0;</div></a>
		 * <a href="#Honeydew" title="Honeydew"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Honeydew;">&#xA0;</div></a>
		 * <a href="#MintCream" title="MintCream"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MintCream;">&#xA0;</div></a>
		 * <a href="#Azure" title="Azure"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Azure;">&#xA0;</div></a>
		 * <a href="#AliceBlue" title="AliceBlue"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : AliceBlue;">&#xA0;</div></a>
		 * <a href="#GhostWhite" title="GhostWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : GhostWhite;">&#xA0;</div></a>
		 * <a href="#WhiteSmoke" title="WhiteSmoke"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : WhiteSmoke;">&#xA0;</div></a>
		 * <a href="#Seashell" title="Seashell"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Seashell;">&#xA0;</div></a>
		 * <a href="#Beige" title="Beige"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Beige;">&#xA0;</div></a>
		 * <a href="#OldLace" title="OldLace"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : OldLace;">&#xA0;</div></a>
		 * <a href="#FloralWhite" title="FloralWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : FloralWhite;">&#xA0;</div></a>
		 * <a href="#Ivory" title="Ivory"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Ivory;">&#xA0;</div></a>
		 * <a href="#AntiqueWhite" title="AntiqueWhite"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : AntiqueWhite;">&#xA0;</div></a>
		 * <a href="#Linen" title="Linen"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Linen;">&#xA0;</div></a>
		 * <a href="#LavenderBlush" title="LavenderBlush"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LavenderBlush;">&#xA0;</div></a>
		 * <a href="#MistyRose" title="MistyRose"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : MistyRose;">&#xA0;</div></a>
		 * 
		 * <h3>Couleurs grises</h3>
		 * <a href="#Gainsboro" title="Gainsboro"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Gainsboro;">&#xA0;</div></a>
		 * <a href="#LightGrey" title="LightGrey"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightGrey;">&#xA0;</div></a>
		 * <a href="#Silver" title="Silver"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Silver;">&#xA0;</div></a>
		 * <a href="#DarkGray" title="DarkGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkGray;">&#xA0;</div></a>
		 * <a href="#Gray" title="Gray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Gray;">&#xA0;</div></a>
		 * <a href="#DimGray" title="DimGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DimGray;">&#xA0;</div></a>
		 * <a href="#LightSlateGray" title="LightSlateGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : LightSlateGray;">&#xA0;</div></a>
		 * <a href="#SlateGray" title="SlateGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : SlateGray;">&#xA0;</div></a>
		 * <a href="#DarkSlateGray" title="DarkSlateGray"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : DarkSlateGray;">&#xA0;</div></a>
		 * <a href="#Black" title="Black"><div style="display : inline; padding : 2 px; padding-left : 10px; padding-right : 10px; border : 1px solid #333; background-color : Black;">&#xA0;</div></a>
		 * 
		 */
		static public const PALETTE_SVG : Palette = new Palette("SVG 1.0", 
																//Couleurs rouge
																IndianRed, LightCoral, Salmon, DarkSalmon,
																LightSalmon, Crimson,Red, FireBrick, DarkRed,
																
																//Couleurs roses
																Pink, LightPink, HotPink, DeepPink, 
																MediumVioletRed, PaleVioletRed,
																
																//Couleurs oranges
																LightSalmon, Coral, Tomato, OrangeRed, 
																DarkOrange, Orange,
																
																//Couleurs jaunes
																Gold, Yellow, LightYellow, LemonChiffon, LightGoldenrodYellow,
																PapayaWhip, Moccasin, PeachPuff, PaleGoldenrod, Khaki, DarkKhaki,
																
																//Couleurs violettes
																Lavender, Thistle, Plum, Violet, Orchid, 
																Fuchsia, Magenta, MediumOrchid, MediumPurple, 
																BlueViolet, DarkViolet, DarkOrchid, DarkMagenta, 
																Purple, Indigo, SlateBlue, DarkSlateBlue,
																
																//Couleurs vertes
																GreenYellow, Chartreuse, LawnGreen, Lime, 
																LimeGreen, PaleGreen, LightGreen, MediumSpringGreen, 
																SpringGreen, MediumSeaGreen, SeaGreen, ForestGreen, 
																Green, DarkGreen, YellowGreen, OliveDrab, Olive, 
																DarkOliveGreen, MediumAquamarine, DarkSeaGreen, 
																LightSeaGreen, DarkCyan, Teal,
																
																//Couleurs bleues
																Aqua, Cyan, LightCyan, PaleTurquoise, Aquamarine,
																Turquoise, MediumTurquoise, DarkTurquoise, CadetBlue, 
																SteelBlue, LightSteelBlue, PowderBlue, LightBlue, 
																SkyBlue, LightSkyBlue, DeepSkyBlue, DodgerBlue, 
																CornflowerBlue, MediumSlateBlue, RoyalBlue, Blue, 
																MediumBlue, DarkBlue, Navy, MidnightBlue,
																
																//Couleurs marrons
																Cornsilk, BlanchedAlmond, Bisque, NavajoWhite, 
																Wheat, BurlyWood, Tan, RosyBrown, SandyBrown, 
																Goldenrod, DarkGoldenrod, Peru, Chocolate, 
																SaddleBrown, Sienna, Brown, Maroon,
																
																//Couleurs blanches
																White, Snow, Honeydew, MintCream, Azure, 
																AliceBlue, GhostWhite, WhiteSmoke, Seashell, 
																Beige, OldLace, FloralWhite, Ivory, AntiqueWhite, 
																Linen, LavenderBlush, MistyRose,
																
																// Couleurs grises
																Gainsboro, LightGrey, Silver, DarkGray, 
																Gray, DimGray, LightSlateGray, SlateGray, 
																DarkSlateGray, Black );

		/*
		 * INSTANCE MEMBERS 
		 */
		/**
		 * La valeur du canal rouge.
		 */
		[Form(type="uintSlider", range="0,255", order="1")]
		public var red : uint;
		/**
		 * La valeur du canal vert.
		 */
		[Form(type="uintSlider", range="0,255", order="2")]
		public var green : uint;
		/**
		 * La valeur du canal bleu.
		 */
		[Form(type="uintSlider", range="0,255", order="3")]
		public var blue : uint;
		/**
		 * La valeur du canal de transparence.
		 */
		[Form(type="uintSlider", range="0,255", order="4")]
		public var alpha : uint;
		
		/*
		 * Un nom pour la couleur, les couleurs s'enregistre avec leur
		 * nom si celui-ci n'est pas vide
		 */
		private var _name : String; 
		
		/**
		 * Crée une nouvelle instance de la classe <code>Color</code>.
		 * <p>
		 * Le constructeur de la classe <code>Color</code> supporte 
		 * toutes les configurations ci-dessous :
		 * </p>
		 * <ul>
		 * <li><listing>new Color ();</listing>
		 * La valeur par défaut est utilisé (<code>0xff000000</code>).</li>
		 * <li><listing>new Color ( 255, 255, 255 );</listing></li>
		 * <li><listing>new Color ( 255, 255, 255, 255 );</listing></li>
		 * <li><listing>new Color ( 255, 255, 255, 255, "Nom de la couleur" );</listing></li>
		 * <li><listing>new Color ( "fff" );</listing>
		 * Chaque caractère de la chaîne sera utilisé pour définir les canaux
		 * rouge, vert et bleu respectivement.</li>
		 * <li><listing>new Color ( "#fff" );</listing>
		 * Chaque caractère de la chaîne sera utilisé pour définir les canaux
		 * rouge, vert et bleu respectivement.</li>
		 * <li><listing>new Color ( "0xfff" );</listing>
		 * Chaque caractère de la chaîne sera utilisé pour définir les canaux
		 * rouge, vert et bleu respectivement.</li> 
		 * <li><listing>new Color ( "ffff" );</listing>
		 * Chaque caractère de la chaîne sera utilisé pour définir les canaux
		 * rouge, vert, bleu et alpha respectivement.</li>
		 * <li><listing>new Color ( "#ffff" );</listing>
		 * Chaque caractère de la chaîne sera utilisé pour définir les canaux
		 * rouge, vert, bleu et alpha respectivement.</li>
		 * <li><listing>new Color ( "0xffff" );</listing>
		 * Chaque caractère de la chaîne sera utilisé pour définir les canaux
		 * rouge, vert, bleu et alpha respectivement.</li>
		 * <li><listing>new Color ( "ffffff" );</listing>
		 * Chaque paire de caractère de la chaîne sera utilisé pour définir
		 * les canaux rouge, vert et bleu respectivement.</li>
		 * <li><listing>new Color ( "#ffffff" );</listing>
		 * Chaque paire de caractère de la chaîne sera utilisé pour définir
		 * les canaux rouge, vert et bleu respectivement.</li>
		 * <li><listing>new Color ( "0xffffff" );</listing>
		 * Chaque paire de caractère de la chaîne sera utilisé pour définir
		 * les canaux rouge, vert et bleu respectivement.</li>
		 * <li><listing>new Color ( "ffffffff" );</listing>
		 * Chaque paire de caractère de la chaîne sera utilisé pour définir
		 * les canaux rouge, vert, bleu et alpha respectivement.</li>
		 * <li><listing>new Color ( "#ffffffff" );</listing>
		 * Chaque paire de caractère de la chaîne sera utilisé pour définir
		 * les canaux rouge, vert, bleu et alpha respectivement.</li>
		 * <li><listing>new Color ( "0xffffffff" );</listing>
		 * Chaque paire de caractère de la chaîne sera utilisé pour définir
		 * les canaux rouge, vert, bleu et alpha respectivement.</li>
		 * </ul>
		 * <p>
		 * Dans tout les cas où la valeur de transparence a été ommise
		 * celle-ci se voit affecter la valeur <code>255</code>.
		 * </p>
		 * <p>
		 * Si le nom de la couleur n'est pas une chaîne vide, elle sera
		 * utilisée comme clé d'accès pour la méthode <code>Color.get</code>.
		 * </p>
		 * 
		 * @param	r		selon le nombre d'argument et le type de <code>r</code> : <ul>
		 * 					<li>un entier représentant la valeur de chaque canal
		 * 					si un seul argument a été transmis à la fonction</li>
		 * 					<li>un entier représentant la valeur du canal rouge</li>
		 * 					<li>une chaîne héxadécimale représentant une couleur
		 * 					valide, et qui valide l'expression rationnelle suivante:
		 * 					<listing>/^(#|0x)&#42;[a-fA-F0-9]{3,8}$/</listing></li></ul>
		 * @param	g		un entier représentant la valeur du canal vert, n'est
		 * 					pas utilisé si le premier paramètre est une chaîne
		 * @param	b		un entier représentant la valeur du canal bleu, n'est
		 * 					pas utilisé si le premier paramètre est une chaîne
		 * @param	a		un entier représentant la valeur du canal alpha, n'est
		 * 					pas utilisé si le premier paramètre est une chaîne
		 * @param	name	le nom de la couleur
		 */
		public function Color ( r : * 	 = 0x00, 
								g : * = 0x00, 
								b : uint = 0x00, 
								a : uint = 0xff,
								name : String = "" )
		{
			if( r is String )
			{
				var regex : RegExp = /^(#|0x)*[a-fA-F0-9]{3,8}$/;
				var scol : String = r as String;
				
				if( g && g is String )
					_name = g;
				
				if( regex.test( scol ) )
				{
					var _r : Number = 0x00;
					var _g : Number = 0x00;
					var _b : Number = 0x00;
					var _a : Number = 0xff;
					
					scol = scol.replace( /^(#|0x)+/ , "" );
					
					switch( scol.length )
					{
						// "0xffff"
						case 4 :
							_a = parseInt( "0x" + scol.substr( 0, 1 ) + scol.substr( 0, 1 ) );
							scol = scol.substr( 1 );
						// "0xfff"
						case 3 :
							_r = parseInt( "0x" + scol.substr( 0, 1 ) + scol.substr( 0, 1 ) );
							_g = parseInt( "0x" + scol.substr( 1, 1 ) + scol.substr( 1, 1 ) );
							_b = parseInt( "0x" + scol.substr( 2, 1 ) + scol.substr( 2, 1 ) );
							break;
						// "0xffffffff"
						case 8 :
							_a = parseInt( "0x" + scol.substr( 0, 2 ) );
							scol = scol.substr( 2 );
						// "0xffffff"
						case 6 :
							_r = parseInt( "0x" + scol.substr( 0, 2 ) );
							_g = parseInt( "0x" + scol.substr( 2, 2 ) );
							_b = parseInt( "0x" + scol.substr( 4, 2 ) );
							break;
						default : 
							_r = 0x00;
							_g = 0x00;
							_b = 0x00;
							_a = 0xff;
							break;	
					}
					red   = _r;
					green = _g;
					blue  = _b;
					alpha = _a;
				}
				else
				{
					red   = 0x00;
					green = 0x00;
					blue  = 0x00;
					alpha = 0xff;
				}
			}
			else if( r is uint )
			{
				// new Color( 0xffffffff ) or new Color( 0xffffffff, "name" )
				if( arguments.length == 1 || ( arguments.length == 2 && g && g is String )  )
				{
					alpha = r >> 24 & 0xff; 
					red   = r >> 16 & 0xff; 
					green = r >> 8 & 0xff; 
					blue  = r & 0xff; 
					
					if( g && g is String )
						_name = g;
				}
				// new Color( 255, 255, 255, 255 )
				else
				{
					red   = r & 0xff;
					green = g & 0xff;
					blue  = b & 0xff;
					alpha = a & 0xff;
					_name = name;
				}
			}
			
			// on enregistre la couleur sous son nom, si il n'y a pas de couleur
			// déjà enregistrée à ce nom
			if( _name != "" && !INSTANCES.hasOwnProperty( _name ) )
				INSTANCES[ _name ] = this;
			
		}
		/**
		 * Renvoie le nom de la couleur, il sert aussi de clé d'accès
		 * à la couleur dans la méthode <code>Color.get</code>. 
		 * <p>
		 * Lorsque le nom d'une couleur est changé la clé d'accès change
		 * elle aussi, écrasant potentiellement une précédente valeur.
		 * </p>
		 */
		/*[Form(type="string", defaultValue="''", order="0")]*/
		public function get name () : String { return _name; }
		public function set name ( name : String ) : void 
		{ 
			if( _name != "" )
				delete INSTANCES[_name];
				
			_name = name;
			INSTANCES[_name] = this;
		}

		/**
		 * Renvoie une chaîne héxadécimale représentant la couleur
		 * en RGBA sous la forme <code>AARRGGBB</code>.
		 * 
		 * @return 	une chaîne héxadécimale sous la forme <code>AARRGGBB</code>
		 */
		public function get rgba () : String
		{
			var str:String = ( ( uint( alpha << 24 ) ) +
							   ( uint( red   << 16 ) ) + 
							   ( uint( green << 8  ) ) + 
							  	       blue 	   ).toString( 16 );
							   
			var toFill:Number = 8 - str.length;
			while (toFill--) 
			{
				str = "0" + str ;
			}	
			return str.toLowerCase();
		   
		}
		/**
		 * Renvoie une chaîne héxadécimale représentant la couleur
		 * en RGB sous la forme <code>RRGGBB</code>.
		 * 
		 * @return 	une chaîne héxadécimale sous la forme <code>RRGGBB</code>
		 */
		public function get rgb () : String
		{
			var str:String = ( ( uint( red   << 16 ) ) + 
							   ( uint( green << 8  ) ) + 
							  	       blue 	   ).toString( 16 );
							   
			var toFill:Number = 6 - str.length;
			while (toFill--) 
			{
				str = "0" + str ;
			}	
			return str.toLowerCase();
		}
		public function get hsv () : Array
		{
		    var r : Number = red / 255; 
		    var g : Number = green / 255;
		    var b : Number = blue / 255;
		    var h : Number;
		    var s : Number;
		    var v : Number;            
	        var minVal : Number = Math.min(r, g, b);
	        var maxVal : Number  = Math.max(r, g, b);
	        var delta : Number = maxVal - minVal;

	         v = maxVal;

	        if (delta == 0) {
		        h = 0;
		        s = 0;
	        } else {
		        s = delta / maxVal;
		        var del_R : Number = (((maxVal - r) / 6) + (delta / 2)) / delta;
		        var del_G : Number = (((maxVal - g) / 6) + (delta / 2)) / delta;
		        var del_B : Number = (((maxVal - b) / 6) + (delta / 2)) / delta;

		        if (r == maxVal) { h = del_B - del_G;}
		        else if (g == maxVal) {h = (1 / 3) + del_R - del_B;}
		        else if (b == maxVal) {h = (2 / 3) + del_G - del_R;}
		
		        if (h < 0) {h += 1;}
		        if (h > 1) {h -= 1;}
	        }
	        h *= 360;
	        s *= 100;
	        v *= 100;
	        return [h,s,v];
		}
		public function set hsv ( hsv : Array ) : void
		{
		    var h : Number = hsv[0] / 360; 
		    var s : Number = hsv[1] / 100; 
		    var v : Number = hsv[2] / 100;
		    var r : Number; 
		    var g : Number;
		    var b : Number;
		    
	        if (s == 0)
	        {
		        red = v * 255;
		        green = v * 255;
		        blue = v * 255;
	        } 
	        else 
	        {
		        var var_h : Number = h * 6;
		        var var_i : Number = Math.floor(var_h);
		        var var_1 : Number = v * (1 - s);
		        var var_2 : Number = v * (1 - s * (var_h - var_i));
		        var var_3 : Number = v * (1 - s * (1 - (var_h - var_i)));
		    
		        if (var_i == 0)      {r = v;        g = var_3;      b = var_1}
		        else if (var_i == 1) {r = var_2;    g = v;          b = var_1}
		        else if (var_i == 2) {r = var_1;    g = v;          b = var_3}
		        else if (var_i == 3) {r = var_1;    g = var_2;      b = v}
		        else if (var_i == 4) {r = var_3;    g   = var_1;    b = v}
		        else                 {r = v;        g = var_1;      b = var_2};
		
		        red = r * 255;
		        green = g * 255;
		        blue = b * 255;
	        }
		}
		
		/**
		 * Renvoie une chaîne héxadécimale sous la forme <code>#RRGGBB</code>.
		 * 
		 * @return une chaîne héxadécimale sous la forme <code>#RRGGBB</code>
		 */
		public function get html () : String
		{
			return "#" + rgb;
		}
		/**
		 * Renvoie une chaîne héxadécimale sous la forme <code>#RRGGBBAA</code>.
		 * 
		 * @return une chaîne héxadécimale sous la forme <code>#RRGGBBAA</code>
		 */
		public function get htmlRGBA () : String
		{
			return "#" + rgba;
		}
		/**
		 * Renvoie un entier sous la forme <code>0xRRGGBB</code>.
		 * 
		 * @return un entier sous la forme <code>0xRRGGBB</code>
		 */
		public function get hexa () : uint
		{
			return ( ( uint( red   << 16 ) ) + 
				  	 ( uint( green << 8  ) ) + 
							 blue 	   );
		}
		/**
		 * Renvoie un entier sous la forme <code>0xAARRGGBB</code>.
		 * 
		 * @return un entier sous la forme <code>0xAARRGGBB</code>
		 */
		public function get hexaRGBA () : uint
		{
			return ( ( uint( alpha << 24 ) ) + 
					 ( uint( red   << 16 ) ) + 
				  	 ( uint( green << 8  ) ) + 
							 blue 	   );
		}
		/**
		 * Renvoie un tableau de flottants compris entre 0 et 1 sous
		 * la forme <code>[ r, g, b ]</code>.
		 * 
		 * @return	un tableau de flotants compris entre 0 et 1 sous
		 * 			la forme <code>[ r, g, b ]
		 */
		public function get float3 () : Array
		{
			var vec : Array = new Array ( red / 0xff, green / 0xff, blue / 0xff );
			
			return vec;
		}
		/**
		 * Renvoie un tableau de flottants compris entre 0 et 1 sous
		 * la forme <code>[ r, g, b, a ]</code>.
		 * 
		 * @return	un tableau de flotants compris entre 0 et 1 sous
		 * 			la forme <code>[ r, g, b, a ]</code>
		 */
		public function get float4 () : Array
		{
			var vec : Array = new Array ( red / 0xff, green / 0xff, blue / 0xff, alpha / 0xff );
			
			return vec;
		} 
		
		/**
		 * Inverse les valeurs de chaque composante à l'exception
		 * de la composante alpha.
		 */
		public function negative () : void
		{
			red = 255 - red;
			green = 255 - green;
			blue = 255 - blue;
		}
		
		public function blend ( color : Color, method : Function ) : Color
		{
			var r : uint = method( red, color.red );
			var g : uint = method( green, color.green ); 
			var b : uint = method( blue, color.blue ); 
			var a : uint = method( alpha, color.alpha ); 
			
			return new Color(r,g,b,a);
		}
		
		/**
		 * Renvoie la couleur intermédiaire entre la couleur actuelle et <code>col</code>,
		 * <code>ratio</code> étant un nombre entre 0 et 1 indiquant la proportion de 
		 * <code>col</code> dans ce nouveau mélange.
		 * 
		 * @param	col		couleur à mélanger avec cette instance
		 * @param	ratio	proportion de <code>col</code> que contiendra le mélange final
		 * @return	une nouvelle instance de <code>Color</code> représentant
		 * 			le nouveau mélange
		 */
		public function interpolate ( col : Color, ratio : Number, preserveAlpha : Boolean = true ) : Color
		{
			var iratio : Number = 1 - ratio;
			if(!col)
				return clone();
			
			return new Color( Math.floor( red 	* iratio + col.red 	 * ratio ),
							  Math.floor( green * iratio + col.green * ratio ),
							  Math.floor( blue 	* iratio + col.blue  * ratio ),
							  Math.floor( preserveAlpha ? alpha : ( alpha * iratio + col.alpha * ratio ) ) );
		}
		public function subtract ( col : Color, ratio : Number, preserveAlpha : Boolean = true ) : Color 
		{
			if(!col)
				return clone();
			
			return new Color( Math.floor( MathUtils.restrict( red 	- col.red * ratio, 0, 255 ) ),
							  Math.floor( MathUtils.restrict( green	- col.green * ratio, 0, 255 ) ),
							  Math.floor( MathUtils.restrict( blue 	- col.blue * ratio, 0, 255 ) ),
							  Math.floor( preserveAlpha ? alpha : MathUtils.restrict( alpha	- col.alpha * ratio, 0, 255 ) ) );
		}
		public function add ( col : Color, ratio : Number, preserveAlpha : Boolean = true ) : Color 
		{
			if(!col)
				return clone();
			
			return new Color( Math.floor( MathUtils.restrict( red 	+ col.red * ratio, 0, 255 ) ),
							  Math.floor( MathUtils.restrict( green	+ col.green * ratio, 0, 255 ) ),
							  Math.floor( MathUtils.restrict( blue 	+ col.blue * ratio, 0, 255 ) ),
							  Math.floor( preserveAlpha ? alpha : MathUtils.restrict( alpha	+ col.alpha * ratio, 0, 255 ) ) );
		}
		/**
		 * 
		 * @param	n
		 * @return
		 */
		public function toColorTransform (n : Number) : ColorTransform
		{
			return new ColorTransform(1-n, 1-n, 1-n, 1, int(red*n), int(green*n), int(blue*n), 0);
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString () : String
		{
			return StringUtils.stringify(this, {rgba:"0x"+rgba} );
		}
		/**
		 * Renvoie la représentation du code source permettant 
		 * de recréer l'instance courante.
		 * 
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 */
		public function toSource () : String
		{
			return StringUtils.tokenReplace("new $0($1,$2,$3,$4,'$5')",
											getQualifiedClassName(this).replace("::","."),
											red,
											green,
											blue,
											alpha,
											_name );
		}
		/**
		 * Renvoie la représentation du code source permettant 
		 * de recréer l'instance courante à l'aide de la méthode
		 * <code>Reflection.get</code>.
		 * 
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 * @see	Reflection#get()
		 */
		public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace( "color(0x$0)", rgba );
		}
		
		/**
		 * Renvoie une copie de l'objet courant.
		 * 
		 * @return une copie de l'objet courant
		 */
		public function clone () : *
		{
			return new Color( red, green, blue, alpha );
		}
		
		public function brighterClone ( add : uint = 0 ) : Color
		{
			return new Color( Math.min( red + add ,255 ),
							  Math.min( green + add ,255 ), 
							  Math.min( blue + add ,255 ), alpha );
		}
		public function darkerClone ( rm : uint = 0 ) : Color
		{
			return new Color( Math.max( red-rm, 0 ),
							  Math.max( green-rm, 0 ), 
							  Math.max( blue-rm, 0 ), alpha );
		}
		/**
		 * Renvoie une copie de l'objet courant mais avec un canal
		 * alpha modifié avec la valeur tramsmise à la fonction.
		 * <p>
		 * Le nom de la couleur est modifiée lui aussi pour empêcher
		 * tout conflit de nom lors de l'enregistrement des couleurs
		 * nommées. La nouvelle couleur porte un nom sous la forme
		 * <code>"{nom de la couleur d'origine}[a={alpha}]</code>.
		 * </p>
		 * 
		 * @param	alpha	la valeur du canal alpha de la copie
		 * @return	une copie de l'objet courant avec le canal alpha
		 * 		  	et le nom transformés
		 */
		public function alphaClone ( alpha : uint = 0xff ) : Color
		{
			return new Color( red, green, blue, alpha );
		}
		/**
		 * Compare les composantes de la couleur <code>o</code> avec celles de la couleurs
		 * courante, et renvoie <code>true</code> si toutes les composantes sont équivalentes.
		 * Renvoie <code>false</code> dans tout les autres cas
		 * 
		 * @param	o	objet <code>Color</code> à comparer avec la couleur courante
		 * @return	<code>true</code> si toutes les composantes des deux couleurs sont équivalentes
		 */
		public function equals (o : *) : Boolean
		{
			if( o is Color )
			{
				var c : Color = o as Color;
				return c.red == red &&
					   c.green == green &&
					   c.blue == blue &&
					   c.alpha == alpha;
			}
			
			return false;
		}
		public function copyTo (o : Object) : void
		{
			o["red"] = red;
			o["green"] = green;
			o["blue"] = blue;
			o["alpha"] = alpha;
			
			if( _name && _name != "" )
				o["name"] = _name;
		}
		public function copyFrom (o : Object) : void
		{
			safePropertyCopy( o , "red", this, "red" );
			safePropertyCopy( o , "green", this, "green" );
			safePropertyCopy( o , "blue", this, "blue" );
			safePropertyCopy( o , "alpha", this, "alpha" );
		}
	}
}
