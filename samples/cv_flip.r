#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV Tests: Flip functions "
	Author:		"Fran�ois Jouen"
	Rights:		"Copyright (c) 2015 Fran�ois Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
do %../opencv.r
set 'appDir what-dir 

wName: "Image 1 [space to continue]"
wName2: "Copy"

picture:  to-string to-local-file join appDir "_images/lena.jpg"

;print "Select a picture"
;temp: request-file 
;picture: to-string to-local-file to-string temp

img: cvLoadImage picture CV_LOAD_IMAGE_COLOR

cvShowImage wName img
cvWaitKey 0
cvWaitKey 0

cvFlip img img 0
cvShowImage wName img
cvWaitKey 0

cvFlip img img 1
cvShowImage wName img
cvWaitKey 0

cvFlip img img -1
cvShowImage wName img
cvWaitKey 0

cvFlip img img 1
cvShowImage wName img
cvWaitKey 0

cvFlip img img 1
cvShowImage wName img
cvWaitKey 0

cvDestroyAllWindows 
free-mem img
freeDylib
print "Done"
