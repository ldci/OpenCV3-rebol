#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV Tests: C++ Camera Library"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2014 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	
]

; this version uses C++ cam access 
; use lib made with Xcode or Qt 
; For Windows 10 users (but run on OSX too)

do %../opencv.r

; you can play with cam number 
openCamera 0

print ["camera size : " getCameraProperty 3]
print ["camera size : " getCameraProperty 4]
setCameraProperty  3 640.00
setCameraProperty  4 480.00

print ["camera size now : " getCameraProperty 3]
print ["camera size now : " getCameraProperty 4]

rep: grabFrame
print ["Frame Captured?  " to-logic rep]
img: readCamera
print ["Image Pointer " img]
cvNamedWindow "Default Camera" 0
cvShowImage "Default Camera" img

rep: 0 ; Esc Key 
	while [rep <> 27] [
		img: readCamera
		cvShowImage "Default Camera" img
		rep: cvWaitkey 40
	]

releaseCamera