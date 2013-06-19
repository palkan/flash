/**
 * User: palkan
 * Date: 6/4/13
 * Time: 8:37 AM
 */
package org.flowplayer.rs.controls {
import com.longtailvideo.jwplayer.events.GlobalEventDispatcher;
import com.longtailvideo.jwplayer.events.IGlobalEventDispatcher;
import com.longtailvideo.jwplayer.events.MediaEvent;
import com.longtailvideo.jwplayer.events.PlayerStateEvent;
import com.longtailvideo.jwplayer.events.PlaylistEvent;
import com.longtailvideo.jwplayer.events.ViewEvent;
import com.longtailvideo.jwplayer.model.IInstreamOptions;
import com.longtailvideo.jwplayer.model.IPlaylist;
import com.longtailvideo.jwplayer.model.PlayerConfig;
import com.longtailvideo.jwplayer.model.PlaylistItem;
import com.longtailvideo.jwplayer.player.IInstreamPlayer;
import com.longtailvideo.jwplayer.player.IPlayer;
import com.longtailvideo.jwplayer.player.PlayerState;
import com.longtailvideo.jwplayer.plugins.IPlugin;
import com.longtailvideo.jwplayer.plugins.PluginConfig;
import com.longtailvideo.jwplayer.utils.Logger;
import com.longtailvideo.jwplayer.view.IPlayerComponents;
import com.longtailvideo.jwplayer.view.components.ControlbarComponent;
import com.longtailvideo.jwplayer.view.interfaces.IPlayerComponent;
import com.longtailvideo.jwplayer.view.interfaces.ISkin;

import flash.display.DisplayObject;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import flash.utils.Timer;

import mx.effects.effectClasses.ZoomInstance;

import org.flowplayer.model.Clip;
import org.flowplayer.model.ClipEvent;
import org.flowplayer.model.ClipEventType;
import org.flowplayer.model.PlayerEvent;
import org.flowplayer.model.PlayerEventType;
import org.flowplayer.model.State;
import org.flowplayer.view.Flowplayer;

[Event(type="com.longtailvideo.jwplayer.events.PlayerStateEvent", name="jwplayerPlayerState")]

[Event(type="com.longtailvideo.jwplayer.events.PlaylistEvent", name="jwplayerPlaylistLoaded")]

[Event(type="com.longtailvideo.jwplayer.events.PlaylistEvent", name="jwplayerPlaylistUpdated")]

[Event(type="com.longtailvideo.jwplayer.events.PlaylistEvent", name="jwplayerPlaylistItem")]

[Event(type="com.longtailvideo.jwplayer.events.MediaEvent", name="jwplayerMediaMute")]
[Event(type="com.longtailvideo.jwplayer.events.MediaEvent", name="jwplayerMediaVolume")]
[Event(type="com.longtailvideo.jwplayer.events.MediaEvent", name="jwplayerMediaBuffer")]
[Event(type="com.longtailvideo.jwplayer.events.MediaEvent", name="jwplayerMediaTime")]

public class JWWrapper extends Sprite implements IPlayer, IGlobalEventDispatcher{

    private var _config:PlayerConfig;
    private var _skin:ISkin;
    private var _player:Flowplayer;

    private var _currentClip:Clip;

    private var _timeUpdateTimer:Timer;
    private var _updateBuffer:Boolean = false;
    private var _updateTime:Boolean = true;

    private var _dispatcher:GlobalEventDispatcher;

    private var _controlbar:ControlbarComponent;

    /** RussiaSport button tooltip **/

    private var _tooltip:DisplayObject;

    /** RussiaSport logo button **/

    private var _logoButton:DisplayObject;

    public function JWWrapper(player:Flowplayer, config:Object = null) {



        _player = player;

        _dispatcher = new GlobalEventDispatcher();

        _skin = new ControlsSkin();

        _config = new PlayerConfig();

        _config.setConfig({
            backcolor:"0x000000",
            lightcolor:"0xffffff",
            screencolor:"0x000000"
        });
        _config.debug = 'console';
        _config.controlbar = "over";
        _config.volume = _player.volume;

        if(!config){

            config = {
                margin:0,
                fontsize:11,
                fontcolor:"0xffffff",
                position:"over",
                rs_url:"http://russiasport.ru/"

            };
        }

        var pluginConfig:PluginConfig = new PluginConfig('controlbar',config);


        _config.setPluginConfig('controlbar',pluginConfig);

        Logger.setConfig(_config);

        _player.playlist.onBeforeBegin(function(e:ClipEvent){  Logger.log('begin'); _currentClip = _player.currentClip; dispatchEvent(new PlaylistEvent(PlaylistEvent.JWPLAYER_PLAYLIST_LOADED,playlist)); _currentClip.onAll(onClipEvent)});

        _player.onVolume(function(e:PlayerEvent):void{
            _config.volume = e.info as Number;
            dispatchEvent(new MediaEvent(MediaEvent.JWPLAYER_MEDIA_VOLUME));
        })

        _player.onMute(onMuteEvent);
        _player.onUnmute(onMuteEvent);


        _timeUpdateTimer = new Timer(100);
        _timeUpdateTimer.addEventListener(TimerEvent.TIMER, onTimeUpdate);

    }

    protected function onMuteEvent(e:PlayerEvent):void{

        _config.mute = e.eventType === PlayerEventType.MUTE;
        dispatchEvent(new MediaEvent(MediaEvent.JWPLAYER_MEDIA_MUTE));

    }

    protected function onTimeUpdate(e:TimerEvent):void{

        if(!_updateTime && !_updateBuffer){
            stopTimer();
            return;
        }

        var b_event:MediaEvent = new MediaEvent(MediaEvent.JWPLAYER_MEDIA_TIME);
            b_event.bufferPercent = _player.status.bufferEnd - _player.status.bufferStart;
            b_event.offset = _player.status.bufferStart;
            Logger.log(b_event.bufferPercent+' - '+b_event.offset,'buffer_start_end');

            b_event.duration = _player.status.clip.live && _player.status.clip.duration == 0 ? -1 : _player.status.clip.duration;
            b_event.position = _player.status.time;

        dispatchEvent(b_event);
    }


    protected function startTimer():void{
        !_timeUpdateTimer.running && _timeUpdateTimer.start();
    }

    protected function stopTimer():void{
        _timeUpdateTimer.running && _timeUpdateTimer.stop();
    }

    protected function onClipEvent(e:ClipEvent):void{

        switch(e.eventType){

            case ClipEventType.PAUSE:
                _updateTime = false;
                dispatchEvent(new PlayerStateEvent(PlayerStateEvent.JWPLAYER_PLAYER_STATE,state,null));
                break;
            case ClipEventType.START:
            case ClipEventType.PLAY_STATUS:
            case ClipEventType.BUFFER_FULL:
                _updateTime = true;
                startTimer();
                dispatchEvent(new PlayerStateEvent(PlayerStateEvent.JWPLAYER_PLAYER_STATE,state,null));
                break;
            case ClipEventType.RESUME:
                _updateTime = true;
                startTimer();
                dispatchEvent(new PlayerStateEvent(PlayerStateEvent.JWPLAYER_PLAYER_STATE,state,null));
                break;
            case ClipEventType.FINISH:
                stopTimer();
                break;
            case ClipEventType.BEGIN:
                startTimer();
                dispatchEvent(new PlayerStateEvent(PlayerStateEvent.JWPLAYER_PLAYER_STATE,state,null));
                break;
            case ClipEventType.BUFFER_STOP:
                _updateBuffer = false;
                break;

        }

    }


    public function set controlbar(value:ControlbarComponent):void{
        _controlbar = value;
        _controlbar.addEventListener(ViewEvent.JWPLAYER_VIEW_MUTE, muteHandler);
        _controlbar.addEventListener(ViewEvent.JWPLAYER_VIEW_PLAY, playHandler);
        _controlbar.addEventListener(ViewEvent.JWPLAYER_VIEW_PAUSE,playHandler);
        _controlbar.addEventListener(ViewEvent.JWPLAYER_VIEW_SEEK, seekHandler);
        _controlbar.addEventListener(ViewEvent.JWPLAYER_VIEW_FULLSCREEN, fullscreenHanlder);
        _controlbar.addEventListener(ViewEvent.JWPLAYER_VIEW_VOLUME,volumeHandler);
        addCustomButtons();
    }


    private function playHandler(e:ViewEvent):void {
        if(e.type == ViewEvent.JWPLAYER_VIEW_PLAY)
            _player.play();
        else
            _player.pause();
    }

    private function muteHandler(e:ViewEvent):void {
        _config.mute = e.data;
        _player.muted = e.data;
    }

    private function volumeHandler(e:ViewEvent):void {
        _config.volume = e.data;
        _player.volume = e.data;
    }

    private function seekHandler(e:ViewEvent):void {

        Logger.log(e.data,'seek');
        _player.seekRelative(e.data);

    }

    private function fullscreenHanlder(e:ViewEvent):void {

        _config.fullscreen = e.data;

        _player.toggleFullscreen();

    }

    protected function addCustomButtons():void{
        addRussiaSportButton();
        // hd button
        // plus one button
    }

    protected function addRussiaSportButton():void{

         _logoButton  = _skin.getSkinElement("controlbar", "russiasportButton");

        _controlbar.addButton(_logoButton, "rs-logo", onSportClick);

        _logoButton = _controlbar.getButton("rs-logo");

        _logoButton.addEventListener(MouseEvent.MOUSE_OVER,onLogoOver);
        _logoButton.addEventListener(MouseEvent.MOUSE_OUT,onLogoOut);


        _tooltip  = _skin.getSkinElement("controlbar", "russiasportTooltip");
        _tooltip.visible = false;
        _tooltip.y = _logoButton.y - _tooltip.height+4;
        _tooltip.addEventListener(MouseEvent.MOUSE_OVER,onLogoOver);
        _tooltip.addEventListener(MouseEvent.MOUSE_OUT,onLogoOut);
        _tooltip.addEventListener(MouseEvent.CLICK,onSportClick);
        _controlbar.addChild(_tooltip);


        function onLogoOut(event:Event):void
        {
            _tooltip.visible = false;
        }

        function onLogoOver(event:Event):void
        {
            _controlbar.setChildIndex(_tooltip,_controlbar.numChildren-1);

            _tooltip.visible = true;
        }


        function onSportClick(event:MouseEvent):void
        {
            if(_config.pluginConfig('controlbar')['rs_url'])
                navigateToURL(new URLRequest(_config.pluginConfig('controlbar')['rs_url']));
        }

    }


    public function resize(w:Number,h:Number):void{
        _controlbar && _controlbar.resize(w,h);

        _tooltip.x = _logoButton.x - 45;
    }

    /**
     * The player's current configuration
     */
    public function get config():PlayerConfig{
      return _config;
    }
    /**
     * Player version getter
     */
    public function get version():String{
        return "5.0.0";
    }
    /**
     * Reference to player's skin.  If no skin has been loaded, returns null.
     */
    public function get skin():ISkin{
      return _skin;
    }
    /**
     * The current player state
     */
    public function get state():String{

        if(_player.state == State.PAUSED) return PlayerState.PAUSED;

        if(_player.state == State.PLAYING) return PlayerState.PLAYING;

        if(_player.state == State.BUFFERING) return PlayerState.BUFFERING;

        return PlayerState.IDLE;

    }
    /**
     * The player's playlist
     */
    public function get playlist():IPlaylist{
        return new PlaylistWrap(_player);
    }
    /**
     * Set to true when the player is in a locked state.
     */
    public function get locked():Boolean{
        return false;
    }
    /**
     * Request that the player enter the locked state.  When the Player is locked, the currently playing stream is
     * paused, and no new playback-related commands will be honored until <code>unlock</code> is
     * called.
     *
     * @param target Reference to plugin requesting the player lock
     * @param callback The function to be executed once a lock is aquired.
     */
    public function lock(target:IPlugin, callback:Function):void{
        //do nothing
    }
    /**
     * Unlocks the player.  If the player was buffering or playing when it was locked, playback will resume.
     *
     * @param target Reference to the requesting plugin.
     * @return <code>true</code>, if <code>target</code> had previously requested player locking.
     *
     */
    public function unlock(target:IPlugin):Boolean{
        return false;
    }
    public function volume(volume:Number):Boolean{


        return true;
    }

    public function mute(state:Boolean):void{



    }
    public function play():Boolean{

        return true;
    }
    public function pause():Boolean{

        return true;
    }
    public function stop():Boolean{

        return true;
    }
    public function seek(position:Number):Boolean{

        return true;
    }
    public function load(item:*):Boolean{

        return true;
    }
    public function playlistItem(index:Number):Boolean{
        return true;
    }
    public function playlistNext():Boolean{
        return true;
    }
    public function playlistPrev():Boolean{
        return true;
    }
    /** Force a redraw of the player **/
    public function redraw():Boolean{
        return true;
    }
    public function fullscreen(on:Boolean):void{
    }
    public function get controls():IPlayerComponents{
        return null;
    }
    public function overrideComponent(plugin:IPlayerComponent):void{
    }
    public function loadInstream(target:IPlugin, item:PlaylistItem, options:IInstreamOptions=null):IInstreamPlayer{
        return null;
    }

    /**
     * @inheritDoc
     */
    public function addGlobalListener(listener:Function):void {
        _dispatcher.addGlobalListener(listener);
    }


    /**
     * @inheritDoc
     */
    public function removeGlobalListener(listener:Function):void {
        _dispatcher.removeGlobalListener(listener);
    }


    /**
     * @inheritDoc
     */
    public override function dispatchEvent(event:Event):Boolean {
        _dispatcher.dispatchEvent(event);
     //   Logger.log(event.toString(),event.type);
        return super.dispatchEvent(event);
    }

}
}
