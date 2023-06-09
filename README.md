[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md)

# extension-image-select
Selecting image from camera roll/gallery on mobile devices


# Installation

You can easily install extension-image-select using haxelib:

	haxelib git extension-image-select https://github.com/soccertutor/extension-image-select
    
	lime rebuild extension-image-select ios -arm64 -armv6 -armv7 -clean


To add it to a Lime or OpenFL project, add this to your project file:

    <haxelib name="extension-image-select" />

# Usage

## 1. Initialize:

```haxe
ImageSelect.initialize();
ImageSelect.addEventListener(ImageSelectEvent.IMAGE_SELECTED, onImageSelect);
ImageSelect.addEventListener(ImageSelectEvent.IMAGE_CANCELED, onImageCancel);
```

## 2. Call image selection dialog:

```haxe
ImageSelect.selectImage();

private function onImageSelect(event:ImageSelectEvent) {
	trace(event.type, event.byteArray);
	//TODO: event.byteArray contains PNG file bytes
}

private function onImageCancel(event:ImageSelectEvent) {
	trace(event.type);
	//TODO: do something on cancel 
}
```


        


    