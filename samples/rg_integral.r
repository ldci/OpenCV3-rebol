#! /usr/local/bin/rebol
REBOL [
	Title:		"HumaNum 2015"
	Author:		"Franois Jouen and Ke Liang"
	Rights:		"Copyright (c) 2012-2016 Franois Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

do %../opencv.r
set 'appDir what-dir 

guiDir: join appDir "_RebGui/" 
do to-file join guiDir "rebgui.r"


colorspace: [CV_HSV2RGB CV_HSV2BGR  
			CV_BGR2HLS CV_RGB2HLS CV_HLS2BGR CV_HLS2RGB
			CV_BGR2Lab CV_RGB2Lab CV_Lab2BGR CV_Lab2RGB
			CV_BGR2Luv CV_RGB2Luv CV_Luv2BGR CV_Luv2RGB
			]

colorS: CV_HSV2RGB

isFile: false
w: h: 0
thresh: 127
boxW: 5
boxH: 5
stopRequired: false

; Self explanatory

loadImage: does [
	isFile: false
	temp: request-file 
	if not none? temp [
	 	filename: to-string to-local-file to-string temp
		if error? try [
			src: cvLoadImage filename CV_LOAD_IMAGE_COLOR; CV_LOAD_IMAGE_UNCHANGED 
			srcS: getPointerValues src IplImage!
			w: srcS/width
			h: srcS/height
			dst: cvCloneImage src
			hsv: cvCloneImage src
			gray: cvCreateImage w h 8 1
			cvCvtColor src gray CV_BGR2GRAY
			sum: cvCreateMat (h + 1) (w + 1) CV_64FC1
			sumS: getPointerValues sum CvMat!
			wsize: sumS/step / sumS/cols
			sqsum: cvCreateMat h + 1 w + 1 CV_64FC1
			cvIntegral gray sum sqsum none
			cvtoRebol src rimage1
			cvtoRebol dst rimage2
			isFile: true	
		]
		[Alert "Not an image" ]
	]
]


process: does [
	cvZero dst
	if cb1/data [dst: cvCloneImage src]
	cvtoRebol dst rimage2
	sumS: getPointerValues sum CvMat!
	if error? try [thresh: to-integer dt/text] [thresh: 127]
	if error? try [boxW: to-integer dw/text] [boxW: 60]
	if error? try [boxH: to-integer dh/text] [boxH: 20]
	
	start: now/time/precise
	for y boxH (h - 1) 1 [
		sb/text: join "Processing line " y
		show sb
		for x boxW (w - 1) 1 [
			scal: cvGetReal2D sum y x
			scal1: cvGetReal2D sum (y - boxH) (x - boxW)
			scal2: cvGetReal2D sum (y - boxH) x
			scal3: cvGetReal2D  sum y (x - boxW)
            valeur: scal + scal1 - scal2 - scal3
            valeur: valeur / (boxW * boxH)
            ;print valeur 
            ; process background or not
            either cb2/data [
            	if valeur > thresh [
				cvRectangle dst x - boxW y - boxH x y 0.0 255.0 0.0 0.0 1 8 0
				]]
            [if valeur <= thresh [
				cvRectangle dst x - boxW y - boxH x y 0.0 0.0 255.0 0.0 1 8 0
			]]	
		]
		cvtoRebol dst rimage2 
		wait 0
		if stopRequired [exit]
	]
	end: now/time/precise
	sb/text: join "Done in " end - start
	show sb
	
]


mainWin: [
at 1x1 
	button 20 "Load Image" [loadImage]
	text 20  "Color Space" 
	dp1: drop-list 28 "CV_HSV2RGB" data colorSpace [
		colorS: get to word! face/text
		if isFile [
			cvCvtColor src hsv colorS
			cvCvtColor hsv gray CV_BGR2GRAY
			cvIntegral gray sum sqsum none
			cvtoRebol hsv rimage1
		]
	]
	button 18 "Source" [
		if isFile [
			cvCvtColor src gray CV_BGR2GRAY
			cvIntegral gray sum sqsum none
			cvtoRebol src rimage1
		]
	]
	cb1: check "Back" 15
	Field 20 "Threshold" options [info] 
	dt: Field 10 "127" [if error? try [thresh: to-integer dt/text] [thresh: 127]]
	Field 17 "Box [w h]"  options [info]
	dw: Field 10 "5" [if error? try [boxW: to-integer dw/text if boxW <= 0 [boxW: 1]] [boxW: 60]]
	dh: Field 10 "5" [if error? try [boxH: to-integer dh/text if boxH <= 0 [boxH: 1]] [boxH: 20]]
	cb2: check "Background"
	
	button 18 "Process" [stopRequired: false if isFile [process]]
	button 18 "Halt" [stopRequired: true ]
	button 15 "Quit" [if isFile [free-mem src free-mem gray free-mem dst freeDylib] quit]
at 1x10
	panel data [
		at 0x0 
			rimage1: image 128x128 tip "Source Image"
			splitter 1x128
			rimage2: image 128x128 tip "Destination Image"
	]
	return
			sb: field 270
]




display "HumaNum 2015" mainWin
do-events