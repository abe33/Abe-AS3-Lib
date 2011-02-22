package abe.com.ponents.utils 
{
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;

	import flash.ui.ContextMenuItem;

	/**
	 * @author cedric
	 */
	public class ContextMenuItemUtils 
	{
		
		/*FDT_IGNORE*/ /*TARGET::AIR*/ /*FDT_IGNORE*/ /*static public function getContextMenuItem ( name : String) : NativeMenuItem 
		{
			return new NativeMenuItem( name );		}*/
		
		/*FDT_IGNORE*/ TARGET::WEB /*FDT_IGNORE*/ static public function getContextMenuItem ( name : String) : ContextMenuItem 
		{
			return new ContextMenuItem( name );
		}
		
		static public function getBooleanContextMenuItemCaption ( caption : String, bool : Boolean ) : String
		{
			return bool ? 
					_$(_("✔ $0"), caption) : 
					_$(_("   $0"), caption);
		}
	}										   
}
