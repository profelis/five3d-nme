/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display;

import flash.geom.Matrix3D;

/**
 * The IObject3D interface is the base interface for all 3D objects that can be placed in a FIVe3D Scene3D object display list.
 */
interface IObject3D {

	/**
	 * Indicates a Matrix3D object representing the combined transformation matrixes of the IObject3D instance and all of its parent 3D objects, back to the scene level.
	 */
	public var _concatenatedMatrix(getConcatenatedMatrix, null):Matrix3D;

	/**
	 * @private
	 */
	public function askRendering():Void;

	/**
	 * @private
	 */
	public function askRenderingShading():Void;

	/**
	 * @private
	 */
	public function render(scene:Scene3D):Void;
}