package abe.com.mon.utils
{
    /**
     * @author cedric
     */
    public function getReflectionSource ( o : *, defaults : String) : String
    {
        return reflectionSourcesDictionary[o] ? reflectionSourcesDictionary[o] : defaults;
    }
}
