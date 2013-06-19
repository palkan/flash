package org.flowplayer.rs.controls {

import com.jeroenwijering.events.ViewEvent;
import com.longtailvideo.jwplayer.events.ViewEvent;
import com.longtailvideo.jwplayer.utils.RootReference;
import com.longtailvideo.jwplayer.view.components.ControlbarComponent;

import flash.events.Event;

import org.flowplayer.model.ClipEvent;
import org.flowplayer.model.Playlist;
import org.flowplayer.model.Plugin;
import org.flowplayer.model.PluginModel;
import org.flowplayer.view.Flowplayer;
import org.flowplayer.view.StyleableSprite;

/**
     * @author anssi
     */
    public class Controls extends StyleableSprite implements Plugin {

        private static const DEFAULT_HEIGHT:Number = 27+13;
    
        private var _config:Object;
        private var _player:Flowplayer;
        private var _pluginModel:PluginModel;

        private var _jwplayer:JWWrapper;

		private var _controlbar:ControlbarComponent;
		
        public function Controls() {
            log.debug("creating ControlBar");
			

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

		public function onConfig(model:PluginModel):void {
            log.info("received my plugin config ", model.config);
            _pluginModel = model;
            log.debug("-");
            _config = model.config;//createConfig(model.config);
            log.debug("config created");
        }


		public function onLoad(player:Flowplayer):void {
			// with older versions of FP we are called twice
			if ( _player )	return;
		
			// log.info("received player API! autohide == " + _config.autoHide.state);
			_player = player;

            _jwplayer = new JWWrapper(_player);

            log.debug("created",width,height);

			_pluginModel.dispatchOnLoad();
		}

		private function onAddedToStage(event:Event):void {

            log.debug("adding to stage: ", width, height);

            new RootReference(this);

            _controlbar = new ControlbarComponent(_jwplayer);

            _jwplayer.controlbar = _controlbar;
            addChild(_controlbar);

			height = DEFAULT_HEIGHT;

            _jwplayer.resize(width, height);


        }


		/**
         * Default properties for the controls.
         */
        public function getDefaultConfig():Object {
            return {};
        }



		
		
		/* Resize stuff */

		override public function onBeforeCss(styleProps:Object = null):void 
		{

		}

        /**
         * @inheritDoc
         */
        override public function css(styleProps:Object = null):Object {

            return {};
        }


        /**
         * @inheritDoc
         */
        override public function animate(styleProps:Object):Object {
            return {};
        }

        /**
         * Rearranges the buttons when size changes.
         */
        override protected function onResize():void {
            if (! _jwplayer) return;
           _jwplayer.resize(width, height);
        }



        
		/* Specific clip controls configuration */

        private function addListeners(playlist:Playlist):void {
            playlist.onBegin(onPlayBegin);
           
            playlist.onStop(onPlayStopped);
            playlist.onBufferStop(onPlayStopped);
            playlist.onFinish(onPlayStopped);
        }

        private function onPlayBegin(event:ClipEvent):void {
            log.debug("onPlayBegin(): received " + event);

        }





      
        private function onPlayStopped(event:ClipEvent):void {
            log.debug("received " + event);

        }


}
}
