#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV Tests: Simple Load Image "
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2014 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; this version uses c function

do %../opencv.r   				; for loading the libs
set 'appDir what-dir 
picture:  to-string to-local-file join appDir  "_images/lena.jpg"; "images/lena.jpg"

print cvStartWindowThread
windowsName: "Hello OpenCV World"						; opencv window name
cvNamedWindow windowsName  CV_WINDOW_AUTOSIZE			; create a opencv Window
img: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR			; get a pointer to loaded image
imgStruct: getPointerValues img IplImage!				; put pointer values in a structure
cvShowImage windowsName img								; show image in cv Window;

;print cvGetSize imgStruct
;cvWaitKey 0
cvResizeWindow windowsName 256 256
cvWaitKey 0

cvResizeWindow windowsName 512 512
cvMoveWindow  windowsName 200 200
cvShowImage windowsName img	
			
print second getPointerValues img IplImage!		; print information about image

cvSetWindowProperty windowsName CV_WND_PROP_FULLSCREEN 1.0

print cvGetWindowProperty windowsName CV_WND_PROP_FULLSCREEN
c: cvWaitKey 0											; wait for a key event 
;
cvSetZero img
cvShowImage windowsName img
c: cvWaitKey 0											; wait for a key event 

cvDestroyAllWindows
free-mem img
;free  library
freeDylib

;CV_WND_PROP_AUTOSIZE