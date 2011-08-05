package abe.com.pile
{
    import abe.com.pile.units.CompilationUnit;
    /**
     * @author cedric
     */
    public function compile ( unit : CompilationUnit,
                              inplace : Boolean = false ) : void
    {
        CompilationManagerInstance.compile(unit, inplace);
    }
}
