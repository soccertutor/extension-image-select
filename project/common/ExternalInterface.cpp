#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <stdio.h>
#include "Utils.h"

#define safe_alloc_string(a) (a!=NULL?alloc_string(a):NULL)

using namespace extension_image_select;

static value extension_image_select_initialize() 
{
	initImageSelect();
	return alloc_null();
}
DEFINE_PRIM (extension_image_select_initialize, 0);

static value extension_image_select_select_image () {
	selectImage();
	return alloc_null();
	
}
DEFINE_PRIM (extension_image_select_select_image, 0);

AutoGCRoot* imageSelectEventHandle = 0;
static value extension_image_select_set_event_handle(value onEvent)
{
	imageSelectEventHandle = new AutoGCRoot(onEvent);
	return alloc_null();
}
DEFINE_PRIM(extension_image_select_set_event_handle, 1);


extern "C" void extension_image_select_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (extension_image_select_main);

extern "C" void sendImageSelectEvent(const char* type, unsigned char* data, unsigned long length)
{
	value bytes;
	buffer b = alloc_buffer_len (length);
	unsigned char* data_ = (unsigned char*)buffer_data (b);

	bytes = buffer_val (b);
	memcpy(data_, data, length*sizeof(unsigned char));

	value o = alloc_empty_object();
	alloc_field(o,val_id("type"),safe_alloc_string(type));
	alloc_field(o,val_id("data"),bytes);

	val_call1(imageSelectEventHandle->get(), o);
}

extern "C" int extension_image_select_register_prims () { return 0; }