package;


import lime.system.CFFI;
import lime.system.JNI;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import events.ImageSelectEvent;

class ImageSelect {
	
	private static var dispatcher = new EventDispatcher ();

	public static function selectImage ():Void {
		
		#if android
		
		//TODO:
		
		/*
		var resultJNI = extension_image_select_sample_method_jni(inputValue);
		var resultNative = extension_image_select_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative; */
		
		#else
		
		return extension_image_select_select_image();
		
		#end
		
	}
	
	public static function initialize():Void {
		#if android
		//TODO:
		#else
		set_event_handle (notifyListeners);

		return extension_image_select_initialize();
		#end
	}

	private static function notifyListeners (inEvent:Dynamic):Void {

		var type = Std.string (Reflect.field (inEvent, "type"));

		switch (type) {
			case ImageSelectEvent.IMAGE_SELECTED:
				var data = Reflect.field (inEvent, "data");
				//var length = Std.int (Reflect.field (inEvent, "length"));
		
				var array:Array<Int> = cast data;
				var byteArray:openfl.utils.ByteArray = new openfl.utils.ByteArray();

				for (i in array) {
					byteArray.writeByte(i);
				}
				var event:ImageSelectEvent = new ImageSelectEvent(ImageSelectEvent.IMAGE_SELECTED, byteArray);
				dispatchEvent(event);
			case ImageSelectEvent.IMAGE_CANCELED:
				var event:ImageSelectEvent = new ImageSelectEvent(ImageSelectEvent.IMAGE_CANCELED);
				dispatchEvent(event);
			default:

		}
	}

	public static function addEventListener (type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		dispatcher.addEventListener (type, listener, useCapture, priority, useWeakReference);
	}

	public static function removeEventListener (type:String, listener:Dynamic, capture:Bool = false):Void {
		dispatcher.removeEventListener (type, listener, capture);
	}

	public static function dispatchEvent (event:Event):Bool {
		// fix for runinig callback from extension in proper gui thread
		haxe.Timer.delay(function() {
			dispatcher.dispatchEvent (event);
		}, 0);

		return true;
	}

	public static function hasEventListener (type:String):Bool {

		return dispatcher.hasEventListener (type);

	}


	
	private static var set_event_handle = CFFI.load ("extension_image_select", "extension_image_select_set_event_handle", 1);

	private static var extension_image_select_initialize = CFFI.load ("extension_image_select", "extension_image_select_initialize", 0);
	
	private static var extension_image_select_select_image = CFFI.load ("extension_image_select", "extension_image_select_select_image", 0);
	
	#if android
	private static var extension_image_select_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.Extension_image_select", "sampleMethod", "(I)I");
	#end
	
	
}