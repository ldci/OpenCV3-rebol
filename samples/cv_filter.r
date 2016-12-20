#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV Tests"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2015 François Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

do %../opencv.r
set 'appDir what-dir 

picture: to-string to-local-file join appDir "_images/lena.jpg"

;print "Select a picture"
;temp: request-file 
;picture: to-string to-local-file to-string temp


srcWnd: "Using cvTrackbar: ESC to close"
dstWnd: "Filtering"
tBar: "Filtre"

; CV_BLUR CV_GAUSSIAN CV_MEDIAN : OK 
; CV_BLUR_NO_SCALE CV_BILATERAL : OK;


; callback functions called by trackbar


{To summarize, in order to call cvCreateTrackbar  you need to declared a function with the signature void 
some_fun [pos [integer!]] to be able to be notified by OpenCV when the slider of the trackbar is updated. 
The argument  pos informs the new position of the slider.}

trackEvent: func [pos] [ 
		;if odd? pos
		if (pos and 1) = 1 [
			cvSmooth src dst CV_MEDIAN pos 1 0.0 0.0 
			cvShowImage dstWnd dst
		]
]


loadImage: does [
	cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE
	cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
	src: cvLoadImage picture CV_LOAD_IMAGE_UNCHANGED 
	dst: cvCloneImage src
	cvMoveWindow srcWnd 25 100
	cvMoveWindow dstWnd 550 100
	pos: pointer 'integer! 0 ; int pointer for trackbar event
	&pos: &pointer pos ; address pointer for the call back
	cvCreateTrackbar tBar srcWnd &pos 100 :trackEvent 
	cvShowImage srcWnd src
	cvShowImage dstWnd dst	
]

loadImage
cvwaitKey 0
free-mem &pos
free-mem src
free-mem dst
free-mem srcWnd
free-mem dstWnd
freeDylib

