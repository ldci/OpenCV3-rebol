#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV Binding: highgui"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2014 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; call c fonctions
do %highgui_c.r

;  C++ like user interface

namedWindow: func [winname [string!] flags [integer!]][
"create window: flags CV_DEFAULT(CV_WINDOW_AUTOSIZE)"
	cvNamedWindow winname flags
]

destroyWindow: func [winname [string!]] [
"destroy window and all the trackers associated with it"
	cvDestroyWindow winname
]

destroyAllWindows: does [
"destroy all windows and all the trackers associated with it"
	cvdestroyAllWindows
]

startWindowThread: does [
"Start a separated window thread that will manage mouse events"
	cvStartWindowThread
]

waitKey: func [delay [integer!]] [
"wait for key event infinitely (delay<=0) or for delay milliseconds"
	cvwaitKey delay
]

;****** REVOIR La matrice
imshow: func [winname [string!] mat [ptr!]] [
	;IplImage.InitFromMat(mat);
	;cvShowImage winname @IplImage
	cvShowImage winname mat
]

resizeWindow: func [winname [string!] width [integer!] height [integer!]] [
"move window to x y"
	cvresizeWindow winname width height
]

moveWindow: func [winname [string!] x [integer!] y [integer!]][
"resize window"
	cvmoveWindow  winname x y
]

setWindowProperty: func [winname [string!] prop_id [integer!] prop_value [decimal!]] [
	cvSetWindowProperty winname prop_id prop_value
]

getWindowProperty: func [winname [string!] prop_id [integer!]] [
	cvGetWindowProperty winname prop_id
]

; to be done

;createTrackbar
;getTrackbarPos
;setOpenGlDrawCallback
;setOpenGlContext
;updateWindow



; on cree des objets REBOL pour encapsuler le code c 
; broadly speaking these objects are similar to C++ classes proposed by OpenCV
; other C basic functions are in highgui_c.r

; A GDI context  
; This object is specific to REBOL
cvWindow: make object! [
	isOpened: make logic! false
	isTrackBar: make logic! false
	isMouse: make logic! false 
	pvalue: struct-address?  pointer 'integer! 0
	name: make string! "Window"
	flags: make integer! none
	;create window
	createWindow: make function! [trackBarRequired [logic!] mouseRequired [logic!]] [
		if (cvNamedWindow name flags) != 0 [isOpened: true] 
		if (trackBarRequired) = true [isTrackBar: true]
		if (mouseRequired) = true [isMouse: true]
	]
	destroyWindow: does [cvDestroyWindow name]
	moveWindow: make function! [x y] [cvmoveWindow name x y]
	resizeWindow: make function! [width height] [cvmoveWindow name x y] 
	; for trackbar
	trackEvent: func [pos [integer!]][print ["Trackbar position is : " pos]] 
	addTrackBar: make function! [count [integer!]] [cvCreateTrackbar "TrackBar" name pvalue count :trackEvent]
	setTrackBar: make function! [pos [integer!]] [cvSetTrackBarPos "TrackBar" name pos]
	; for mouse
	mouseEvent: func [
            event 	[integer!]
            x	    [integer!]
            y	    [integer!]
            flags	[integer!]
            param	[(int-ptr!)]
	] [print [event " : Mouse Position xy : " x " " y]]
	addMouse: does [cvSetMouseCallBack name :mouseEvent none]
]



; This is similar to cvVideoCapture class in C++

cvVideoCapture: make object! [
	capture: none
	frame: none
	isOpened: make logic! false
	
	open: make function! [device] [
		isOpened: false
		if number? device [either (capture: cvCreateCameraCapture device) != 0 [isOpened: true] [isOpened: false]]
		if string? device [either (capture: cvCreateFileCapture device) != 0 [isOpened: true] [isOpened: false]] 
	]
	release: does [capture: none recycle]
	grab: does [cvGrabFrame capture]
	retrieve: make function! [index] [frame: cvRetrieveFrame capture index]
	read: does [frame: cvQueryFrame capture]
	setValue: make function![propId [Integer!] value [decimal!]] [cvSetCaptureProperty capture propId value]
	getValue: make function! [propId [integer!]] [cvGetCaptureProperty capture propId]
]

; This is similar to cvVideoWriter class in C++
cvVideoWriter: make object! [
	isOpened: make logic! false
	open: make function! [
		filename [string!] 
		fourcc [integer!] 
		fps [decimal!] 
		width [integer!] 
		height [integer!] 
		isColor [integer!]] [
			cvCreateVideoWriter filename fourcc fps width height isColor
	]
	;write TBD

]







