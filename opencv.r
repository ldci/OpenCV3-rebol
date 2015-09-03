#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV 3.0.0"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


loadDylib: does [
	;Darwin
	if system/version/4 = 2  [
		world: load/library %/usr/local/lib32/opencv3/libopencv_world.3.0.0.dylib 
	]
	
	;windows
	if system/version/4 = 3 [
		world: load/library to-file "c:\opencv3\build\x86\vc12\bin\opencv_world300.dll"
	]
	
	;Linux
	if system/version/4 = 4 [
		world: load/library %/usr/local/lib32/opencv3/libopencv_world.3.0.0.so 
	]
	
	calib3d: core: highgui: imgcodecs: imgproc: objectd: photo: video: videoio: world
]



freeDylib: does [
	free world
]


loadDylib

isQT: false ; use QT or not

;use integer! as pointer shortcut: gives the memory address of pointed values or structures 
ptr!: integer! ; for CvArr, CvMat and all opaque structures


;define a mezzanine function to be used to generate REBOL routine! for ALL cv Functions 
; only for c functions
cvFunc: func [specs lib id] [make routine! specs lib id]

;load all is needed
do %lib/rebol/tools.r					; tools by famous rebolers
do %lib/calib3d/calib3d_c.r				; Camera Calibration, Pose Estimation and Stereo c functions
do %lib/core/types_c.r					; data types for core
do %lib/core/core_c.r					; core c functions
do %lib/highgui/highgui.r 	        	; highgui c and C++ like functions 
do %lib/imgcodecs/imgcodecs_c.r			; for image 
do %lib/imgproc/types_c.r				; data types for image processing
do %lib/imgproc/imgproc.r				; image processing c functions
do %lib/objdetect/objdetect_c.r			; Haar-like Object Detection c functions  
do %lib/photo/photo_c.r 	        	; photo c functions 
do %lib/video/video_c.r 	        	; Motion Analysis c functions 
do %lib/videoio/videoio_c.r 	        ; Camera c functions




