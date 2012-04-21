/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package net.badimon.five3D.display;

#if !flash
 #error
#end

import flash.display.BitmapData;
import flash.events.Event;
import flash.media.Video;
import flash.net.NetStream;
import flash.media.Camera;

/**
 * The Video3D class is the equivalent in the FIVe3D package of the Bitmap class in the Flash package.
 * 
 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/media/Video.html
 */
class Video3D extends Bitmap3D {

	private var __video:Video;

	/**
	 * Creates a new Video3D instance.
	 */
	public function new(width:Int = 320, height:Int = 240) {
		super();
		__video = new Video(width, height);
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (from normal "Video" class)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Indicates the type of filter applied to decode video as part of post-processing.
	 * 
	 * <p>This property has the same behavior than the normal Video <code>deblocking</code> property.</p>
	 */
	public var _deblocking(getDeblocking, setDeblocking):Int;

	private function getDeblocking():Int {
		return __video.deblocking;
	}

	private function setDeblocking(value:Int):Int {
		__video.deblocking = value;
		return __video.deblocking;
	}

	/**
	 * Indicates the width (in pixels) of the video stream.
	 * 
	 * <p>This property has the same behavior than the normal Video <code>videoWidth</code> property.</p>
	 */
	public var _videoWidth(getVideoWidth, null):Int;

	private function getVideoWidth():Int {
		return __video.videoWidth;
	}

	/**
	 * Indicates the height (in pixels) of the video stream.
	 * 
	 * <p>This property has the same behavior than the normal Video <code>videoHeight</code> property.</p>
	 */
	public var _videoHeight(getVideoHeight, null):Int;

	private function getVideoHeight():Int {
		return __video.videoHeight;
	}

	//----------------------------------------------------------------------------------------------------
	// Methods (from normal "Video" class)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Specifies a video stream from a camera to be displayed within the boundaries of the Video3D instance.
	 * 
	 * <p>This property has the same behavior than the normal Video <code>attachCamera</code> property.</p>
	 * 
	 * @param camera		A Camera object that is capturing video data. To drop the connection to the Video object, pass null.
	 * 
	 * @see #activate()
	 * @see #deactivate()
	 */
	public function attachCamera(camera:Camera):Void {
		__video.attachCamera(camera);
	}

	/**
	 * Specifies a video stream to be displayed within the boundaries of the Video3D instance.
	 * 
	 * <p>This property has the same behavior than the normal Video <code>attachNetStream</code> property.</p>
	 * 
	 * @param netstream		A NetStream object. To drop the connection to the Video object, pass null.
	 * 
	 * @see #activate()
	 * @see #deactivate()
	 */
	public function attachNetStream(netstream:NetStream):Void {
		__video.attachNetStream(netstream);
	}

	/**
	 * Clears the image currently displayed in the Video3D instance (not the video stream).
	 * 
	 * <p>This property has the same behavior than the normal Video <code>clear</code> property.</p>
	 */
	public function clear():Void {
		super.setBitmapData(null);
	}

	//----------------------------------------------------------------------------------------------------
	// Methods (new)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Activate the rendering of the video. The video stream input is drawn into the Video3D instance on every frame.
	 * A call to this method is necessary in order to display the video stream previously specified.
	 * 
	 * @see #deactivate()
	 */
	public function activate():Void {
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function enterFrameHandler(event:Event):Void {
		var bitmapData:BitmapData = new BitmapData(Math.ceil(__video.width), Math.ceil(__video.height), false);
		bitmapData.draw(__video);
		super.setBitmapData(bitmapData);
	}

	/**
	 * Deactivate the rendering of the video. The video stream input is not drawn into the Video3D instance on every frame.
	 * 
	 * @see #activate()
	 */
	public function deactivate():Void {
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	//----------------------------------------------------------------------------------------------------
	// Errors
	//----------------------------------------------------------------------------------------------------
	/**
	 * @private
	 */
	//override public var _bitmapData(getBitmapData, setBitmapData):BitmapData;

	override private function getBitmapData():BitmapData {
		throw "The Video3D class does not implement this property or method.";
		return null;
	}

	override private function setBitmapData(value:BitmapData):BitmapData {
		throw "The Video3D class does not implement this property or method.";
		return null;
	}
}