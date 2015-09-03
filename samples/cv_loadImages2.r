#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV Tests: Simple Load Image "
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2014 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; this version is similar to C++ samples

do %../opencv.r   				; for loading the libs
set 'appDir what-dir 
picture: to-string to-local-file join appDir  "_images/lena.jpg"; "images/lena.jpg"

print startWindowThread
windowsName: "Hello OpenCV World"						; opencv window name
namedWindow windowsName  CV_WINDOW_AUTOSIZE			; create a opencv Window
img: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR			; get a pointer to loaded image
imShow windowsName img

waitKey 0
resizeWindow windowsName 256 256
waitKey 0

resizeWindow windowsName 512 512
moveWindow  windowsName 200 200
imShow windowsName img
print second getPointerValues img IplImage!							; print information about image

setWindowProperty windowsName CV_WND_PROP_FULLSCREEN 1.0
print getWindowProperty windowsName CV_WND_PROP_FULLSCREEN
c: waitKey 0											; wait for a key event 
destroyAllWindows
free-mem img
;free  library
freeDylib
