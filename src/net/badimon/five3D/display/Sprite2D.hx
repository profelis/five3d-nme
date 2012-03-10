/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display;

import net.badimon.five3D.utils.InternalUtils;

import flash.display.Sprite;
import flash.geom.Matrix3D;

#if js
import Html5Dom;
#else
import flash.Vector;
#end

/**
 * The Sprite2D class is the equivalent in the FIVe3D package of the Sprite class in the Flash package but contrary to the Sprite3D class, the Sprite2D class always faces the screen.
 * 
 * @see Sprite3D
 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/display/Sprite.html
 */
class Sprite2D extends Sprite, implements IObject3D {

	private var __visible:Bool;
	private var __x:Float;
	private var __y:Float;
	private var __z:Float;
	private var __scaleX:Float;
	private var __scaleY:Float;
	private var __matrix:Matrix3D;
	private var __concatenatedMatrix:Matrix3D;
	private var __scaled:Bool;
	private var __render:Bool;
	private var __renderScaling:Bool;
	private var __scaling:Bool;
	// Calculation
	private var __vectorIn:Vector<Float>;
	private var __vectorOut:Vector<Float>;
	private var __perspective:Float;

	/**
	 * Creates a new Sprite2D instance.
	 */
	public function new() {
		super();
		__visible = true;
		__x = 0;
		__y = 0;
		__z = 0;
		__scaleX = 1;
		__scaleY = 1;
		__matrix = new Matrix3D();
		__concatenatedMatrix = new Matrix3D();
		__scaled = true;
		__render = true;
		__renderScaling = true;
		__scaling = false;
		initVectors();
	}

	private function initVectors():Void {
		__vectorIn = new Vector<Float>(#if flash 3 #end);
		__vectorOut = new Vector<Float>(#if flash 3 #end);
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (from normal "Sprite" class)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Whether or not the Sprite2D instance is visible. When the Sprite2D instance is not visible, 3D calculation and rendering are not executed.
	 * Any change of this property takes effect the next time the instance is being rendered.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>visible</code> property.</p>
	 */
	public var _visible(getVisible, setVisible):Bool;

	private function getVisible():Bool {
		return __visible;
	}

	private function setVisible(value:Bool):Bool {
		__visible = value;
		return __visible;
	}

	/**
	 * Indicates the x coordinate along the x-axis of the Sprite2D instance relative to the local coordinate system of the 3D parent container.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>x</code> property.</p>
	 */
	public var _x(getX, setX):Float;

	private function getX():Float {
		return __x;
	}

	private function setX(value:Float):Float {
		__x = value;
		askRendering();
		return __x;
	}

	/**
	 * Indicates the y coordinate along the y-axis of the Sprite2D instance relative to the local coordinate system of the 3D parent container.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>y</code> property.</p>
	 */
	public var _y(getY, setY):Float;

	private function getY():Float {
		return __y;
	}

	private function setY(value:Float):Float {
		__y = value;
		askRendering();
		return __y;
	}

	/**
	 * Indicates the z coordinate along the z-axis of the Sprite2D instance relative to the local coordinate system of the 3D parent container.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>z</code> property.</p>
	 */
	public var _z(getZ, setZ):Float;

	private function getZ():Float {
		return __z;
	}

	private function setZ(value:Float):Float {
		__z = value;
		askRendering();
		return __z;
	}

	/**
	 * Indicates the x-axis scale (percentage) of the Sprite2D instance from its registration point relative or not to the local coordinate system of the 3D parent container depending on the <code>scaled</code> property setting.
	 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>scaleX</code> property.</p>
	 * 
	 * @see #scaled
	 */
	public var _scaleX(getScaleX, setScaleX):Float;

	private function getScaleX():Float {
		return __scaleX;
	}

	private function setScaleX(value:Float):Float {
		__scaleX = value;
		if (__scaled) __renderScaling = true;
		else scaleX = __scaleX;
		return __scaleX;
	}

	/**
	 * Indicates the y-axis scale (percentage) of the Sprite2D instance from its registration point relative or not to the local coordinate system of the 3D parent container depending on the <code>scaled</code> property setting.
	 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>scaleY</code> property.</p>
	 * 
	 * @see #scaled
	 */
	public var _scaleY(getScaleY, setScaleY):Float;

	private function getScaleY():Float {
		return __scaleY;
	}

	private function setScaleY(value:Float):Float {
		__scaleY = value;
		if (__scaled) __renderScaling = true;
		else scaleY = __scaleY;
		return __scaleY;
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (new)
	//----------------------------------------------------------------------------------------------------
	/**
	 * A Matrix3D object representing the combined transformation matrixes of the Sprite2D instance and all of its parent 3D objects, back to the scene level.
	 */
	public var _concatenatedMatrix(getConcatenatedMatrix, null):Matrix3D;

	private function getConcatenatedMatrix():Matrix3D {
		return __concatenatedMatrix;
	}

	/**
	 * Wether or not the Sprite2D instance scale is being affected by its depth in the 3D scene independently from the <code>scaleX</code> and <code>scaleY</code> properties.
	 */
	public var _scaled(getScaled, setScaled):Bool;

	private function getScaled():Bool {
		return __scaled;
	}

	private function setScaled(value:Bool):Bool {
		__scaled = value;
		if (__scaled) {
			__renderScaling = true;
		} else {
			__renderScaling = false;
			if (__scaling) removeScaling();
		}
		return __scaled;
	}

	//----------------------------------------------------------------------------------------------------
	// Workflow
	//----------------------------------------------------------------------------------------------------
	/**
	 * @private
	 */
	public function askRendering():Void {
		__render = true;
		if (__scaled) __renderScaling = true;
	}

	/**
	 * @private
	 */
	public function askRenderingShading():Void {
	}

	/**
	 * @private
	 */
	public function render(scene:Scene3D):Void {
		if (!__visible && visible) visible = false;
		else if (__visible) {
			if (!visible) visible = true;
			if (__render) {
				var viewDistance:Float = scene._viewDistance;
				InternalUtils.setMatrixPosition(__matrix, __x, __y, __z);
				InternalUtils.setConcatenatedMatrix(__concatenatedMatrix, parent, __matrix);
				__concatenatedMatrix.transformVectors(__vectorIn, __vectorOut);
				__perspective = viewDistance / (__vectorOut[2] + viewDistance);
				setPlacement();
				__render = false;
			}
			if (__renderScaling) {
				applyScaling();
				__renderScaling = false;
			}
		}
	}

	private function setPlacement():Void {
		x = __vectorOut[0] * __perspective;
		y = __vectorOut[1] * __perspective;
	}

	private function applyScaling():Void {
		scaleX = __scaleX * __perspective;
		scaleY = __scaleY * __perspective;
		__scaling = true;
	}

	private function removeScaling():Void {
		scaleX = __scaleX;
		scaleY = __scaleY;
		__scaling = false;
	}
}