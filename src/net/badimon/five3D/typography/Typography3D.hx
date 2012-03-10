/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.typography;

/**
 * The Typography3D class is the base class for all typography 3D objects that can be used to display text.
 */
class Typography3D {

	private var motifs:Hash<Array<Dynamic>>;
	private var widths:Hash<Float>;
	private var height:Float;

	/**
	 * Creates a new Sprite3D instance.
	 */
	public function new() {
		motifs = new Hash<Array<Dynamic>>();
		widths = new Hash<Float>();
	}

	/**
	 * Returns the motif (drawing instructions) of a character.
	 * 
	 * @param char	The character of which the motif will be returned.
	 */
	public function getMotif(char:String):Array<Dynamic> {
		return motifs.get(char);
	}

	/**
	 * Returns the width of a character.
	 * 
	 * @param char	The character of which the width will be returned.
	 */
	public function getWidth(char:String):Float {
		return widths.get(char);
	}

	/**
	 * Returns the Typography3D instance line height.
	 */
	public function getHeight():Float {
		return height;
	}
}