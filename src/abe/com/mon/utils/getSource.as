package abe.com.mon.utils
{
    /**
     * @author cedric
     */
    public function getSource ( o : *, defaults : String = "" ) : String
    {
        return sourcesDictionary[o] ? sourcesDictionary[o] : defaults;
    }
}
