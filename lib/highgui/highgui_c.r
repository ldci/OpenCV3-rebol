#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV Binding: highgui_c"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2015 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; Highgui

; fonts
CV_FONT_LIGHT: 			25  ; QFont::Light;
CV_FONT_NORMAL: 		50  ; QFont::Normal;
CV_FONT_DEMIBOLD: 		63  ; QFont::DemiBold;
CV_FONT_BOLD: 			75  ; QFont::Bold;
CV_FONT_BLACK: 			87  ; QFont::Black;
CV_STYLE_NORMAL: 		0  ; QFont::StyleNormal;
CV_STYLE_ITALIC: 		1  ; QFont::StyleItalic;
CV_STYLE_OBLIQUE: 		2  ; QFont::StyleOblique;

;QT controls
CV_PUSH_BUTTON:			0;
CV_CHECKBOX:			1;
CV_RADIOBOX:			2;

; These flags are used by cvSet/GetWindowProperty
CV_WND_PROP_FULLSCREEN:		0  ; to change/get window's fullscreen property
CV_WND_PROP_AUTOSIZE:		1  ; to change/get window's autosize property
CV_WND_PROP_ASPECTRATIO:	2  ; to change/get window's aspectratio property
CV_WND_PROP_OPENGL:			3  ; to change/get window's opengl support

; These 2 flags are used by cvNamedWindow and cvSet/GetWindowProperty
CV_WINDOW_NORMAL:			to-integer #00000000   ;the user can resize the window (no constraint)  / also use to switch a fullscreen window to a normal size
CV_WINDOW_AUTOSIZE:			to-integer #00000001   ;the user cannot resize the window, the size is constrainted by the image displayed
CV_WINDOW_OPENGL:			to-integer #00001000   ;window with opengl support

; Those flags are only for Qt
CV_GUI_EXPANDED: 			to-integer  #00000000  ;status bar and tool bar
CV_GUI_NORMAL:          	to-integer  #00000010;  //old fashious way

;These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty;
CV_WINDOW_FULLSCREEN:		1  ; change the window to fullscreen
CV_WINDOW_FREERATIO:		to-integer #00000100  ; the image expends as much as it can (no ratio raint)
CV_WINDOW_KEEPRATIO:		to-integer #00000000  ; the ratio image is respected.;

; mouse events 
CV_EVENT_MOUSEMOVE: 		0
CV_EVENT_LBUTTONDOWN: 		1
CV_EVENT_RBUTTONDOWN: 		2
CV_EVENT_MBUTTONDOWN: 		3
CV_EVENT_LBUTTONUP: 		4
CV_EVENT_RBUTTONUP: 		5
CV_EVENT_MBUTTONUP: 		6
CV_EVENT_LBUTTONDBLCLK: 	7
CV_EVENT_RBUTTONDBLCLK: 	8
CV_EVENT_MBUTTONDBLCLK: 	9
CV_EVENT_FLAG_LBUTTON: 		1
CV_EVENT_FLAG_RBUTTON: 		2
CV_EVENT_FLAG_MBUTTON: 		4
CV_EVENT_FLAG_CTRLKEY: 		8
CV_EVENT_FLAG_SHIFTKEY: 	16
CV_EVENT_FLAG_ALTKEY: 		32
 





CV_FOURCC: func [c1 c2 c3 c4 /local v1 v2 v3 v4][
	v1: to-integer c1 and 255 
	v2: shift/left to-integer c2 and 255 8
	v3: shift/left to-integer c3 and 255 16
	v4: shift/left to-integer c4 and 255 24
	v1 + v2 + v3 + v4
]

CV_FOURCC_PROMPT: 		-1  ; Open Codec Selection Dialog (Windows only) */
CV_FOURCC_DEFAULT: 		-1 ; Use default codec for specified filename (Linux only) */

if isQT [
	cvFontQt: cvFunc [nameFont [string!] pointSize [integer!] r [integer!] g [integer!] b [integer!] a [integer!] weight [integer!]style [integer!] return: [CvFont!]] highgui "cvFontQt" 
	cvAddText: cvFunc [ing [ptr!] text [string!] orgx [integer!] orgy [integer!] arg2 [CvFont!]] highgui "cvAddText"
	cvDisplayOverlay: cvFunc [name [string!] text [string!] delayms [integer!]] highgui "cvDisplayOverlay"
	cvDisplayStatusBar: cvFunc [name [string!] text [string!] delayms [integer!]] highgui "cvDisplayStatusBar"
	cvSaveWindowParameters: cvFunc [name [string!]] highgui "cvSaveWindowParameters" 
	cvLoadWindowParameters: cvFunc [name [string!]] highgui "cvLoadWindowParameters"
	cvStartLoop: cvFunc [ argc [integer!] *argv[string!] argc [integer!] *argv [string!]] 	highgui "cvStartLoop"
	cvStopLoop: cvFunc [] highgui "cvStopLoop"
	CvButtonCallback: cvFunc [state [integer!] userdata [ptr!]] highgui "CvButtonCallback" 
	cvCreateButton: cvFunc [button_name [string!] on_change [ptr!] userdata [ptr!] 
		button_type [integer!] initial_button_state [integer!] ] highgui"cvCreateButton"
]

cvInitSystem: cvFunc [argc [integer!] char** [string!] return: [integer!]] highgui "cvInitSystem"
cvStartWindowThread: cvFunc [return: [integer!]] highgui "cvStartWindowThread"
cvNamedWindow: cvFunc [name [string!] flag [integer!] return: [ptr!]] highgui "cvNamedWindow"

;Set and Get Property of the window
cvSetWindowProperty: cvFunc [name [string!] prop_id [integer!] prop_value [decimal!]] highgui "cvSetWindowProperty" 
cvGetWindowProperty: cvFunc [name [string!] prop_id [integer!] return: [decimal!]] highgui "cvGetWindowProperty" 

; windows
cvShowImage: cvFunc [name [string!] img [ptr!]] highgui "cvShowImage"
cvResizeWindow: cvFunc [name[string!] width [integer!] height [integer!]] highgui "cvResizeWindow"
cvMoveWindow: cvFunc [name [string!] x [integer!] y [integer!]] highgui "cvMoveWindow"
cvDestroyWindow: cvFunc [name [string!]] highgui "cvDestroyWindow"
cvDestroyAllWindows: cvFunc [] highgui "cvDestroyAllWindows"
;get native window handle (HWND in case of Win32 and Widget in case of X Window)
cvGetWindowHandle: cvFunc [name [string!] return: [ptr!]] highgui "cvGetWindowHandle"
cvGetWindowName: cvFunc [window_handle [ptr!] return: [string!]] highgui "cvGetWindowName"
cvHaveImageReader: cvFunc [filename [string!]] highgui "cvHaveImageReader"
cvHaveImageWriter: cvFunc [filename [string!]] highgui "cvHaveImageWriter"
cvCreateTrackbar: cvFunc [
	trackbar_name 	[string!]
	window_name 	[string!]
	value 			[ptr!] ; pointer
	count 			[integer!]
	on_change 		[callback [ptr!]]; can be none 
	return: 		[integer!]	
] highgui "cvCreateTrackbar"

cvCreateTrackbar2: cvFunc [
	trackbar_name 	[string!]
	window_name 	[string!]
	value 			[ptr!] ; pointer
	count 			[integer!]
	on_change 		[callback [ptr!]]; can be none 
	userdata		[ptr!]
	return: 		[integer!]	
] highgui "cvCreateTrackbar2"

cvGetTrackbarPos: cvFunc [trackbar_name [string!] window_name [string!] return: [integer!]] highgui "cvGetTrackbarPos"
cvSetTrackbarPos: cvFunc [trackbar_name [string!] window_name [string!] pos [integer!] return: [integer!] ] highgui "cvSetTrackbarPos"

cvSetMouseCallback: cvFunc [
"assign callback for mouse events"
	window_name 	[string!]
	on_mouse 		[callback [ptr! ptr! ptr! ptr! ptr!]] ; pointer sur une fonction avec 5 params
    param			[integer!] ; pointer must be null (set to none)
    return:			[]
] highgui "cvSetMouseCallback"


cvWaitKey: cvFunc [delay [integer!] return: [ptr!]] highgui "cvWaitKey"

;OpenGL support
cvSetOpenGlDrawCallback: cvFunc [
	window_name 	[string!]
	callback		[ptr!]
	userdata		[ptr!] ;CV_DEFAULT(NULL)
] highgui "cvSetOpenGlDrawCallback" 

cvSetOpenGlContext: cvFunc [window_name [string!]] highgui "cvSetOpenGlContext" 
cvUpdateWindow: cvFunc [window_name [string!]] highgui "cvUpdateWindow" 





{Obsolete functions/synonyms 
#define cvCaptureFromFile cvCreateFileCapture
#define cvCaptureFromCAM cvCreateCameraCapture
#define cvCaptureFromAVI cvCaptureFromFile
#define cvCreateAVIWriter cvCreateVideoWriter
#define cvWriteToAVI cvWriteFrame
#define cvAddSearchPath(path)
#define cvvInitSystem cvInitSystem
#define cvvNamedWindow cvNamedWindow
#define cvvShowImage cvShowImage
#define cvvResizeWindow cvResizeWindow
#define cvvDestroyWindow cvDestroyWindow
#define cvvCreateTrackbar cvCreateTrackbar
#define cvvLoadImage(name) cvLoadImage((name),1)
#define cvvSaveImage cvSaveImage
#define cvvAddSearchPath cvAddSearchPath
#define cvvWaitKey(name) cvWaitKey(0)
#define cvvWaitKeyEx(name,delay) cvWaitKey(delay)
#define cvvConvertImage cvConvertImage
#define HG_AUTOSIZE CV_WINDOW_AUTOSIZE
#define set_preprocess_func cvSetPreprocessFuncWin32
#define set_postprocess_func cvSetPostprocessFuncWin32

#if defined WIN32 || defined _WIN32

CVAPI(void) cvSetPreprocessFuncWin32_(const void* callback);
CVAPI(void) cvSetPostprocessFuncWin32_(const void* callback);
#define cvSetPreprocessFuncWin32(callback) cvSetPreprocessFuncWin32_((const void*)(callback))
#define cvSetPostprocessFuncWin32(callback) cvSetPostprocessFuncWin32_((const void*)(callback))

#endif

}

