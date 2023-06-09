package events;

import openfl.utils.ByteArray;
import openfl.events.Event;

class ImageSelectEvent extends Event
{
    public static inline var IMAGE_SELECTED = "extension.image_selected";
    public static inline var IMAGE_CANCELED = "extension.image_canceled";

    public var byteArray:ByteArray = null;

    public function new(type:String, byteArray:ByteArray = null)
    {
        super(type, false, true);

        this.byteArray = byteArray;
    }
}