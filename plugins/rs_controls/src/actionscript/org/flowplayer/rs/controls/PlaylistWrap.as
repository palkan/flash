/**
 * User: palkan
 * Date: 6/4/13
 * Time: 3:16 PM
 */
package org.flowplayer.rs.controls {
import com.longtailvideo.jwplayer.events.GlobalEventDispatcher;
import com.longtailvideo.jwplayer.model.IPlaylist;
import com.longtailvideo.jwplayer.model.PlaylistItem;
import com.longtailvideo.jwplayer.model.PlaylistItem;

import flash.events.EventDispatcher;

import org.flowplayer.model.Playlist;
import org.flowplayer.view.Flowplayer;

public class PlaylistWrap extends GlobalEventDispatcher implements IPlaylist {

    private var _player:Flowplayer;

    public function PlaylistWrap(player:Flowplayer) {

        _player = player;
    }

    public function load(newPlaylist:Object):void{}
    /**
     * Gets a the PlaylistItem at the specified index.
     *
     * @param idx The index of the PlaylistItem to retrieve
     * @return If a PlaylistItem is found at position <code>idx</code>, it is returned.  Otherwise, returns <code>null</code>
     */
    public function getItemAt(idx:Number):PlaylistItem{
        return null;
    }
    /**
     * Inserts a PlaylistItem
     *
     * @param itm
     * @param idx The position in which to place a playlist
     *
     */
    public function insertItem(itm:PlaylistItem, idx:Number = -1):void{}
    /**
     * Removes an item at the requested index
     *
     * @param idx The index from which to remove the item
     */
    public function removeItemAt(idx:Number):void{}
    /**
     * Returns true if the given playlist item is currently loaded in the list.
     **/
    public function contains(item:PlaylistItem):Boolean{ return false;}

    public function get currentIndex():Number{ return 0;}
    public function set currentIndex(idx:Number):void{}
    public function get currentItem():PlaylistItem{ try{ return new PlaylistItem(_player.status.clip)}catch(e:Error){}  return new PlaylistItem();}
    public function get length():Number{ return 1;};
}
}
