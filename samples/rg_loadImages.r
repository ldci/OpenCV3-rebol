#! /usr/local/bin/rebol
REBOL [
	title: "Load Images with OpenCV "
]
do %../opencv.r
set 'appDir what-dir 


set 'appDir what-dir 

guiDir: join appDir "_RebGui/" 
do to-file join guiDir "rebgui.r"


isImage: false
iscolor: CV_LOAD_IMAGE_UNCHANGED


bloc: copy []


cvImage: make object![
	;variables
	x: make integer! 0
	y: make integer! 0
	windowsName: make string! ""
	img: none
	
	;methodes
    init: make function! [v1 v2 v3] [
    	x: 		v1
    	y: 		v2
    	windowsName: v3
    ]
    cvload: func [color] [
    	img: cvLoadImage windowsName color 
    	imgS: getPointerValues img IplImage!
	]
    
    cvShow: does [
    	cvNamedWindow windowsName CV_WINDOW_AUTOSIZE
    	cvResizeWindow windowsName 512 512
    	cvMoveWindow windowsName x y
    	cvShowImage windowsName img
    ]
    
    
    
    cvInfo: func [console] [
        str: copy third imgS ; values changed by routines are here
        str: skip str 48 ; looking for an eventual modification of roi address
        ptr: to-integer reverse copy/part str 4
        ;Roi exists
        if ptr <> 0 [roiValues: get-memory to-integer p 20
        	coi: to-integer copy/part roiValues 4
        	roiValues: skip roiValues 4
        	xOffset: to-integer copy/part roiValues 4
        	roiValues: skip roiValues 4
        	yOffset: to-integer copy/part roiValues 4
        	roiValues: skip roiValues 4
        	width: to-integer copy/part roiValues 4
        	roiValues: skip roiValues 4
        	height: to-integer copy/part roiValues 4
        ]
        ; No Roi 
        if ptr = 0 [
            imgS/roi: none
        	coi: 0
        	xOffset: 0
        	yOffset: 0
        	width: imgS/width 
        	height: imgS/height 
        
        ]
        ;  Image/tileInfo changed? 
        str: skip str 8
        ptr: to-integer reverse copy/part str 4
        tileInfo: ptr 
      	if tileInfo = 0 [imgS/tileInfo: none ]
      	if tileInfo <> 0 [
      		iplCallback: none
      		id: none
      		tileData: none
      		width: 0
      		height: 0
      	]
      	
        
    	console/text: ""
		console/text:  rejoin [ "image size: " imgS/nSize newline]
		append console/text rejoin [ "image ID: " imgS/ID newline]
		append console/text rejoin [ "image nChannels: " imgS/nChannels newline]
		append console/text rejoin [ "image alphaChannel: " imgS/alphaChannel newline]
		append console/text rejoin [ "image depth: " imgS/depth newline]
		append console/text rejoin [ "image color model: " imgS/cm0 imgS/cm1 imgS/cm2 imgS/cm3 newline] ; imgS/ColorModel Ignored by OpenCV
		append console/text rejoin [ "image channel Seq: " imgS/cs0 imgS/cs1 imgS/cs2 imgS/cs3 newline] ; imgS/channelSeq Ignored by OpenCV 
		append console/text rejoin [ "image data order: " imgS/dataOrder newline]
		append console/text rejoin [ "image origin: " imgS/origin newline]
		append console/text rejoin [ "image align: " imgS/align newline]
		append console/text rejoin [ "image width: " imgS/width newline]
		append console/text rejoin [ "image height: " imgS/height newline]
		append console/text rejoin [ "image roi: "  imgS/roi newline]
		append console/text rejoin [ "image ROI/coi: "    coi newline]
		append console/text rejoin [ "image ROI/xOffset: "    xOffset newline]
		append console/text rejoin [ "image ROI/yOffset: "    yOffset newline]
		append console/text rejoin [ "image ROI/width: "    width newline]
		append console/text rejoin [ "image ROI/height: "    height newline]
		append console/text rejoin [ "image mask ROI: " imgS/maskROI newline]
		append console/text rejoin [ "image imageID: " imgS/imageID newline]
		append console/text rejoin [ "image tileInfo: " imgS/tileInfo newline]
		append console/text rejoin [ "image size: " imgS/imageSize newline]
		append console/text rejoin [ "image data: " imgS/imageData newline]
		append console/text rejoin [ "image widthStep: " imgS/widthStep newline]
		append console/text rejoin [ "image borderMode: "  imgS/bm0 imgS/bm1 imgS/bm2 imgS/bm3 newline] ;imgS/borderMode Ignored by OpenCV" 
		append console/text rejoin [ "image borderConst: " imgS/bc0  imgS/bc1 imgS/bc2 imgS/bc3 newline] ;imgS/borderConstIgnored by OpenCV" 
		append console/text rejoin [ "image imageDataOrigin: " imgS/imageDataOrigin newline]
		show console
    ]
    
    cvtoRebol: func [dest] [
       	t1: now/time/precise
       
       	rgb: copy #{}									; make a binary 
		for y 0 imgS/height - 1 1 [
			index: y * imgS/widthStep 					; go to line y and get data
			line: get-memory (imgS/imageData + index) (imgS/width * imgS/nChannels)  
			append tail rgb line
		]
       
       	; mow makes the REBOL image
    	dest/image: make image! reduce [as-pair (imgS/width) (imgS/height) reverse rgb] 
    	dest/effect: [fit flip 1x1] ;
		show dest
		t2: now/time/precise
		duree: t2 - t1
		h: (first duree) * 3600 ; heure en seconde 
		m: (second duree) * 60 ; minute en sec
		s: round/to (third duree) 0.001; sec et ms 
		elapsed: h + m + s
		sb/text: join "Conversion done in " [elapsed * 1000 " msec"]
		show sb
    ]  
]


loadImage: does [
    cvDestroyAllWindows
	temp: request-file 
	if not none? temp [
		fl: flash "Converting cvImage to Rebol image"
		wait 0.1
		ima: make cvImage []
		ima/init 300 300 to-string to-local-file to-string temp
		ima/cvLoad iscolor
		ima/cvShow
		ima/cvInfo console
		rimage/image: load ""
		show rimage
		
		
		ima/cvtoRebol rimage
		unview/only fl
		]
]


setColor: does [
	switch flag/text [
		"As is" [iscolor: CV_LOAD_IMAGE_UNCHANGED]
		"3-channel color"  [iscolor: CV_LOAD_IMAGE_COLOR]
		"Grayscale" [iscolor: CV_LOAD_IMAGE_GRAYSCALE]
	]
]

	
mainWin: [
	at 1x1 
	button 25 "Load Image" [loadImage]
	flag: drop-list 30 "As is" data [ "As is" "3-channel color" "Grayscale"] [setColor]
	button 25 "Quit" [quit]
	at 1x10 
	console: area 75x128 options []
	rimage: image 128x128 black
	return
	sb: field options [info] 206
]



display "Load Images with OpenCV" mainWin
do-events 
