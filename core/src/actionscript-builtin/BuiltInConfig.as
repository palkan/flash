package  {
 //   import org.flowplayer.rtmp.RTMPStreamProvider;


public class BuiltInConfig {
   // private var rtmp:org.flowplayer.rtmp.RTMPStreamProvider;

    [Embed(source="../assets/play.png",compression="true",quality="100")]
    public var PlayButton:Class;
//
//    [Embed(source="../assets/play.png")]
//    public var Logo:Class;

    public static const config:Object = { 
       "plugins": {
     /*   "rtmp": {
            "url": 'org.flowplayer.rtmp.RTMPStreamProvider'
        }*/
       }
    };
}
}