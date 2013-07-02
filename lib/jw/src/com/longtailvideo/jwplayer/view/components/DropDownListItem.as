package com.longtailvideo.jwplayer.view.components
{
	import com.longtailvideo.jwplayer.utils.Draw;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DropDownListItem extends MovieClip
	{
		
		/*[Embed(source='../../../../../../assets/fonts/verdana.ttf', 
        	fontName='myMyriadFont', 
			embedAsCFF="false")]
		
		private static var myMyriadFont:Class;
		*/
		
		public var _label:String;
		private var _data:Object;
		
		
		private var rect:Sprite;
		private var text:TextField;
		private var icon:DisplayObject;
		
		private var _xoffset:int=8;
		//private var rtext;
		
		private var ct:ColorTransform;
		private var ct_active:ColorTransform;
		private var tf:TextFormat;
		private var tf_active:TextFormat;
		
		public function DropDownListItem(w:int,h:int,data:Object = null)
		{
			super();
			
	//		this.useHandCursor = true;
//			this.width = w;
	//		this.height = h;
			
			_label = data['label'];
			_data = data;
			
			rect = Draw.rect(this as Sprite,"0x000000",w,h,0,0,1);
			rect.mouseEnabled = false;
		//	var fontIns:VerdanaFont;
		
			
			if(data['icon']!=undefined){
				icon = data['icon'];
				//icon.mouseEnabled = false;
				_xoffset += icon.width;
				
				this.addChild(icon);

			}
			
			
			var _tf:TextFormat = new TextFormat();
			_tf.align = "left";
			_tf.color = "0x9a9a9a";
			_tf.font = "_sans";
			_tf.size = 11;
			
			
			tf_active = new TextFormat();
			tf_active.color = "0xf80000";
			
			tf = new TextFormat();
			tf.color = "0x9a9a9a";
			
			
			text = new TextField();
			text.defaultTextFormat = _tf;
			text.width = w - _xoffset;
			text.text = _label;
			text.height = 20;
			text.x = _xoffset;
			text.y = (h-text.height)/2;
			text.selectable = false;
			text.mouseEnabled = false;
			this.addChild(text);
			
			
			ct = new ColorTransform();
			ct.color = 0x000000;
			
			ct_active = new ColorTransform();
			ct_active.color = 0x303030;

			setupListeners();
		}
		
		
		private function setupListeners():void{
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseHandler);

		}
		
		protected function onMouseHandler(event:MouseEvent):void
		{
			
			if(event.type===MouseEvent.MOUSE_OVER)
				rect.transform.colorTransform = ct_active;
			else if(event.type===MouseEvent.MOUSE_OUT)
				rect.transform.colorTransform = ct;
			
		}
		
		private function removeListeners():void{
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseHandler);

		}
		
		public function setActive(flag:Boolean = true):void{
			
			if(flag)
				text.setTextFormat(tf_active);
			else
				text.setTextFormat(tf);
			
		}
		
		public function get label():String{
			
			return _label;
		}
		
		public function set label(value:String):void{
			
			_label = value;
			text.text = value;
		}

        public function get data():Object {
            return _data;
        }
    }
}