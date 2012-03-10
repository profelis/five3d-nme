/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.utils;

import net.badimon.five3D.display.IObject3D;
import net.badimon.five3D.display.Scene3D;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.ColorTransform;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;

#if js
import Html5Dom;
#else
import flash.Vector;
#end

/**
 * @private
 */
class InternalUtils {

	public static inline var RAD_TO_DEG:Float = 180 / Math.PI;

	public static function formatRotation(angle:Float):Float {
		if (angle >= -180 && angle <= 180) return angle;
		var angle2:Float = angle % 360;
		if (angle2 < -180) return angle2 + 360;
		if (angle2 > 180) return angle2 - 360;
		return angle2;
	}

	public static function setMatrix(matrix:Matrix3D, x:Float, y:Float, z:Float, rotationX:Float, rotationY:Float, rotationZ:Float, scaleX:Float, scaleY:Float, scaleZ:Float):Void {
		matrix.identity();
		if (rotationX != 0) matrix.appendRotation(rotationX, Vector3D.X_AXIS);
		if (rotationY != 0) matrix.appendRotation(rotationY, Vector3D.Y_AXIS);
		if (rotationZ != 0) matrix.appendRotation(rotationZ, Vector3D.Z_AXIS);
		if (scaleX != 1 || scaleY != 1 || scaleZ != 1) matrix.appendScale(scaleX, scaleY, scaleZ);
		if (x != 0 || y != 0 || z != 0) matrix.appendTranslation(x, y, z);
	}

	public static function setMatrixPosition(matrix:Matrix3D, x:Float, y:Float, z:Float):Void {
		matrix.identity();
		if (x != 0 || y != 0 || z != 0) matrix.appendTranslation(x, y, z);
	}

	public static function setConcatenatedMatrix(concatenatedMatrix:Matrix3D, parent:DisplayObjectContainer, matrix:Matrix3D):Void {
		if (Std.is(parent, Scene3D)) {
			concatenatedMatrix.rawData = matrix.rawData.slice(0);
		} else {
			concatenatedMatrix.rawData = cast(parent, IObject3D)._concatenatedMatrix.rawData.slice(0);
			concatenatedMatrix.prepend(matrix);
		}
	}

	public static function setFlatShading(object:DisplayObject, normalVectorNormalized:Vector3D, ambientLightVectorNormalized:Vector3D, ambientLightIntensity:Float, alpha:Float):Void {
		var dot:Float = normalVectorNormalized.dotProduct(ambientLightVectorNormalized);
		var brightness:Float = dot * ambientLightIntensity;
		var colorTransform:ColorTransform = new ColorTransform();
		setColorTransformBrightness(colorTransform, brightness);
		colorTransform.alphaMultiplier = alpha;
		object.transform.colorTransform = colorTransform;
	}

	private static function setColorTransformBrightness(colorTransform:ColorTransform, value:Float):Void {
		if (value > 1) value = 1;
		else if (value < -1) value = -1;
		var percent:Float = 1 - Math.abs(value);
		var offset:Float = 0;
		if (value > 0) offset = value * 255;
		colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = percent;
		colorTransform.redOffset = colorTransform.greenOffset = colorTransform.blueOffset = offset;
	}

	public static function getScene(object:DisplayObject):Scene3D {
		object = object.parent;
		while (object != null) {
			if (Std.is(object, Scene3D)) return cast(object, Scene3D);
			object = object.parent;
		}
		return null;
	}

	public static function getInverseCoordinates(matrix:Matrix3D, x:Float, y:Float, viewDistance:Float):Point {
		var data1:Vector<Float> = matrix.rawData;
		var data2:Vector<Float> = new Vector<Float>();
		data2[0] = data1[0];
		data2[1] = data1[4];
		data2[2] = data1[8];
		data2[3] = data1[12];
		data2[4] = data1[1];
		data2[5] = data1[5];
		data2[6] = data1[9];
		data2[7] = data1[13];
		data2[8] = 0;
		data2[9] = 0;
		data2[10] = 1;
		data2[11] = 0;
		data2[12] = data1[2] / viewDistance;
		data2[13] = data1[6] / viewDistance;
		data2[14] = data1[10] / viewDistance;
		data2[15] = data1[14] / viewDistance + 1;
		var matrix2:Matrix3D = new Matrix3D();
		matrix2.rawData = data2;
		matrix2.invert();
		var data3:Vector<Float> = matrix2.rawData;
		var w:Float = data3[12] * x + data3[13] * y + data3[15];
		return new Point((data3[0] * x + data3[1] * y + data3[3]) / w, (data3[4] * x + data3[5] * y + data3[7]) / w);
	}
}