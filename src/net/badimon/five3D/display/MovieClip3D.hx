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
import flash.display.FrameLabel;
import flash.display.MovieClip;
import flash.display.Scene;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * The MovieClip3D class is the equivalent in the FIVe3D package of the MovieClip class in the Flash package.
 * 
 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/display/MovieClip.html
 */
class MovieClip3D extends Sprite3D {

	private var __clip:MovieClip;
	private var __clippingRectangle:Rectangle;
	private var __bitmap:Bitmap3D;

	/**
	 * Creates a new MovieClip3D instance.
	 * 
	 * @param clip					The MovieClip object being associated with the MovieClip3D instance.
	 * @param clippingRectangle		A Rectangle object that defines the area of the source object to draw.
	 * @param smoothing			Whether or not the bitmap on which the MovieClip object associated is drawn is smoothed when scaled.
	 */
	public function new(clip:MovieClip, clippingRectangle:Rectangle = null, smoothing:Bool = true) {
		super();
		__clip = clip;
		__clippingRectangle = clippingRectangle;
		createBitmap(smoothing);
	}

	private function createBitmap(smoothing:Bool):Void {
		__bitmap = new Bitmap3D(null, smoothing);
		addChild(__bitmap);
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (from normal "MovieClip" class)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Indicates the number of the frame in which the playhead is located in the timeline of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>currentFrame</code> property.</p>
	 */
	public var _currentFrame(getCurrentFrame, null):Int;

	private function getCurrentFrame():Int {
		return __clip.currentFrame;
	}

	/**
	 * Indicates the label at the current frame in the timeline of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>currentFrameLabel</code> property.</p>
	 */
	public var _currentFrameLabel(getCurrentFrameLabel, null):String;

	private function getCurrentFrameLabel():String {
		return __clip.currentFrameLabel;
	}

	/**
	 * Indicates the current label in which the playhead is located in the timeline of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>currentLabel</code> property.</p>
	 */
	public var _currentLabel(getCurrentLabel, null):String;

	private function getCurrentLabel():String {
		return __clip.currentLabel;
	}

	/**
	 * Indicates an array of FrameLabel objects from the current scene of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>currentLabels</code> property.</p>
	 */
	public var _currentLabels(getCurrentLabels, null):Array<FrameLabel>;

	private function getCurrentLabels():Array<FrameLabel> {
		return __clip.currentLabels;
	}

	/**
	 * Indicates the current scene in which the playhead is located in the timeline of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>currentScene</code> property.</p>
	 */
	public var _currentScene(getCurrentScene, null):Scene;

	private function getCurrentScene():Scene {
		return __clip.currentScene;
	}

	/**
	 * Indicates whether the MovieClip3D instance is enabled.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>enabled</code> property.</p>
	 */
	public var _enabled(getEnabled, setEnabled):Bool;

	private function getEnabled():Bool {
		return __clip.enabled;
	}

	private function setEnabled(value:Bool):Bool {
		__clip.enabled = value;
		return __clip.enabled;
	}

	/**
	 * Indicates the number of frames of the MovieClip3D instance that are loaded from a streaming SWF file.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>framesLoaded</code> property.</p>
	 */
	public var _framesLoaded(getFramesLoaded, null):Int;

	private function getFramesLoaded():Int {
		return __clip.framesLoaded;
	}

	/**
	 * Indicates an array of Scene objects of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>scenes</code> property.</p>
	 */
	public var _scenes(getScenes, null):Array<Scene>;

	private function getScenes():Array<Scene> {
		return __clip.scenes;
	}

	/**
	 * Indicates the total number of frames of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>totalFrames</code> property.</p>
	 */
	public var _totalFrames(getTotalFrames, null):Int;

	private function getTotalFrames():Int {
		return __clip.totalFrames;
	}

	/**
	 * Indicates whether or not other display objects can receive mouse release events.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>trackAsMenu</code> property.</p>
	 */
	public var _trackAsMenu(getTrackAsMenu, setTrackAsMenu):Bool;

	private function getTrackAsMenu():Bool {
		return __clip.trackAsMenu;
	}

	private function setTrackAsMenu(value:Bool):Bool {
		__clip.trackAsMenu = value;
		return __clip.trackAsMenu;
	}

	//----------------------------------------------------------------------------------------------------
	// Methods (from normal "MovieClip" class)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Starts playing the MovieClip3D instance at the specified frame.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>gotoAndPlay</code> property.</p>
	 */
	public function gotoAndPlay(frame:Dynamic, scene:String = null):Void {
		__clip.gotoAndPlay(frame, scene);
	}

	/**
	 * Brings the playhead to the specified frame of the MovieClip3D instance and stops it there.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>gotoAndStop</code> property.</p>
	 */
	public function gotoAndStop(frame:Dynamic, scene:String = null):Void {
		__clip.gotoAndStop(frame, scene);
	}

	/**
	 * Sends the playhead to the next frame of the MovieClip3D instance and stops it there.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>nextFrame</code> property.</p>
	 */
	public function nextFrame():Void {
		__clip.nextFrame();
	}

	/**
	 * Moves the playhead to the next scene of the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>nextScene</code> property.</p>
	 */
	public function nextScene():Void {
		__clip.nextScene();
	}

	/**
	 * Starts playing the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>play</code> property.</p>
	 */
	public function play():Void {
		__clip.play();
	}

	/**
	 * Sends the playhead to the previous frame of the MovieClip3D instance and stops it there.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>prevFrame</code> property.</p>
	 */
	public function prevFrame():Void {
		__clip.prevFrame();
	}

	/**
	 * Moves the playhead to the previous scene of the MovieClip instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>prevScene</code> property.</p>
	 */
	public function prevScene():Void {
		__clip.prevScene();
	}

	/**
	 * Stops playing the MovieClip3D instance.
	 * 
	 * <p>This property has the same behavior than the normal MovieClip <code>stop</code> property.</p>
	 */
	public function stop():Void {
		__clip.stop();
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (new)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Indicates the MovieClip object being associated with the MovieClip3D instance.
	 */
	public var _clip(getClip, setClip):MovieClip;

	private function getClip():MovieClip {
		return __clip;
	}

	private function setClip(value:MovieClip):MovieClip {
		__clip = value;
		return __clip;
	}

	/**
	 * Indicates a Rectangle object that defines the area of the source object to draw.
	 * If null, no clipping occurs and the entire source object is drawn.
	 */
	public var _clippingRectangle(getClippingRectangle, setClippingRectangle):Rectangle;

	private function getClippingRectangle():Rectangle {
		return __clippingRectangle;
	}

	private function setClippingRectangle(value:Rectangle):Rectangle {
		__clippingRectangle = value;
		return __clippingRectangle;
	}

	/**
	 * Whether or not the bitmap on which the MovieClip object associated is drawn is smoothed when scaled.
	 */
	public var _smoothing(getSmoothing, setSmoothing):Bool;

	private function getSmoothing():Bool {
		return __bitmap._smoothing;
	}

	private function setSmoothing(value:Bool):Bool {
		__bitmap._smoothing = value;
		return __bitmap._smoothing;
	}

	//----------------------------------------------------------------------------------------------------
	// Methods (new)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Activate the rendering of the MovieClip3D instance on every frame.
	 * A call to this method is necessary in order to display the content of the MovieClip object associated.
	 * 
	 * @see #deactivate()
	 */
	public function activate():Void {
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function enterFrameHandler(event:Event):Void {
		var bounds:Rectangle = (__clippingRectangle == null) ? __clip.getBounds(__clip) : __clippingRectangle;
		if (bounds.width != 0 && bounds.height != 0) {
			__bitmap._x = bounds.x;
			__bitmap._y = bounds.y;
			var bitmapData:BitmapData = new BitmapData(cast(bounds.width, Int), cast(bounds.height, Int), true, 0x00000000);
			var matrix:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
			bitmapData.draw(__clip, matrix);
			__bitmap._bitmapData = bitmapData;
		}
	}

	/**
	 * Deactivate the rendering of the MovieClip3D instance on every frame.
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
	override public var _childrenSorted(getChildrenSorted, setChildrenSorted):Bool;

	override private function getChildrenSorted():Bool {
		throw "The MovieClip3D class does not implement this property or method.";
		return false;
	}

	override private function setChildrenSorted(value:Bool):Bool {
		throw "The MovieClip3D class does not implement this property or method.";
		return false;
	}
}