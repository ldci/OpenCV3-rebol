#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV 3.0.0: CvCapture"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;camera: load/library %/usr/local/lib32/xcode/libCameraLib.dylib 
; most of C++ functions returns a boolean value
; integer (0/1) are used with Rebol
openCamera: make routine! [
	index [integer!]
	return: [integer!]
] camera "openCamera"

releaseCamera: make routine! [
] camera "releaseCamera"


setCameraProperty:  make routine! [
"Set Camera property"
	propId  [integer!]
	value   [decimal!]
	return: [integer!]
] camera "setCameraProperty"

getCameraProperty: make routine! [
"Get Camera property"
	propId  [integer!]
	return: [decimal!]
]camera "getCameraProperty" 

readCamera: make routine! [
"Read camera frame"
	return: [integer!]
] camera "readCamera"

grabFrame: make routine! [
"Grab frame"
	return: [integer!]
] camera "grabFrame"

retrieveFrame: make routine! [
"Retrieve grabbed image"
	flag		[integer!]
	return: 	[integer!]
] camera "retrieveFrame"

openFile: make routine! [
"Open video file"
	fileName	[string!]
	return: 	[integer!]
] camera "openFile"


