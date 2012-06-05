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
import flash.display.Graphics;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

/**
 * The Graphics3D class is the equivalent in the FIVe3D package of the Graphics class in the Flash package.
 * 
 * @see http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/display/Graphics.html
 */
class Graphics3D {

	private var __motif:Array<Array<Dynamic>>;
	private var __render:Bool;

	/**
	 * @private
	 */
	public function new() {
		__motif = [];
		__render = false;
	}

	/**
	 * Specifies a simple one-color fill that subsequent calls to drawing methods use when drawing.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>beginFill</code> method.</p>
	 * 
	 * @param color		The color of the fill.
	 * @param alpha		The alpha value of the fill (from 0.0 to 1.0).
	 */
	public function beginFill(color:UInt, alpha:Float = 1.0):Void {
		__motif.push(['B', [color, alpha]]);
		askRendering();
	}

	/**
	 * Clears the graphics that were drawn to this Graphics3D instance, and resets fill and line style settings.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>clear</code> method.</p>
	 */
	public function clear():Void {
		__motif = [];
		askRendering();
	}

	/**
	 * Draws a curve from the current drawing position to (anchorX, anchorY) and using the control point that (controlX, controlY) specifies.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>curveTo</code> method.</p>
	 * 
	 * @param controlX	The x coordinate of the control point along the x-axis relative to the registration point of the 3D parent container.
	 * @param controlY	The y coordinate of the control point along the y-axis relative to the registration point of the 3D parent container.
	 * @param anchorX	The x coordinate of the next anchor point along the x-axis relative to the registration point of the 3D parent container.
	 * @param anchorY	The y coordinate of the next anchor point along the y-axis relative to the registration point of the 3D parent container.
	 * 
	 * @see #curveToSpace()
	 */
	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		__motif.push(['C', [controlX, controlY, anchorX, anchorY]]);
		askRendering();
	}

	/**
	 * Draws a curve in space from the current drawing position to (anchorX, anchorY, anchorZ) and using the control point that (controlX, controlY, controlZ) specifies.
	 * 
	 * @param controlX	The x coordinate of the control point along the x-axis relative to the registration point of the 3D parent container.
	 * @param controlY	The y coordinate of the control point along the y-axis relative to the registration point of the 3D parent container.
	 * @param controlZ	The z coordinate of the control point along the z-axis relative to the registration point of the 3D parent container.
	 * @param anchorX	The x coordinate of the next anchor point along the x-axis relative to the registration point of the 3D parent container.
	 * @param anchorY	The y coordinate of the next anchor point along the y-axis relative to the registration point of the 3D parent container.
	 * @param anchorZ	The z coordinate of the next anchor point along the z-axis relative to the registration point of the 3D parent container.
	 * 
	 * @see #curveTo()
	 */
	public function curveToSpace(controlX:Float, controlY:Float, controlZ:Float, anchorX:Float, anchorY:Float, anchorZ:Float):Void {
		__motif.push(['C', [controlX, controlY, controlZ, anchorX, anchorY, anchorZ]]);
		askRendering();
	}

	/**
	 * Draws a circle with the fill and line style settings previously defined.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>drawCircle</code> method.</p>
	 * 
	 * @param x			The x coordinate of the center of the circle relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate of the center of the circle relative to the registration point of the 3D parent container.
	 * @param radius	The radius of the circle.
	 */
	public function drawCircle(x:Float, y:Float, radius:Float):Void {
		var A:Float = radius * (Math.sqrt(2) - 1);
		var B:Float = radius / Math.sqrt(2);
		__motif.push(['M', [x, y - radius]]);
		__motif.push(['C', [x + A, y - radius, x + B, y - B]]);
		__motif.push(['C', [x + radius, y - A, x + radius, y]]);
		__motif.push(['C', [x + radius, y + A, x + B, y + B]]);
		__motif.push(['C', [x + A, y + radius, x, y + radius]]);
		__motif.push(['C', [x - A, y + radius, x - B, y + B]]);
		__motif.push(['C', [x - radius, y + A, x - radius, y]]);
		__motif.push(['C', [x - radius, y - A, x - B, y - B]]);
		__motif.push(['C', [x - A, y - radius, x, y - radius]]);
		askRendering();
	}

	/**
	 * Draws an ellipse with the fill and line style settings previously defined.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>drawEllipse</code> method.</p>
	 * 
	 * @param x			The x coordinate of the top left corner of the bounding box of the ellipse relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate of the top left corner of the bounding box of the ellipse relative to the registration point of the 3D parent container.
	 * @param width		The width of the ellipse.
	 * @param height	The height of the ellipse.
	 */
	public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void {
		var x2:Float = x + width / 2;
		var y2:Float = y + height / 2;
		var radiusWidth:Float = width / 2;
		var radiusHeight:Float = height / 2;
		var AW:Float = radiusWidth * (Math.sqrt(2) - 1);
		var BW:Float = radiusWidth / Math.sqrt(2);
		var AH:Float = radiusHeight * (Math.sqrt(2) - 1);
		var BH:Float = radiusHeight / Math.sqrt(2);
		__motif.push(['M', [x2, y2 - radiusHeight]]);
		__motif.push(['C', [x2 + AW, y2 - radiusHeight, x2 + BW, y2 - BH]]);
		__motif.push(['C', [x2 + radiusWidth, y2 - AH, x2 + radiusWidth, y2]]);
		__motif.push(['C', [x2 + radiusWidth, y2 + AH, x2 + BW, y2 + BH]]);
		__motif.push(['C', [x2 + AW, y2 + radiusHeight, x2, y2 + radiusHeight]]);
		__motif.push(['C', [x2 - AW, y2 + radiusHeight, x2 - BW, y2 + BH]]);
		__motif.push(['C', [x2 - radiusWidth, y2 + AH, x2 - radiusWidth, y2]]);
		__motif.push(['C', [x2 - radiusWidth, y2 - AH, x2 - BW, y2 - BH]]);
		__motif.push(['C', [x2 - AW, y2 - radiusHeight, x2, y2 - radiusHeight]]);
		askRendering();
	}

	/**
	 * Draws a rectangle with the fill and line style settings previously defined.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>drawRect</code> method.</p>
	 * 
	 * @param x			The x coordinate of the top left corner of the rectangle relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate of the top left corner of the rectangle relative to the registration point of the 3D parent container.
	 * @param width		The width of the rectangle.
	 * @param height	The height of the rectangle.
	 */
	public function drawRect(x:Float, y:Float, width:Float, height:Float):Void {
		__motif.push(['M', [x, y]]);
		__motif.push(['L', [x + width, y]]);
		__motif.push(['L', [x + width, y + height]]);
		__motif.push(['L', [x, y + height]]);
		__motif.push(['L', [x, y]]);
		askRendering();
	}

	/**
	 * Draws a rounded rectangle with the fill and line style settings previously defined.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>drawRoundRect</code> method.</p>
	 * 
	 * @param x				The x coordinate of the top left corner of the rounded rectangle relative to the registration point of the 3D parent container.
	 * @param y				The x coordinate of the top left corner of the rounded rectangle relative to the registration point of the 3D parent container.
	 * @param width			The width of the rounded rectangle.
	 * @param height		The height of the rounded rectangle.
	 * @param ellipseWidth	The width of the ellipse used to draw the rounded corners.
	 * @param ellipseHeight	The height of the ellipse used to draw the rounded corners. Optional; if no value is specified, the default value matches the <code>ellipseWidth</code> parameter provided.
	 */
	public function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Float):Void {
		var x2:Float = x + width;
		var y2:Float = y + height;
		var radiusWidth:Float = Math.min(ellipseWidth / 2, width / 2);
		var radiusHeight:Float = (Math.isNaN(ellipseHeight)) ? radiusWidth : Math.min(ellipseHeight / 2, height / 2);
		var AW:Float = radiusWidth * (Math.sqrt(2) - 1);
		var BW:Float = radiusWidth / Math.sqrt(2);
		var AH:Float = radiusHeight * (Math.sqrt(2) - 1);
		var BH:Float = radiusHeight / Math.sqrt(2);
		__motif.push(['M', [x + radiusWidth, y]]);
		__motif.push(['L', [x2 - radiusWidth, y]]);
		__motif.push(['C', [x2 - radiusWidth + AW, y, x2 - radiusWidth + BW, y + radiusHeight - BH]]);
		__motif.push(['C', [x2, y + radiusHeight - AH, x2, y + radiusHeight]]);
		__motif.push(['L', [x2, y2 - radiusHeight]]);
		__motif.push(['C', [x2, y2 - radiusHeight + AH, x2 - radiusWidth + BW, y2 - radiusHeight + BH]]);
		__motif.push(['C', [x2 - radiusWidth + AW, y2, x2 - radiusWidth, y2]]);
		__motif.push(['L', [x + radiusWidth, y2]]);
		__motif.push(['C', [x + radiusWidth - AW, y2, x + radiusWidth - BW, y2 - radiusHeight + BH]]);
		__motif.push(['C', [x, y2 - radiusHeight + AH, x, y2 - radiusHeight]]);
		__motif.push(['L', [x, y + radiusHeight]]);
		__motif.push(['C', [x, y + radiusHeight - AH, x + radiusWidth - BW, y + radiusHeight - BH]]);
		__motif.push(['C', [x + radiusWidth - AW, y, x + radiusWidth, y]]);
		askRendering();
	}

	/**
	 * Applies a fill to the lines and curves that were added since the last call to the <code>beginFill</code> method.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>endFill</code> method.</p>
	 */
	public function endFill():Void {
		__motif.push(['E']);
		askRendering();
	}

	/**
	 * Specifies a line style that subsequent calls to drawing methods use when drawing.
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>lineStyle</code> method.</p>
	 * 
	 * @param thickness		The thickness of the line (in points from 0 to 255).
	 * @param color			The color of the line.
	 * @param alpha			The alpha value of the line (from 0.0 to 1.0).
	 * @param pixelHinting	Whether to hint strokes to full pixels.
	 * @param scaleMode	The line scale mode to use.
	 * @param caps			The type of caps at the end of lines.
	 * @param joints			The type of joint appearance used at angles.
	 * @param miterLimit		The limit at which a miter is cut off.
	 */
	public function lineStyle(thickness:Float = 1.0, color:UInt = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Float = 3):Void {
		var a:Array<Dynamic> = [thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit];
		__motif.push(['S', a]);
		askRendering();
	}

	/**
	 * Draws a line from the current drawing position to (x, y). The current drawing position is then set to (x, y).
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>lineTo</code> method.</p>
	 * 
	 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
	 * 
	 * @see #lineToSpace()
	 */
	public function lineTo(x:Float, y:Float):Void {
		__motif.push(['L', [x, y]]);
		askRendering();
	}

	/**
	 * Draws a line in space from the current drawing position to (x, y, z). The current drawing position is then set to (x, y, z).
	 * 
	 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
	 * @param z			The z coordinate along the z-axis relative to the registration point of the 3D parent container.
	 * 
	 * @see #lineTo()
	 */
	public function lineToSpace(x:Float, y:Float, z:Float):Void {
		__motif.push(['L', [x, y, z]]);
		askRendering();
	}

	/**
	 * Moves the current drawing position to (x, y).
	 * 
	 * <p>This property has the same behavior than the normal Graphics <code>moveTo</code> method.</p>
	 * 
	 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
	 * 
	 * @see #moveToSpace()
	 */
	public function moveTo(x:Float, y:Float):Void {
		__motif.push(['M', [x, y]]);
		askRendering();
	}

	/**
	 * Moves the current drawing position in space to (x, y, z).
	 * 
	 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
	 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
	 * @param z			The y coordinate along the z-axis relative to the registration point of the 3D parent container.
	 * 
	 * @see #moveTo()
	 */
	public function moveToSpace(x:Float, y:Float, z:Float):Void {
		__motif.push(['M', [x, y, z]]);
		askRendering();
	}

	/**
	 * Adds drawing instructions (motif) to the existing drawing intructions stored in the Graphics3D instance.
	 * 
	 * @param motif		The drawing instructions (motif) to be added.
	 * 
	 */
	public function addMotif(motif:Array<Array<Dynamic>>):Void {
		__motif = __motif.concat(motif);
		askRendering();
	}

	/**
	 * @private
	 */
	public function askRendering():Void {
		__render = true;
	}

	/**
	 * @private
	 */
	public function render(graphics:Graphics, matrix:Matrix3D, viewDistance:Float):Void {
		if (__render) {
			draw(graphics, matrix, viewDistance);
			__render = false;
		}
	}

	private function draw(graphics:Graphics, matrix:Matrix3D, viewDistance:Float):Void {
		var point1:Vector3D, point2:Vector3D, perspective:Float;
		graphics.clear();
		var i:UInt;
		var len:UInt = __motif.length;
		var instruction:Array<Dynamic>;
		var parameters:Array<Dynamic>;
		for (i in 0...len) {
			instruction = __motif[i];
			switch (instruction[0]) {
				case "B":
					parameters = instruction[1];
					graphics.beginFill(parameters[0], parameters[1]);
				case "S":
					parameters = instruction[1];
					graphics.lineStyle(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
				case "M":
					parameters = instruction[1];
					point1 = (parameters.length == 2) ? new Vector3D(parameters[0], parameters[1]) : new Vector3D(parameters[0], parameters[1], parameters[2]);
					point1 = matrix.transformVector(point1);
					perspective = viewDistance / (point1.z + viewDistance);
					point1.x *= perspective;
					point1.y *= perspective;
					graphics.moveTo(point1.x, point1.y);
				case "L":
					parameters = instruction[1];
					point1 = (parameters.length == 2) ? new Vector3D(parameters[0], parameters[1]) : new Vector3D(parameters[0], parameters[1], parameters[2]);
					point1 = matrix.transformVector(point1);
					perspective = viewDistance / (point1.z + viewDistance);
					point1.x *= perspective;
					point1.y *= perspective;
					graphics.lineTo(point1.x, point1.y);
				case "C":
					parameters = instruction[1];
					if (parameters.length == 4) {
						point1 = new Vector3D(parameters[0], parameters[1]);
						point2 = new Vector3D(parameters[2], parameters[3]);
					} else {
						point1 = new Vector3D(parameters[0], parameters[1], parameters[2]);
						point2 = new Vector3D(parameters[3], parameters[4], parameters[5]);
					}
					point1 = matrix.transformVector(point1);
					point2 = matrix.transformVector(point2);
					perspective = viewDistance / (point1.z + viewDistance);
					point1.x *= perspective;
					point1.y *= perspective;
					perspective = viewDistance / (point2.z + viewDistance);
					point2.x *= perspective;
					point2.y *= perspective;
					graphics.curveTo(point1.x, point1.y, point2.x, point2.y);
				case "E":
					graphics.endFill();
			}
		}
	}

	/**
	 * Clones the drawing instructions (motif) passed as parameter.
	 * 
	 * @param motif		The drawing instructions (motif) to be cloned.
	 */
	public static function clone(motif:Array<Array<Dynamic>>):Array<Array<Dynamic>> {
		var motif2:Array<Array<Dynamic>> = [];
		var i:UInt;
		var len:UInt = motif.length;
		var instruction:Array<Dynamic>;
		var parameters:Array<Dynamic>;
		for (i in 0...len) {
			instruction = motif[i];
			switch (instruction[0]) {
				case "B":
					parameters = instruction[1];
					motif2.push(['B', [parameters[0], parameters[1]]]);
				case "S":
					parameters = instruction[1];
					motif2.push(['S', [parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]]]);
				case "M":
					parameters = instruction[1];
					motif2.push(['M', (parameters.length == 2) ? [parameters[0], parameters[1]] : [parameters[0], parameters[1], parameters[2]]]);
				case "L":
					parameters = instruction[1];
					motif2.push(['L', (parameters.length == 2) ? [parameters[0], parameters[1]] : [parameters[0], parameters[1], parameters[2]]]);
				case "C":
					parameters = instruction[1];
					motif2.push(['C', (parameters.length == 4) ? [parameters[0], parameters[1], parameters[2], parameters[3]] : [parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]]]);
				case "E":
					motif2.push(['E']);
			}
		}
		return motif2;
	}
}