#include <Utils.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
//#import <PhotosUI/PhotosUI.h>


extern "C" void sendImageSelectEvent(const char* type, unsigned char* data, unsigned long length);

void sendImageSelectEventWrap(const char* type, unsigned char* data,unsigned long length)
{
	dispatch_async(dispatch_get_main_queue(), ^{
		sendImageSelectEvent(type, data, length);
	});
}

@interface ImageViewController : UIViewController <UIImagePickerControllerDelegate, UIAdaptivePresentationControllerDelegate, UINavigationControllerDelegate>

@end

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)showPicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
	picker.presentationController.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
	UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
	[root presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	int photoWidth = (int)chosenImage.size.width;
    int photoHeight = (int)chosenImage.size.height;
    printf("[ImageSelect]: Captured photo %d x %d (orientation %ld)\n", photoWidth, photoHeight, chosenImage.imageOrientation);

    [picker dismissViewControllerAnimated:YES completion:NULL];

	NSData *data = UIImagePNGRepresentation(chosenImage);

    NSUInteger length = data.length;

	unsigned char *buffer = (unsigned char *)malloc((unsigned long)length);
	[data getBytes:buffer length:length];

	sendImageSelectEvent("extension.image_selected", buffer, (unsigned long) length);

	free(buffer);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
 
    [picker dismissViewControllerAnimated:YES completion:NULL];

	sendImageSelectEvent("extension.image_canceled", NULL, 0);
}

- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController {
	sendImageSelectEvent("extension.image_canceled", NULL, 0);
}

@end


namespace extension_image_select {
	extern "C"
	{
		static ImageViewController *imageViewController = nil;
		
		void initImageSelect()
		{
			printf("init image view controller\n");
			imageViewController = [[ImageViewController alloc] init];
		}

		void selectImage() {
			[imageViewController showPicker];
		}
	}
}