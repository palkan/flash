package com.longtailvideo.jwplayer.view.components
{
import com.longtailvideo.jwplayer.utils.AssetLoader;
import com.longtailvideo.jwplayer.utils.Draw;
import com.longtailvideo.jwplayer.utils.Logger;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

public class RelatedVideo extends MovieClip
	{
		
		public var wid:int = 166;
		public var hei:int = 113;
		private var captionHeight:int = 19;
		private var titleY:int = 64;
				
		public var url:String="";
		
		private var image_holder:MovieClip;
		private var title_holder:Sprite;
		
		private var _mask:MovieClip;
		
		public function RelatedVideo()
		{
			super();

		}
	
		
		public function init(image_url:String = "",duration:String = "", title:String = "",url:String = ""):void{

			this.url = url;
			
			_mask = new MovieClip();
			//image_holder.width = wid;
			//image_holder.height = hei;
			_mask.mouseEnabled = false;
			//_mask.width = wid;
            //_mask.height = hei;
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0,0,wid,hei);
			_mask.graphics.endFill();
			

            //mouseEnabled = false;
			
			
			image_holder = new MovieClip();
			//image_holder.width = wid;
			//image_holder.height = hei;
			image_holder.mouseEnabled = false;
			
			image_holder.graphics.beginFill(0x000000);
			image_holder.graphics.drawRect(0,0,wid,hei);
			image_holder.graphics.endFill();

			image_holder.mask = _mask;			
			this.addChild(image_holder);
			this.addChild(_mask);
			
			
			
			
			if(image_url!=""){
				var loader:AssetLoader = new AssetLoader();
				loader.addEventListener(Event.COMPLETE,onImageLoaded);
				loader.addEventListener(ErrorEvent.ERROR,onError);
				loader.load(image_url);
				
				Logger.log(image_url,"rel url");
				
				
			}
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFFFFFF;
			tf.font = "Arial";
			tf.size = 11;
			tf.bold = true;
			
			
			
			var t_txt:TextField = new TextField();
			t_txt.width = wid - 6;
			t_txt.x = 3;
			t_txt.y = titleY;
			t_txt.wordWrap = true;
			t_txt.multiline = true;
			t_txt.defaultTextFormat = tf;
			t_txt.selectable = false;
			t_txt.mouseEnabled = false;
			t_txt.text = title;
			t_txt.height = hei - titleY;
			this.addChild(t_txt);
			
			
			title_holder = Draw.rect(this as Sprite,"0x000000",wid,captionHeight,0,0,1);
			title_holder.y = hei - captionHeight;
			title_holder.mouseEnabled = false;
			
			
			var tf2:TextFormat = new TextFormat();
			tf2.align = "right";
			tf2.color = 0xFFFFFF;
			tf2.font = "Arial";
			tf2.size = 11;
			tf2.bold = true;
			
			
			
			var d_txt:TextField = new TextField();
			d_txt.width = wid-3;
			d_txt.defaultTextFormat = tf2;
			d_txt.selectable = false;
			d_txt.text = duration;
			d_txt.mouseEnabled = false;
            d_txt.height = 22;
            title_holder.addChild(d_txt);
		}
		
		protected function onError(event:ErrorEvent):void
		{
			Logger.log(event.errorID,"rel error");
		}
		
		protected function onImageLoaded(event:Event):void
		{
			var loader:AssetLoader = event.target as AssetLoader;
			var loadedSource = loader.loadedObject;// as MediaProvider;
			if (loadedSource){
				
				posImage(loadedSource);
				
				
				
			}else{
				Logger.log("loader failed","related");
			}
			
		}		
		
		private function posImage(loadedSource:DisplayObject):void
		{

			if(loadedSource.width > wid || loadedSource.height > hei){
				
				//var k = loadedSource.width / loadedSource.height;
				var _scale;
				//if(k > wid/hei){
					_scale = wid/loadedSource.width;
				//}else{
					//_scale = hei/loadedSource.height;
				//}
				
				loadedSource.scaleX = _scale;
				loadedSource.scaleY = _scale;
					
			}
			
			
			loadedSource.x = (wid - loadedSource.width)/2;
			loadedSource.y = (hei - loadedSource.height)/2;
			
			


			image_holder.addChild(loadedSource);
			
		}
		
	}
}