#! /usr/local//bin/rebolREBOL [	Title:		"OpenCV: C++ Webcam Access"	Author:		"Fran�ois Jouen"	Rights:		"Copyright (c) 2016 Fran�ois Jouen. All rights reserved."	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"]; this version uses C++ cam access ; For Windows 10 users (but run on OSX too)do %../opencv.rset 'appDir what-dir guiDir: join appDir "_RebGui/" do to-file join guiDir "rebgui.r"isActive: falsequitRequested: does [	if question "Quit this program ?" [		free-mem img		FreeDyLib ; free opencv lib space memory		quit]]upDateInfo: does [	set-text mem join "Used memory " [round/to stats / 1024 0.1 " KB"]	show [visu1 cam1]]; we can use directly a pointer to image/datatoRebol: does [	src: getIPLImage img 					; get values of IplImage structure	bgrdata: src/imageData					; address of image data	;get the data in rgb order	rimg/rgb:  reverse get-memory bgrdata src/imageSize 	visu1/image: rimg]showCam: does [	if isActive[		img: readCamera   			; read image from the camera		cvFlip img img 0  			; for Intel processor up/down flip		toRebol			  			; convert to Rebol       		;cvShowImage "Source"  img	;for tests		visu1/text: now/time/precise;show time		upDateInfo					; update widgets	]]activateCam: func [index [integer!]] [	if error? try [		openCamera index		visu1/text: "Camera Active"		set-text xRes getCameraProperty CV_CAP_PROP_FRAME_WIDTH		set-text yRes getCameraProperty CV_CAP_PROP_FRAME_HEIGHT		setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 640.00    	setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 480.00    	rimg: make image! 640x480 ; for rebol 		cam1/data: true		set-text activeCam join "Camera " index		isActive: true]		[cam1/data: false isActive: false alert "Cam is inactive"]	upDateInfo]; start camerastart: does [	if isActive [		visu1/rate: 30 ; fps		visu1/text: now/time/precise		cam1/data: true		upDateInfo	]];stop camera stop: does [	cvZero img	toRebol	visu1/text: " "	visu1/rate: none	cam1/data: none	recycle	upDateInfo	]mainWin: [	at 5x0 mem: field options [info] 110	at 120x0 button "Quit" [quitRequested]	at 1x7 	panel data [		visu1: image black 128x96  "Camera inactive"  		font [color: green valign: 'bottom]		feel [engage: make function! [face action event] [switch action [time [showCam]]]]		return		activeCam: field options[info] 20 "Camera"		button 13 "Activate" 	[activateCam 0] ; we use default cam		button 11 "Start"		[start]		button 11 "Stop"		[stop]		cam1: led		xRes: field options[info] 15		yRes: field options[info] 15	]	]display/close "OpenCV: C++ WebCam" mainWin [quitRequested]do-events