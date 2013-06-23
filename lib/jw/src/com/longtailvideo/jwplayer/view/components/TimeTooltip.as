/**
 * User: Vladimir
 * Date: 6/23/13
 * Time: 2:10 PM
 */
package com.longtailvideo.jwplayer.view.components {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class TimeTooltip extends Sprite{

    private var _txt:TextField;
    private var _bg:DisplayObject;

    public function TimeTooltip() {

        mouseChildren = mouseEnabled = false;

        _txt = new TextField();

        var tf:TextFormat = new TextFormat("Arial", 10, 0xffffff, false, false);
        tf.align = TextFormatAlign.CENTER;
        _txt.defaultTextFormat = tf;
        _txt.height = 17;
        _txt.multiline = false;
        _txt.selectable = false;
        addChild(_txt);

    }


    public function set background(value:DisplayObject):void{

        _bg = value;

        _bg.x = -_bg.width / 2;

        _txt.width = _bg.width;
        _txt.height = 17;
        _txt.x = _bg.x;
        _txt.y = _bg.y;

        addChildAt(_bg,0);
    }

    public function set text(value:String):void{

        _txt.text = value;

    }
}
}
