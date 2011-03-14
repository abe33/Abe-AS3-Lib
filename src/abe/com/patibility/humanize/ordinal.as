package abe.com.patibility.humanize
{
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	/**
	 * @author cedric
	 */
	public function ordinal ( v : uint ) : String 
	{
		
		var r1 : uint = v % 100;		var r2 : uint = v % 10;
		if( [11,12,13].indexOf( r1 ) != -1 )
			return _$(_("$0$1"), v, ORDINALS[0] );		else
			return _$(_("$0$1"), v, ORDINALS[r2] );
	}
}

import abe.com.patibility.lang._;

internal const ORDINALS : Array = [_("th"),_("st"), _("nd"), _("rd"), _("th"), _("th"), _("th"), _("th"), _("th"), _("th")];
