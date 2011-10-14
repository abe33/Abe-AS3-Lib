package abe.com.edia.sounds
{
    import flash.media.Sound;
    import flash.media.SoundChannel;
    /**
     * @author cedric
     */
    public interface SoundProcessor
    {
        function get input():Sound;
        function set input( snd:Sound ):void;
        
        function get output():Sound;
        
        function set channel ( soundChannel : SoundChannel ):void;
    }
}
