#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV Tests: Simple camera Image "
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2014 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


do %../opencv.r   				; for loading the libs
trackOn: true
mouseOn: true

cam: make cvVideoCapture [] 	; create a video capture instance
win: make cvWindow []			; create a cvWindow
cam/open CV_CAP_ANY 

if cam/isOpened [
	win/name: "Source"
	win/flags: CV_WINDOW_AUTOSIZE
	win/createWindow trackOn mouseOn
	win/moveWindow 200 200
	if win/isTrackBar [
		win/addTrackBar 10
		win/setTrackBar 0
	]
	if win/isMouse [win/addMouse]
	print "Camera is on" 
	print ["Camera Type: " cvGetCaptureDomain cam/open 0]
	print ["Width: " cam/getValue 3]
	print ["Height: " cam/getValue 4]
	print "Camera is now 640x480"
	cam/setValue 3 to-decimal 640
	cam/setValue 4 to-decimal 480
	
	rep: 0
	while [rep <> 113] [
		frame: cam/read
		;cam/grab
		;frame: cam/retrieve 0
		cvShowImage "Source"  frame
		rep: cvWaitkey 40
	]
]

win/destroyWindow
cam/release
freeDylib
