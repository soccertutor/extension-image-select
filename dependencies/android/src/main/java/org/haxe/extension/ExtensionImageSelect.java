package org.haxe.extension;


import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;

import android.opengl.GLSurfaceView;
import org.haxe.lime.HaxeObject;



import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;


import android.graphics.Bitmap;

import java.io.IOException;
import android.util.Log;

import android.net.Uri;

import java.io.FileDescriptor;
import android.os.ParcelFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;


import java.io.ByteArrayOutputStream;
import java.io.InputStream;


import android.widget.Toast;


/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/

public class ExtensionImageSelect extends Extension {
	
	private static HaxeObject callback = null;
	public static final int SELECT_IMAGE = 1;

	public static void initialize (HaxeObject callback) {
		ExtensionImageSelect.callback = callback;
	}

	public static void selectImage () {
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_GET_CONTENT);
		Extension.mainActivity.startActivityForResult(Intent.createChooser(intent, "Select Picture"), SELECT_IMAGE);
	}
	
	private static void fireCallback(final String name, final Object[] payload)
	{
		if (Extension.mainView == null || ExtensionImageSelect.callback == null) return;

		if (Extension.mainView instanceof GLSurfaceView)
		{
			GLSurfaceView view = (GLSurfaceView) Extension.mainView;
			view.queueEvent(new Runnable()
			{
				public void run()
				{
					ExtensionImageSelect.callback.call(name, payload);
				}
			});
		}
		else
		{
			Extension.mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					ExtensionImageSelect.callback.call(name, payload);
				}
			});
		}
	}



	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		
		if (requestCode == SELECT_IMAGE) {
			if (resultCode == Activity.RESULT_OK) {
				Uri selectedImageUri = data.getData();

				byte[] byteArray = null;

				try {
					ParcelFileDescriptor parcelFileDescriptor = Extension.mainActivity.getContentResolver().openFileDescriptor(selectedImageUri, "r");
					FileDescriptor fileDescriptor = parcelFileDescriptor.getFileDescriptor();
					//image = BitmapFactory.decodeFileDescriptor(fileDescriptor);
					ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
                
					InputStream inputStream = new ParcelFileDescriptor.AutoCloseInputStream(parcelFileDescriptor);

					// this is storage overwritten on each iteration with bytes
					int bufferSize = 1024;
					byte[] buffer = new byte[bufferSize];

					// we need to know how may bytes were read to write them to the byteBuffer
					int len = 0;
					while ((len = inputStream.read(buffer)) != -1) {
						byteBuffer.write(buffer, 0, len);
					}

					// and then we can return your byte array.
					byteArray = byteBuffer.toByteArray();

					parcelFileDescriptor.close();
				} catch (IOException e) {
					e.printStackTrace();
				}

				if (byteArray != null) {
					fireCallback("onImageSelected", new Object[] { byteArray });
				}
			} else {
				fireCallback("onImageCanceled", null);
			}
    	}

		return true;
	}

	

	/**
	 * Called when the activity receives th results for permission requests.
	 */
	public boolean onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {

		return true;

	}
	
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {



	}
	
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
		
		
		
	}
	
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
		
		
		
	}
	
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
		
		
		
	}
	
	
}