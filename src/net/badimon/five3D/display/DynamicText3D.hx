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
import net.badimon.five3D.typography.Typography3D;

import flash.geom.ColorTransform;

/**
 * The DynamicText3D class is the equivalent in the FIVe3D package of the TextField class in the Flash package despite a different implementation.
 */
class DynamicText3D extends Sprite3D {

	private var __text:String;
	private var __typography:Typography3D;
	private var __size:Float;
	private var __color:UInt;
	private var __letterSpacing:Float;
	private var __textWidth:Float;
	// Calculation
	private var __sizeMultiplicator:Float;

	/**
	 * Creates a new DynamicText3D instance.
	 * 
	 * @param typography	the Typography3D object that the DynamicText3D instance uses to display the text.
	 */
	public function new(typography:Typography3D) {
		super();
		__text = "";
		__typography = typography;
		__size = 10;
		__color = 0x000000;
		__letterSpacing = 0;
		__textWidth = 0;
		__sizeMultiplicator = __size / 100;
	}

	//----------------------------------------------------------------------------------------------------
	// Properties
	//----------------------------------------------------------------------------------------------------
	/**
	 * Indicates the current text of the DynamicText3D instance.
	 */
	public var _text(getText, setText):String;

	private function getText():String {
		return __text;
	}

	private function setText(value:String):String {
		createGlyphs(value);
		__text = value;
		removeAdditionalGlyphs();
		placeGlyphs();
		return __text;
	}

	private function createGlyphs(text:String):Void {
		var charOld:String, charNew:String, identical:Bool = true;
		var i:UInt;
		var len:UInt = text.length;
		for (i in 0...len) {
			charOld = __text.charAt(i);
			charNew = text.charAt(i);
			if ((charOld != charNew) || !identical) {
				createGlyph(i, charNew);
				identical = false;
			}
		}
	}

	private function createGlyph(index:UInt, char:String):Void {
		var shape:Shape3D = new Shape3D();
		shape._graphics3D.addMotif([['B', [__color, 1]]]);
		shape._graphics3D.addMotif(Graphics3D.clone(__typography.getMotif(char)));
		shape._graphics3D.addMotif([['E']]);
		shape._scaleX = shape._scaleY = __sizeMultiplicator;
		addChildAt(shape, index);
	}

	private function removeAdditionalGlyphs():Void {
		var i:Int = numChildren - 1;
		var len:Int = __text.length;
		while (i >= len) {
			removeChildAt(i);
			i--;
		}
	}

	private function placeGlyphs():Void {
		var offset:Float = 0;
		var i:UInt;
		var num:UInt = numChildren;
		var shape:Shape3D;
		for (i in 0...num) {
			shape = cast(getChildAt(i), Shape3D);
			if (shape._x != offset) shape._x = offset;
			if (i == num - 1) {
				__textWidth = offset + __typography.getWidth(__text.charAt(i)) * __sizeMultiplicator;
			} else {
				offset += (__typography.getWidth(__text.charAt(i)) + __letterSpacing) * __sizeMultiplicator;
			}
		}
	}

	/**
	 * Indicates the Typography3D object that the DynamicText3D instance uses to display the text.
	 */
	public var _typography(getTypography, setTypography):Typography3D;

	private function getTypography():Typography3D {
		return __typography;
	}

	private function setTypography(value:Typography3D):Typography3D {
		__typography = value;
		reinitText(__text);
		return __typography;
	}

	private function reinitText(text:String):Void {
		__text = "";
		_text = text;
	}

	/**
	 * Indicates the text size (in pixels) of the DynamicText3D instance.
	 */
	public var _size(getSize, setSize):Float;

	private function getSize():Float {
		return __size;
	}

	private function setSize(value:Float):Float {
		__size = value;
		__sizeMultiplicator = __size / 100;
		resizeGlyphs();
		placeGlyphs();
		return __size;
	}

	private function resizeGlyphs():Void {
		var i:UInt;
		var num:UInt = numChildren;
		var shape:Shape3D;
		for (i in 0...num) {
			shape = cast(getChildAt(i), Shape3D);
			shape._scaleX = shape._scaleY = __sizeMultiplicator;
		}
	}

	/**
	 * Indicates the text color of the DynamicText3D instance.
	 */
	public var _color(getColor, setColor):UInt;

	private function getColor():UInt {
		return __color;
	}

	private function setColor(value:UInt):UInt {
		__color = value;
		colorateGlyphs();
		return __color;
	}

	private function colorateGlyphs():Void {
		var colorTransform:ColorTransform = new ColorTransform();
		//colorTransform.color = __color;
		colorTransform.redMultiplier = 0;
		colorTransform.greenMultiplier = 0;
		colorTransform.blueMultiplier = 0;
		colorTransform.redOffset = (_color >> 16) & 0xFF;
		colorTransform.greenOffset = (_color >> 8) & 0xFF;
		colorTransform.blueOffset = (_color) & 0xFF;
		var i:UInt;
		var num:UInt = numChildren;
		var shape:Shape3D;
		for (i in 0...num) {
			shape = cast(getChildAt(i), Shape3D);
			shape.transform.colorTransform = colorTransform;
		}
	}

	/**
	 * Indicates the amount of space between every character of the DynamicText3D instance.
	 */
	public var _letterSpacing(getLetterSpacing, setLetterSpacing):Float;

	private function getLetterSpacing():Float {
		return __letterSpacing;
	}

	private function setLetterSpacing(value:Float):Float {
		__letterSpacing = value;
		placeGlyphs();
		return __letterSpacing;
	}

	/**
	 * Indicates the width of the text (in pixels) of the DynamicText3D instance.
	 */
	public var _textWidth(getTextWidth, null):Float;

	private function getTextWidth():Float {
		return __textWidth;
	}

	//----------------------------------------------------------------------------------------------------
	// Errors
	//----------------------------------------------------------------------------------------------------
	/**
	 * @private
	 */
	override public var _graphics3D(getGraphics3D, null):Graphics3D;

	override private function getGraphics3D():Graphics3D {
		throw "The DynamicText3D class does not implement this property or method.";
		return null;
	}
}