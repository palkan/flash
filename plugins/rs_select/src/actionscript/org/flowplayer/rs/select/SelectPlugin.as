package org.flowplayer.rs.select {
import com.longtailvideo.jwplayer.events.ViewEvent;
import com.longtailvideo.jwplayer.utils.Logger;
import com.longtailvideo.jwplayer.view.components.ControlbarComponent;
import com.longtailvideo.jwplayer.view.components.DropDownList;
import com.longtailvideo.jwplayer.view.components.DropDownListItem;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import org.flowplayer.model.Plugin;
import org.flowplayer.model.PluginModel;
import org.flowplayer.view.Flowplayer;

public class SelectPlugin extends Sprite implements Plugin {

    private var _config:Object;
    private var _player:Flowplayer;
    private var _pluginModel:PluginModel;


    private var _controls:ControlbarComponent;


    private var _list:DropDownList;
    private var _button:MovieClip;

    private var _enabled:Boolean = false;

    private var _icon:DropDownListItem;
    private var _items:Array;

    private var _callbacks:Dictionary = new Dictionary(true);


    public function onConfig(model:PluginModel):void {
        _pluginModel = model;
        _config = model.config;//createConfig(model.config);

        _items = [];

        _list = new DropDownList();

        _list = new DropDownList();
        _list.init();
        _list.visible = false;

        _list.addEventListener(ViewEvent.JWPLAYER_VIEW_CLICK, onListClick);
        _list.addEventListener(MouseEvent.MOUSE_OVER, onMouseHandler);
        _list.addEventListener(MouseEvent.MOUSE_OUT, onMouseHandler);
        _list.y = 0;
    }


    public function onLoad(player:Flowplayer):void {
        _player = player;

        Logger.log("Select is here!");

        var controls:Object = lookupControls();

        Logger.log(
                controls, 'Controls'
        );

        controls && controls['wait'](setControls);

        _pluginModel.dispatchOnLoad();
    }

    private function lookupControls():Object {
        var model:PluginModel = _player.pluginRegistry.getPlugin(_config.controlsName) as PluginModel;
        if (!model) {
            Logger.log("cannot find controls: "+_config.controlsName);
            return null;
        }
        return model.pluginObject;
    }

    /**
     * Default properties for the controls.
     */
    public function getDefaultConfig():Object {
        return {};
    }

    public function addItem(obj:Object, isDefault:Boolean = false):void {
        _callbacks[_list.addItem(obj)] = obj.selectedCallback;
        Logger.log(obj.label, 'select item');
        isDefault && (_icon = new DropDownListItem(45, 27, obj));
    }

    public function selectItemInGroup(item:String, group:String = ''):void {
        _list.setActive(item);
    }

    public function enableItems(flag:Boolean, items:Array):void {

    }

    public function removeItems(items:Array, flag:Boolean = false):void {

    }

    protected function onMouseHandler(event:MouseEvent):void {
        const flag:Boolean = (event.type === MouseEvent.MOUSE_OVER);
        flag && (_list.x = _button.x);
        _list.visible = flag;
    }

    protected function onListClick(event:ViewEvent):void {
        _icon.label = event.data['label'];

        _callbacks[event.target] && _callbacks[event.target](event.data['bitrateItem']);
    }

    public function set enabled(value:Boolean):void {

        Logger.log('enable: ' + value, 'select enable');

        _enabled = value;

        if (!_controls) return;

        if (value) {

            _icon && _controls.addButton(_icon, 'hd', null);

            _button = _controls.getButton('hd') as MovieClip;

            _button && _button.addEventListener(MouseEvent.MOUSE_OVER, onMouseHandler);
            _button && _button.addEventListener(MouseEvent.MOUSE_OUT, onMouseHandler);

        } else {
            _controls.removeButton('hd');

            _button && _button.removeEventListener(MouseEvent.MOUSE_OVER, onMouseHandler);
            _button && _button.removeEventListener(MouseEvent.MOUSE_OUT, onMouseHandler);

        }
    }

    public function get length():int {
        return _list.length;
    }

    public function setControls(value:ControlbarComponent):void {
        _controls = value;

        _controls && _controls.addChild(_list);
        _controls && (enabled = true);

    }
}
}
