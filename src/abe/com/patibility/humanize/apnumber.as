package abe.com.patibility.humanize
{
	/**
	 * @author cedric
	 */
	public function apnumber ( v : * ) : String 
	{
		if( v is String )
			v = parseInt( v );
		
		v = int( v );
		if( v > 0 && v < 10 )
			return NUMBERS[ v ];
		else
			return String( v );
	}
}

import abe.com.patibility.lang._;

internal const NUMBERS : Array = [ _("one"), _("two"), _("three"), _("four"), _("five"), _("six"), _("seven"), _("eight"), _("nine") ];
