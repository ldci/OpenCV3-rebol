#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV Tests: Pyramid Segmentation"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
do %../opencv.r
set 'appDir what-dir 

guiDir: join appDir "_RebGui/" 
do to-file join guiDir "rebgui.r"


isFile: false

threshold1: 255 st1: to-string threshold1
threshold2: 30	st2: to-string threshold2
level: 4
block_size: 1000


comp: make struct! CvSeq! none
&comp: &pointer comp

ON_SEGMENT: does [
    ct1/text: to-string threshold1
    ct2/text: to-string threshold2
    show [ct1 ct2]
    if isFile [
    	; doesn't exist in OpenCV 3.0
    	;cvPyrSegmentation image0 image1 storage &comp level threshold1 + 1 threshold2 + 1
    	cvtoRebol image1 rimage2
    ]
]


loadImage: does [
	isFile: false
	temp: request-file 
	if not none? temp [
	 	filename: to-string to-local-file to-string temp
		if error? try [
		    ; load image
			image: cvLoadImage filename CV_LOAD_IMAGE_COLOR;CV_LOAD_IMAGE_UNCHANGED
			imageS: getPointerValues image IplImage!
			;show rebol image
			cvtoRebol image rimage1 
			
			imSize/text: join imageS/width [ " " imageS/height] 
			show imSize
			
			imageS/width: imageS/width and negate shift/left 1 level
			imageS/height: imageS/height and negate shift/left 1 level
			
			imSizeC/text: join imageS/width [ " " imageS/height] 
			show imSizeC
			
			image0: cvCloneImage image
			
			; better create output than cvCloneImage image
			image1: cvCreateImage imageS/width imageS/height IPL_DEPTH_8U 3
			
			
			storage: cvCreateMemStorage block_size
		
    		isFile: true
			sl1/data: 1
			sl2/data: .33
			show [sl1 sl2] 
			;ON_SEGMENT
		]
		[Alert "Non supported image" ]
	]
]


release: does [
	if isFile [
		free-mem image
		free-mem image0
		free-mem image1
		free-mem storage 
		freeDylib
	]
	
]

	
mainWin: [
	at 1x1 
	button 25 "Load Image" [loadImage]
	imSize: field 30 font [align: 'center]
	imSizeC: field 30 font [align: 'center]
	pad 148
	button 25 "Quit" [release quit]
	at 1x8 
	text 25 "Threshold 1" sl1: slider 213x5 [threshold1: round (sl1/data * 255) ON_SEGMENT] 
	ct1: field 20 st1 font [align: 'center]
	at 1x15 
	text 25 "Threshold 2" sl2: slider 213x5 [threshold1: round (sl2/data * 255) ON_SEGMENT] 
	ct2: field 20 st2 font [align: 'center]
	return
	panel data [
		rimage1: image 128x128 tip "Source Image"
		splitter 1x128
		rimage2: image 128x128 tip "Destination Image"
	]	
]

display "OpenCV Tests: Pyramid Segmentation" mainWin
do-events