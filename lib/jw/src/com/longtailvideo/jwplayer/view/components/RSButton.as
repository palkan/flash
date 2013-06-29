package com.longtailvideo.jwplayer.view.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
    import flash.text.Font;
	
	
	public class RSButton extends MovieClip
	{
		

		private var _back:Sprite;
		private var _label:String;
		private var _txt:TextField;
		
		private const hoffset:int = 8;
		private const voffset:int = 2;
		private const lineHeight:int = 1;
		
		public function RSButton(label:String = "label")
		{
			super();
			
			_label = label;
            var tf:TextFormat = new TextFormat();
            tf.color = 0x9a9a9a;
            tf.kerning = true;
            tf.font = '_sans';
            tf.letterSpacing = -0.7;
            tf.size = 11;
            tf.bold = true;

			_txt = new TextField();
			_txt.selectable = false;
            //_txt.embedFonts = true;
            //_txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
           // _txt.thickness = 100;
           // _txt.sharpness = 100;
			_txt.x = hoffset;// + lineHeight;
			_txt.y = voffset;// + lineHeight;
//			_txt.textHeight = 22;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.mouseEnabled = false;
			_txt.text = '';

			
			_txt.defaultTextFormat = tf;
			
			_txt.text = _label;
			
			this.addChild(_txt);
			
//			_back = new Sprite();
		//	_back.width = _txt.textWidth + 60;
//			_back.height = _txt.height + 48;
			
			this.graphics.lineStyle(lineHeight,0x333333);
			this.graphics.beginFill(0x000000);
			this.graphics.drawRoundRect(0,0,_txt.width +_txt.x+hoffset,_txt.height + _txt.y + voffset,5,5);
			this.graphics.endFill();
			
//			_back.scale9Grid = new Rectangle(3,3,94,94);
			
		//	this.addChildAt(_back,0);
			
		}
		
		
		
	}
}