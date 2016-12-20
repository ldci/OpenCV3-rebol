#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV: 4 WebCams"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2016 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; this version uses C++ cam access 

do %../opencv.r
set 'appDir what-dir 
guiDir: join appDir "_RebGui/" 
do to-file join guiDir "rebgui.r"

; we create first a generic object for webcam

camera: make object![
	; variables
	index: make integer! 0
	height: make integer! 0
	width: make integer! 0
	aled: none 
	win: make image! 320x240
	rimg: make image! 320x240
	image: cvCreateImage 320 240 IPL_DEPTH_8U 3 ; 8-bit 3 channels
	isActive: false
	capture: 0
	
	;methods
    init: make function! [v1 v2 v3 v4 v5] [
    	index: 	v1
    	weight: v2
    	width: 	v3
    	aled:   v4
    	win: 	v5
    	aled/data: true
    	if not isActive [
			if error? try [capture: openCamera index
			setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 320.00
    		setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 240.00] 
    		[quit]
		]
		if  capture <> 0 [ 
			win/rate: none
			win/text: "Camera ready" isActive: true
			image: readCamera  ; grab and retrieve image
			cvFlip image image 0  ; for Intel processor up/down flip
			cvZero image
			toRebol
		]
		show [aled win]
    ]
    
	start: does [
		if isActive [
	    	win/rate: 30
	    	win/text: now/time/precise
			aled/data: true
			show [aled win]
		]
	]
	
	stop: does [
		if isActive[
	    	win/rate: none
			aled/data: none 
			cvZero image
			toRebol
			win/text: "Camera ready"
			show [aled win]
		]
	]
	
	toRebol: does [
		src: getIPLImage image 					; get values of IplImage structure
		bgrData: src/imageData					; address of image data
		;get the data in rgb order
		rimg/rgb:  reverse get-memory bgrData src/imageSize 
		win/image: rimg
		show win
	]
	
	
	showVideo: does [
		if isActive [
		image: readCamera  		; grab and retrieve image
		cvFlip image image 0  	; for Intel processor up/down flip
		win/text: now/time/precise
		torebol
		set-text mem join "Used memory " [round/to stats / 1024 0.1 " KB"]
		]
	]
	release: does [if not none? image [free-mem image]]
	
]

; make 4 objects for 4 cams

camera1: make camera []
camera2: make camera []
camera3: make camera []
camera4: make camera []


quitRequested: does [
	if question "Quit this program ?" [
		if camera1/isActive [camera1/release]
		if camera2/isActive [camera2/release]
		if camera3/isActive [camera3/release]
		if camera4/isActive [camera4/release]
		FreeDyLib
	quit]

]

;How many cams are connected ?
countCamera: does [
    count: 0;
	until [
		cam: openCamera count
		if cam > 0 [count: count + 1]
    cam = 0
	]
	set-text nbCam join " Nb Camera " count
]


mainWin: [
	at 5x0 nbCam: field options [info] 25 
	mem: field options [info] 100
	at 135x0 button "Quit" [quitRequested]
	at 1x7 
	panel data [
		visu1: image black 64x48  "Camera inactive"  
		font [color: green valign: 'bottom]
		feel [engage: make function! [face action event] [switch action [time [camera1/showVideo]]]]
		return
		field options [info] 17 "Camera 1"
		button 13 "Activate" 	[camera1/init 0 320 240 cam1 visu1]
		button 11 "Start"		[camera1/start]
		button 11 "Stop"		[camera1/stop]
		cam1: led
	]	
	
	panel data [
		visu2: image black 64x48 "Camera inactive"  
		font [color: green valign: 'bottom]
		feel [engage: make function! [face action event] [switch action [time [camera2/showVideo]]]]
		return
		field options [info] 17 "Camera 2"		
		button 13 "Activate"	[camera2/init 1 320 240 cam2 visu2]
		button 11 "Start"		[camera2/start]
		button 11 "Stop"		[camera2/stop]
		cam2: led
	]	
	return
	
	panel data [
		visu3: image black 64x48 "Camera inactive"  
		font [color: green valign: 'bottom]
		feel [engage: make function! [face action event] [switch action [time [camera3/showVideo]]]]
		return
		field options [info] 17 "Camera 3"
		button 13 "Activate"	[camera3/init 2 320 240 cam3 visu3]
		button 11 "Start"		[camera3/start]
		button 11 "Stop"		[camera3/stop]
		cam3: led
	]	
	
	panel data [
		visu4: image black 64x48 "Camera inactive"  
		font [color: green valign: 'bottom]
		feel [engage: make function! [face action event] [switch action [time [camera4/showVideo]]]]
		return
		field options [info] 17 "Camera 4"
		button 13 "Activate"	[camera4/init 3 320 240 cam4 visu4]
		button 11 "Start"		[camera4/start]
		button 11 "Stop"		[camera4/stop]
		cam4: led
	]	
	do [countCamera]		
]


;
display/close "OpenCV: 4 WebCams" mainWin [quitRequested]
do-events
