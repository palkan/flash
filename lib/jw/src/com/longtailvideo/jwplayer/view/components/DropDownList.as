package com.longtailvideo.jwplayer.view.components
{
	import com.longtailvideo.jwplayer.events.ViewEvent;
	import com.longtailvideo.jwplayer.utils.Draw;
	import com.longtailvideo.jwplayer.utils.Logger;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[Event(name="jwplayerViewClick", type="com.longtailvideo.jwplayer.events.ViewEvent")]
	
	
	public class DropDownList extends MovieClip
	{
		
		private var items:Object;
		private var ItemH:int;
		private var ItemW:int;
		private var Type:String;
		
		public function DropDownList()
		{
			super();
		}

		
		public function init(w:int = 45, h:int = 27, type:String = "q"){
			
			ItemW = w;
			ItemH = h;
			Type = type;
			
			items = {numItems:0};
			var rect:Sprite = Draw.rect(this as Sprite,"0x000000",ItemW,1,0,-1,0);
			rect.mouseEnabled = false;
			this.addEventListener(MouseEvent.CLICK,onClickHandler,true);

			
		}
		
		
		protected function onClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
		//	Logger.log(event.target.name,"list");
			var tgt = event.target as DropDownListItem;
			
			if(Type === "q")
				setActive(tgt.label);
			dispatchEvent(new ViewEvent("jwplayerViewClick",{file:tgt.file,label:tgt.label}));
		}
		
		public function addItem(data:Object){
			var item:DropDownListItem = new DropDownListItem(ItemW,ItemH,data);
			items[data['label']] = item;
			items['numItems']++;
			item.x=0;
			item.y=-items['numItems'] * ItemH-1;
			this.addChild(item);
			
		}
		
		public function setActive(label:String):void{
			//Logger.log(items,'items');
			if(items[label]!=undefined){
				(items[label] as DropDownListItem).setActive(true);
				//Logger.log(items,'items');
				for (var pam:String in items){
					Logger.log(pam,"items");
					if(pam!='numItems' && pam!=label)
						(items[pam] as DropDownListItem).setActive(false);
				
				}
			}
			
		}
		
		
	}
}