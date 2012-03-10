package;

import net.badimon.five3D.display.DynamicText3D;
import net.badimon.five3D.display.IObject3D;
import net.badimon.five3D.display.Scene3D;
import net.badimon.five3D.display.Shape3D;
import net.badimon.five3D.display.Sprite3D;
import net.badimon.five3D.typography.HelveticaBold;
import net.badimon.five3D.utils.DrawingUtils;
import nme.display.FPS;
import nme.display.MovieClip;

import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;

class Main extends Sprite {

	private var __scene:Scene3D;
	private var __sign:Sprite3D;
	private var __star:Shape3D;
	private var __hi:DynamicText3D;
	private var __world:DynamicText3D;

	public static function main() {
		new Main();
	}

	public function new() {
		super();
		flash.Lib.current.addChild(this);
		
		// We define the Stage scale mode.
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		// We create a new Scene3D named "scene", center it and add it to the display list.
		__scene = new Scene3D(true);
		__scene.x = 300;
		__scene.y = 200;
		addChild(__scene);
		
		// We create a new Sprite3D named "sign", draw a rounded rectangle inside and add it to the "scene" display list.
		__sign = new Sprite3D();
		__sign._graphics3D.beginFill(0x999999);
		__sign._graphics3D.drawRoundRect(-150, -150, 300, 300, 40, 40);
		__sign._graphics3D.endFill();
		__scene.addChild(__sign);
		
		// We create a new Shape3D named "star", draw a star inside, place it and add it to the "sign" display list.
		__star = new Shape3D();
		DrawingUtils.star(__star._graphics3D, 20, 60, 50, 0, 0xD7006C);
		__star._x = 120;
		__star._y = -80;
		__sign.addChild(__star);
		
		// We create a new DynamicText3D named "hi", modify its properties, place it and add it to the "sign" display list.
		__hi = new DynamicText3D(HelveticaBold.instance);
		__hi._size = 50;
		//__hi._letterSpacing = 0;
		__hi._color = 0xFFFFFF;
		__hi._text = "Hi!";
		__hi._x = 88;
		__hi._y = -110;
		__sign.addChild(__hi);
		
		// We create a new DynamicText3D named "world", modify its properties, place it and add it to the "sign" display list.
		__world = new DynamicText3D(HelveticaBold.instance);
		__world._size = 80;
		__world._color = 0x666666;
		__world._text = "World";
		__world._x = -112;
		__world._y = -34;
		__sign.addChild(__world);
		
		// We attribute a random value to the rotations on the X, Y and Z axes of the "sign".
		__sign._rotationX = Math.random() * 100 - 50;
		__sign._rotationY = Math.random() * 100 - 50;
		__sign._rotationZ = Math.random() * 100 - 50;
		
		// We register the class Main as a listener for the "enterFrame" event of the "star".
		__star.addEventListener(Event.ENTER_FRAME, starEnterFrameHandler);
		
		// We register the class Main as a listener for the "click" mouse event of the "sign" and modify some of its mouse-related properties.
		__sign.addEventListener(MouseEvent.CLICK, signClickHandler);
		__sign.mouseChildren = false;
		__sign.buttonMode = true;
		
		addChild(new FPS());
		
	}

	private function starEnterFrameHandler(event:Event):Void {
		// We rotate the "star".
		__star._rotationZ+= 1;
	}

	private function signClickHandler(event:MouseEvent):Void {
		// We attribute a new random value to the rotations on the X, Y and Z axes of the "sign".
		__sign._rotationX = Math.random() * 100 - 50;
		__sign._rotationY = Math.random() * 100 - 50;
		__sign._rotationZ = Math.random() * 100 - 50;
		
		//__sign.z += 2;
		//__sign._rotationZ += 2;
	}
}