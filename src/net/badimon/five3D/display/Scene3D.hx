/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display;

#if js
import Html5Dom;
#end
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Vector3D;

/**
 * The Scene3D class represents an independent 3D scene in which you can create and manipulate 3D objects.
 * Multiple Scene3D instances can be created in the same SWF file.
 */
class Scene3D extends Sprite {

	private var __viewDistance:Float;
	private var __ambientLightVector:Vector3D;
	private var __ambientLightVectorNormalized:Vector3D;
	private var __ambientLightIntensity:Float;

	/**
	 * Creates a new Scene3D instance.
	 * 
	 * @param autoRender	Whether or not the Scene3D instance is automatically rendered on every frame.
	 */
	public function new(autoRender:Bool = true) {
		super();
		__viewDistance = 1000;
		__ambientLightVector = new Vector3D(1, 1, 1);
		__ambientLightVectorNormalized = new Vector3D(.5773502691896258, .5773502691896258, .5773502691896258);
		__ambientLightIntensity = .5;
		if (autoRender) startRender();
	}

	//----------------------------------------------------------------------------------------------------
	// Properties
	//----------------------------------------------------------------------------------------------------
	/**
	 * The distance between the eye of the viewer and the registration point of the Scene3D instance (the default value is 1000).
	 * This value is used to calculate the perspective transformation. Lower values accentuate the perspective (fisheye effect).
	 * 
	 * <p>This property has the same behavior than the PerspectiveProjection class <code>focalLength</code> property.</p>
	 */
	public var _viewDistance(getViewDistance, setViewDistance):Float;

	private function getViewDistance():Float {
		return __viewDistance;
	}

	private function setViewDistance(value:Float):Float {
		__viewDistance = value;
		askRendering();
		return __viewDistance;
	}

	/**
	 * Indicates the ambient light vector of the Scene3D instance which determinate the lighting direction.
	 * 
	 * @see #ambientLightVectorNormalized
	 */
	public var _ambientLightVector(getAmbientLightVector, setAmbientLightVector):Vector3D;

	private function getAmbientLightVector():Vector3D {
		return __ambientLightVector;
	}

	private function setAmbientLightVector(value:Vector3D):Vector3D {
		__ambientLightVector = value;
		__ambientLightVectorNormalized = __ambientLightVector.clone();
		__ambientLightVectorNormalized.normalize();
		askRenderingShading();
		return __ambientLightVector;
	}

	/**
	 * Indicates the normalized ambient light vector of the Scene3D instance which determinate the lighting direction.
	 * 
	 * @see #ambientLightVector
	 */
	public var _ambientLightVectorNormalized(getAmbientLightVectorNormalized, null):Vector3D;

	private function getAmbientLightVectorNormalized():Vector3D {
		return __ambientLightVectorNormalized;
	}

	/**
	 * Indicates the ambient light intensity.
	 * Lower values represent a lower impact of the lighting settings and higher values a higher impact.
	 */
	public var _ambientLightIntensity(getAmbientLightIntensity, setAmbientLightIntensity):Float;

	private function getAmbientLightIntensity():Float {
		return __ambientLightIntensity;
	}

	private function setAmbientLightIntensity(value:Float):Float {
		__ambientLightIntensity = value;
		askRenderingShading();
		return __ambientLightIntensity;
	}

	//----------------------------------------------------------------------------------------------------
	// Workflow
	//----------------------------------------------------------------------------------------------------
	/**
	 * Start the rendering of the Scene3D instance on every frame.
	 * 
	 * @see #stopRender()
	 */
	public function startRender():Void {
		initializeRendering();
	}

	/**
	 * Stop the rendering of the Scene3D instance on every frame.
	 * 
	 * @see #startRender()
	 */
	public function stopRender():Void {
		desinitializeRendering();
	}

	/**
	 * Renders the Scene3D instance immediately whether or not the scene is automatically rendered on every frame.
	 * 
	 * @see #startRender()
	 * @see #stopRender()
	 */
	public function forceRender():Void {
		render();
	}

	private function initializeRendering():Void {
		addEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);
	}

	private function enterFrameHandler(event:Event):Void {
		render();
	}

	private function render():Void {
		var i:UInt;
		var num:UInt = numChildren;
		for (i in 0...num) cast(getChildAt(i), IObject3D).render(this);
	}

	private function desinitializeRendering():Void {
		removeEventListener(nme.events.Event.ENTER_FRAME, enterFrameHandler);
	}

	private function askRendering():Void {
		var i:UInt;
		var num:UInt = numChildren;
		for (i in 0...num) cast(getChildAt(i), IObject3D).askRendering();
	}

	private function askRenderingShading():Void {
		var i:UInt;
		var num:UInt = numChildren;
		for (i in 0...num) cast(getChildAt(i), IObject3D).askRenderingShading();
	}

	/**
	 * Dispose the Scene3D instance and stop the automatic rendering of the scene on every frame if necessary.
	 */
	public function dispose():Void {
		desinitializeRendering();
	}
}