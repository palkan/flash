package org.flowplayer.rs.controls {
import com.longtailvideo.jwplayer.utils.Logger;
import com.longtailvideo.jwplayer.view.interfaces.ISkin;
import com.longtailvideo.jwplayer.view.skins.SkinProperties;

import flash.display.Bitmap;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;


public class ControlsSkin extends EventDispatcher implements ISkin {

    [Embed(source="../../../../../../../../ruskin/controlbar/background.png")]
    public var BG:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/cap.png")]
    public var Divider:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/blankButton.png")]
    public var Blank:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/playButton.png")]
    public var Play:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/pauseButton.png")]
    public var Pause:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/timeSliderRail.png")]
    public var TimeRail:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/timeSliderBuffer.png")]
    public var TimeBuffer:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/timeSliderProgress.png")]
    public var TimeProgress:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/muteButton.png")]
    public var Mute:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/unmuteButton.png")]
    public var Unmute:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/volumeSliderRail.png")]
    public var VolumeRail:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/volumeSliderProgress.png")]
    public var VolumeProgress:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/fullscreenButton.png")]
    public var FullScreen:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/normalscreenButton.png")]
    public var NormalScreen:Class;
    [Embed(source="../../../../../../../../ruskin/controlbar/tooltip.png")]
    public var TimeTooltipBack:Class;

    [Embed(source="../../../../../../../../ruskin/RussiaSport/timeSliderThumb.png")]
    public var TimeSliderThumb:Class;

    [Embed(source="../../../../../../../../ruskin/RussiaSport/volumeThumb.png")]
    public var VolumeSliderThumb:Class;


    [Embed(source="../../../../../../../../ruskin/RussiaSport/icon.png")]
    public var RussiaSportIcon:Class;

    [Embed(source="../../../../../../../../ruskin/RussiaSport/tooltip.png")]
    public var RussiaSportTooltip:Class;

    [Embed(source="../../../../../../../../ruskin/RussiaSport/plusone.png")]
    public var PlusOneIcon:Class;

    [Embed(source="../../../../../../../../ruskin/controlbar/live.png")]
    public var LiveIcon:Class;



    private var _elements:Object = {
        controlbar:{
            background: BG,
            divider: Divider,
            blankButton: Blank,
            playButton:Play,
            pauseButton: Pause,
            timeSliderRail: TimeRail,
            timeSliderBuffer: TimeBuffer,
            timeSliderProgress: TimeProgress,
            muteButton: Mute,
            unmuteButton: Unmute,
            volumeSliderRail: VolumeRail,
            volumeSliderProgress: VolumeProgress,
            fullscreenButton: FullScreen,
            normalscreenButton: NormalScreen,
            russiasportButton:RussiaSportIcon,
            russiasportTooltip:RussiaSportTooltip,
            plusoneButton:PlusOneIcon,
            timeSliderThumb:TimeSliderThumb,
            volumeSliderThumb:VolumeSliderThumb,
            timeTooltipBg: TimeTooltipBack,
            liveIcon: LiveIcon
        }
    };

    private var _settings:SkinProperties;


    public function ControlsSkin(){

        _settings = new SkinProperties();
        _settings.fontcolor = "0xFFFFFF";
        _settings.margin = 0;
        _settings.fontsize = 11;

        _settings.layout = {
            controlbar: {
                left: [
                    {type:'button', name:'play'},
                    {type:'divider',name:'divider'},
                    {type:'button',name:'mute'},
                    {type:'slider',name:'volume'},
                    {type:'divider',name:'divider'},
                    {type:'text',name:'elapsed'}
                ],
                center: [
                    {type:'slider',
                     name:'time'}
                ],
                right: [
                    {type:'divider',name:'divider'},
                    {type:'button',name:'hd'},
                    {type:'button',name:'addone'},
                    {type:'divider',name:'divider'},
                    {type:'button',name:'fullscreen'},
                    {type:'divider',name:'divider'},
                    {type:'button',name:'rs-logo'}
                ]
            }
        }

    }

    public function load(url:String = null):void {
    }

    /**
     * Returns the availability of skin elements for a given component.
     *
     * <p>e.g. "controlbar"</p>
     *
     * @param component
     * @return
     *
     */
    public function hasComponent(component:String):Boolean {
        return Boolean(_elements[component] != undefined);
    }

    /**
     *
     * @param component
     * @param element
     * @return
     *
     */
    public function getSkinElement(component:String, element:String):DisplayObject {
        if(!hasComponent(component) || !_elements[component][element]) return null;

        var bmp:Bitmap = new _elements[component][element]() as Bitmap;
        var newSprite:Sprite = new Sprite();
        newSprite.addChild(bmp);
        bmp.name = 'bitmap';

        return newSprite;

    }

    /**
     * Returns a reference to the loaded SWFSkin.
     * @return SWFSkin If the current skin is not a SWF skin, returns null.
     *
     */
    public function getSWFSkin():Sprite {
        return null;
    }

    /**
     * Adds a skin element to the skin
     *
     * @param name
     * @param element
     * @return
     *
     */
    public function addSkinElement(component:String, name:String, element:DisplayObject):void {
    }

    /**
     *
     * @return
     *
     */
    public function getSkinProperties():SkinProperties {
        return _settings;
    }


}
}