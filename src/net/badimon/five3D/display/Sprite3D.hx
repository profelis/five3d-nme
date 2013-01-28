/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display;

import net.badimon.five3D.utils.InternalUtils;

import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;

#if js
import browser.Html5Dom;
#else
import flash.Vector;
#end

/**
 * The Sprite3D class is the equivalent in the FIVe3D package of the Sprite class in the Flash package.
 * 
 * @see Sprite2D
 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/display/Sprite.html
 */
class Sprite3D extends Sprite, implements IObject3D {

	private var __visible:Bool;
	private var __x:Float;
	private var __y:Float;
	private var __z:Float;
	private var __scaleX:Float;
	private var __scaleY:Float;
	private var __scaleZ:Float;
	private var __rotationX:Float;
	private var __rotationY:Float;
	private var __rotationZ:Float;
	private var __matrix:Matrix3D;
	private var __concatenatedMatrix:Matrix3D;
	private var __graphics:Graphics3D;
	private var __singleSided:Bool;
	private var __flatShaded:Bool;
	private var __childrenSorted:Bool;
	private var __render:Bool;
	private var __renderCulling:Bool;
	private var __renderShading:Bool;
	private var __flatShading:Bool;
	// Calculation
	private var __isMatrixDirty:Bool;
	private var __autoUpdatePropertiesOnMatrixChange:Bool;
	private var __vectorIn:Vector<Float>;
	private var __vectorOut:Vector<Float>;
	private var __normalVector:Vector3D;
	private var __normalVectorCalculated:Bool;
	private var __cameraVector:Vector3D;
	private var __culling:Bool;

	/**
	 * Creates a new Sprite3D instance.
	 */
	public function new() {
		super();
		__visible = true;
		__x = 0;
		__y = 0;
		__z = 0;
		__scaleX = 1;
		__scaleY = 1;
		__scaleZ = 1;
		__rotationX = 0;
		__rotationY = 0;
		__rotationZ = 0;
		__matrix = new Matrix3D();
		__concatenatedMatrix = new Matrix3D();
		__graphics = new Graphics3D();
		__singleSided = false;
		__flatShaded = false;
		__childrenSorted = false;
		__render = true;
		__renderCulling = false;
		__renderShading = false;
		__flatShading = false;
		__isMatrixDirty = true;
		__autoUpdatePropertiesOnMatrixChange = false;
		__normalVector = new Vector3D();
		__normalVectorCalculated = false;
		__cameraVector = new Vector3D();
		__culling = false;
		initVectors();
	}

	private function initVectors():Void {
		__vectorIn = new Vector<Float>(#if flash 6 #end);
		__vectorIn[5] = 1;
		__vectorOut = new Vector<Float>(#if flash 6 #end);
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (from normal "Sprite" class)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Whether or not the Sprite3D instance is visible. When the Sprite3D instance is not visible, 3D calculation and rendering are not executed.
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
	 * Indicates the x coordinate (in pixels) of the mouse position on the 3D plane defined by the Sprite3D instance.
	 * 
	 * <p>This property calculation is intensive and requires the same matrix transformations than the <code>mouseY</code> property calculation.
	 * Therefore using <code>mouseXY</code> is faster than <code>mouseX</code> and <code>mouseY</code> separately.</p>
	 * 
	 * @see #mouseXY
	 */
	public var _mouseX(getMouseX, null):Float;

	private function getMouseX():Float {
		var scene:Scene3D = InternalUtils.getScene(this);
		if (scene == null) {
			return Math.NaN;
		} else {
			return InternalUtils.getInverseCoordinates(__concatenatedMatrix, scene.mouseX, scene.mouseY, scene._viewDistance).x;
		}
	}

	/**
	 * Indicates the y coordinate (in pixels) of the mouse position on the 3D plane defined by the Sprite3D instance.
	 * 
	 * <p>This property calculation is intensive and requires the same matrix transformations than the <code>mouseY</code> property calculation.
	 * Therefore using <code>mouseXY</code> is faster than <code>mouseX</code> and <code>mouseY</code> separately.</p>
	 * 
	 * @see #mouseXY
	 */
	public var _mouseY(getMouseY, null):Float;

	private function getMouseY():Float {
		var scene:Scene3D = InternalUtils.getScene(this);
		if (scene == null) {
			return Math.NaN;
		} else {
			return InternalUtils.getInverseCoordinates(__concatenatedMatrix, scene.mouseX, scene.mouseY, scene._viewDistance).y;
		}
	}

	/**
	 * Indicates the x and y coordinates (in pixels) of the mouse position on the 3D plane defined by the Sprite3D instance.
	 */
	public var _mouseXY(getMouseXY, null):Point;

	private function getMouseXY():Point {
		var scene:Scene3D = InternalUtils.getScene(this);
		if (scene == null) {
			return null;
		} else {
			return InternalUtils.getInverseCoordinates(__concatenatedMatrix, scene.mouseX, scene.mouseY, scene._viewDistance);
		}
	}

	/**
	 * Indicates the x coordinate along the x-axis of the Sprite3D instance relative to the local coordinate system of the 3D parent container.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>x</code> property.</p>
	 */
	public var _x(getX, setX):Float;

	private function getX():Float {
		return __x;
	}

	private function setX(value:Float):Float {
		__x = value;
		__isMatrixDirty = true;
		askRendering();
		return __x;
	}

	/**
	 * Indicates the y coordinate along the y-axis of the Sprite3D instance relative to the local coordinate system of the 3D parent container.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>y</code> property.</p>
	 */
	public var _y(getY, setY):Float;

	private function getY():Float {
		return __y;
	}

	private function setY(value:Float):Float {
		__y = value;
		__isMatrixDirty = true;
		askRendering();
		return __y;
	}

	/**
	 * Indicates the z coordinate along the z-axis of the Sprite3D instance relative to the local coordinate system of the 3D parent container.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>z</code> property.</p>
	 */
	public var _z(getZ, setZ):Float;

	private function getZ():Float {
		return __z;
	}

	private function setZ(value:Float):Float {
		__z = value;
		__isMatrixDirty = true;
		askRendering();
		return __z;
	}

	/**
	 * Indicates the x-axis scale (percentage) of the Sprite3D instance from its registration point relative to the local coordinate system of the 3D parent container.
	 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>scaleX</code> property.</p>
	 */
	public var _scaleX(getScaleX, setScaleX):Float;

	private function getScaleX():Float {
		return __scaleX;
	}

	private function setScaleX(value:Float):Float {
		__scaleX = value;
		__isMatrixDirty = true;
		askRendering();
		return __scaleX;
	}

	/**
	 * Indicates the y-axis scale (percentage) of the Sprite3D instance from its registration point relative to the local coordinate system of the 3D parent container.
	 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>scaleY</code> property.</p>
	 */
	public var _scaleY(getScaleY, setScaleY):Float;

	private function getScaleY():Float {
		return __scaleY;
	}

	private function setScaleY(value:Float):Float {
		__scaleY = value;
		__isMatrixDirty = true;
		askRendering();
		return __scaleY;
	}

	/**
	 * Indicates the z-axis scale (percentage) of the Sprite3D instance from its registration point relative to the local coordinate system of the 3D parent container.
	 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>scaleZ</code> property.</p>
	 */
	public var _scaleZ(getScaleZ, setScaleZ):Float;

	private function getScaleZ():Float {
		return __scaleZ;
	}

	private function setScaleZ(value:Float):Float {
		__scaleZ = value;
		__isMatrixDirty = true;
		askRendering();
		return __scaleZ;
	}

	/**
	 * Indicates the x-axis rotation (in degrees) of the Sprite3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
	 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>rotationX</code> property.</p>
	 */
	public var _rotationX(getRotationX, setRotationX):Float;

	private function getRotationX():Float {
		return __rotationX;
	}

	private function setRotationX(value:Float):Float {
		__rotationX = InternalUtils.formatRotation(value);
		__isMatrixDirty = true;
		askRendering();
		return __rotationX;
	}

	/**
	 * Indicates the y-axis rotation (in degrees) of the Sprite3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
	 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>rotationY</code> property.</p>
	 */
	public var _rotationY(getRotationY, setRotationY):Float;

	private function getRotationY():Float {
		return __rotationY;
	}

	private function setRotationY(value:Float):Float {
		__rotationY = InternalUtils.formatRotation(value);
		__isMatrixDirty = true;
		askRendering();
		return __rotationY;
	}

	/**
	 * Indicates the z-axis rotation (in degrees) of the Sprite3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
	 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
	 * 
	 * <p>This property has the same behavior than the normal Sprite <code>rotationZ</code> property.</p>
	 */
	public var _rotationZ(getRotationZ, setRotationZ):Float;

	private function getRotationZ():Float {
		return __rotationZ;
	}

	private function setRotationZ(value:Float):Float {
		__rotationZ = InternalUtils.formatRotation(value);
		__isMatrixDirty = true;
		askRendering();
		return __rotationZ;
	}

	//----------------------------------------------------------------------------------------------------
	// Properties (new)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Indicates a Matrix3D object representing the combined transformation matrixes of the Sprite3D instance and all of its parent 3D objects, back to the scene level.
	 */
	public var _concatenatedMatrix(getConcatenatedMatrix, null):Matrix3D;

	private function getConcatenatedMatrix():Matrix3D {
		return __concatenatedMatrix;
	}

	/**
	 * Specifies the Graphics3D object that belongs to this Sprite3D instance where vector drawing commands can occur.
	 * 
	 * <p>This property replaces the normal Sprite <code>graphics</code> property. The access to the normal Sprite <code>graphics</code> property throws an error.</p>
	 */
	public var _graphics3D(getGraphics3D, null):Graphics3D;

	private function getGraphics3D():Graphics3D {
		return __graphics;
	}

	/**
	 * A Matrix3D object containing values that affect the scaling, rotation, and translation of the Sprite3D instance.
	 */
	public var _matrix(getMatrix, setMatrix):Matrix3D;

	private function getMatrix():Matrix3D {
		if (__isMatrixDirty) {
			InternalUtils.setMatrix(__matrix, __x, __y, __z, __rotationX, __rotationY, __rotationZ, __scaleX, __scaleY, __scaleZ);
			__isMatrixDirty = false;
		}
		return __matrix;
	}

	private function setMatrix(value:Matrix3D):Matrix3D {
		__matrix = value;
		__isMatrixDirty = false;
		askRendering();
		if (__autoUpdatePropertiesOnMatrixChange) {
			updatePropertiesFromMatrix();
		}
		return __matrix;
	}

	/**
	 * Whether or not the Sprite3D instance transformation properties (x, y, z, scaleX, scaleY, scaleZ, rotationX, rotationY, rotationZ) are updated immediately after the matrix has been changed manually.
	 * 
	 * @see #matrix
	 * @see #updatePropertiesFromMatrix()
	 */
	public var _autoUpdatePropertiesOnMatrixChange(getAutoUpdatePropertiesOnMatrixChange, setAutoUpdatePropertiesOnMatrixChange):Bool;

	private function getAutoUpdatePropertiesOnMatrixChange():Bool {
		return __autoUpdatePropertiesOnMatrixChange;
	}

	private function setAutoUpdatePropertiesOnMatrixChange(value:Bool):Bool {
		__autoUpdatePropertiesOnMatrixChange = value;
		return __autoUpdatePropertiesOnMatrixChange;
	}

	/**
	 * Whether or not the Sprite3D instance is visible when not facing the screen.
	 */
	public var _singleSided(getSingleSided, setSingleSided):Bool;

	private function getSingleSided():Bool {
		return __singleSided;
	}

	private function setSingleSided(value:Bool):Bool {
		__singleSided = value;
		if (__singleSided) {
			__renderCulling = true;
		} else {
			__renderCulling = false;
			__culling = false;
		}
		return __singleSided;
	}

	/**
	 * Whether or not the Sprite3D instance colors are being altered by the scene ligthing parameters.
	 * 
	 * @see net.badimon.five3D.display.Scene3D.#ambientLightVector
	 * @see net.badimon.five3D.display.Scene3D.#ambientLightIntensity
	 */
	public var _flatShaded(getFlatShaded, setFlatShaded):Bool;

	private function getFlatShaded():Bool {
		return __flatShaded;
	}

	private function setFlatShaded(value:Bool):Bool {
		__flatShaded = value;
		if (__flatShaded) {
			__renderShading = true;
		} else {
			__renderShading = false;
			if (__flatShading) removeFlatShading();
		}
		return __flatShaded;
	}

	/**
	 * Whether or not the Sprite3D instance will sort its direct children according to their respective depths. The depth of each child is determined by the z coordinate of its registration point.
	 */
	public var _childrenSorted(getChildrenSorted, setChildrenSorted):Bool;

	private function getChildrenSorted():Bool {
		return __childrenSorted;
	}

	private function setChildrenSorted(value:Bool):Bool {
		__childrenSorted = value;
		return __childrenSorted;
	}

	//----------------------------------------------------------------------------------------------------
	// Methods (new)
	//----------------------------------------------------------------------------------------------------
	/**
	 * Updates the transformation properties (x, y, z, scaleX, scaleY, scaleZ, rotationX, rotationY, rotationZ) of the Sprite3D instance according to the matrix values.
	 * 
	 * @see #matrix
	 * @see #autoUpdatePropertiesOnMatrixChange
	 */
	public function updatePropertiesFromMatrix():Void {
		var matrixVector:Vector<Vector3D> = __matrix.decompose();
		var translationVector:Vector3D = matrixVector[0];
		var rotationVector:Vector3D = matrixVector[1];
		var scaleVector:Vector3D = matrixVector[2];
		__x = translationVector.x;
		__y = translationVector.y;
		__z = translationVector.z;
		__rotationX = InternalUtils.formatRotation(rotationVector.x * InternalUtils.RAD_TO_DEG);
		__rotationY = InternalUtils.formatRotation(rotationVector.y * InternalUtils.RAD_TO_DEG);
		__rotationZ = InternalUtils.formatRotation(rotationVector.z * InternalUtils.RAD_TO_DEG);
		__scaleX = scaleVector.x;
		__scaleY = scaleVector.y;
		__scaleZ = scaleVector.z;
	}

	//----------------------------------------------------------------------------------------------------
	// Workflow
	//----------------------------------------------------------------------------------------------------
	/**
	 * @private
	 */
	public function askRendering():Void {
		__render = true;
		__graphics.askRendering();
		if (__singleSided) __renderCulling = true;
		if (__flatShaded) __renderShading = true;
		var i:UInt;
		var num:UInt = numChildren;
		for (i in 0...num) cast(getChildAt(i), IObject3D).askRendering();
	}

	/**
	 * @private
	 */
	public function askRenderingShading():Void {
		if (__flatShaded) __renderShading = true;
		var i:UInt;
		var num:UInt = numChildren;
		for (i in 0...num) cast(getChildAt(i), IObject3D).askRenderingShading();
	}

	/**
	 * @private
	 */
	public function render(scene:Scene3D):Void {
		if (!__visible && visible) visible = false;
		else if (__visible) {
			if (__render) {
				if (__isMatrixDirty) {
					InternalUtils.setMatrix(__matrix, __x, __y, __z, __rotationX, __rotationY, __rotationZ, __scaleX, __scaleY, __scaleZ);
					__isMatrixDirty = false;
				}
				InternalUtils.setConcatenatedMatrix(__concatenatedMatrix, parent, __matrix);
				__normalVectorCalculated = false;
				__render = false;
			}
			if (__renderCulling) {
				setNormalVector();
				setCulling(scene._viewDistance);
				__normalVectorCalculated = true;
				__renderCulling = false;
			}
			if (__culling) {
				if (visible) visible = false;
			} else {
				if (!visible) visible = true;
				__graphics.render(graphics, __concatenatedMatrix, scene._viewDistance);
				if (__renderShading) {
					setNormalVector();
					applyFlatShading(scene);
					__renderShading = false;
				}
				var i:UInt;
				var num:UInt = numChildren;
				for (i in 0...num) cast(getChildAt(i), IObject3D).render(scene);
				if (__childrenSorted) sortChildren();
			}
		}
	}

	private function setNormalVector():Void {
		__concatenatedMatrix.transformVectors(__vectorIn, __vectorOut);
		__normalVector.x = __vectorOut[3] - __vectorOut[0];
		__normalVector.y = __vectorOut[4] - __vectorOut[1];
		__normalVector.z = __vectorOut[5] - __vectorOut[2];
	}

	private function setCulling(viewDistance:Float):Void {
		__cameraVector.x = __vectorOut[0];
		__cameraVector.y = __vectorOut[1];
		__cameraVector.z = __vectorOut[2] + viewDistance;
		__culling = __normalVector.dotProduct(__cameraVector) < 0;
	}

	private function applyFlatShading(scene:Scene3D):Void {
		__normalVector.normalize();
		InternalUtils.setFlatShading(this, __normalVector, scene._ambientLightVectorNormalized, scene._ambientLightIntensity, alpha);
		__flatShading = true;
	}

	private function removeFlatShading():Void {
		transform.colorTransform = new ColorTransform();
		__flatShading = false;
	}

	private function sortChildren():Void {
		var sort:Array<Dynamic> = [];
		var i:UInt;
		var num:UInt = numChildren;
		var child:IObject3D;
		for (i in 0...num) {
			child = cast(getChildAt(i), IObject3D);
			sort.push({child:child, z:child._concatenatedMatrix.position.z});
		}
		sort.sort(sortChildrenComparison);
		for (i in 0...num) setChildIndex(sort[i].child, i);
	}

	private function sortChildrenComparison(child1:Dynamic, child2:Dynamic):Int {
		var z1:Float = child1.z;
		var z2:Float = child2.z;
		return z1 == z2 ? 0 : z1 < z2 ? 1 : -1;
	}
}