REBOL[
	Title:		"OpenCV Binding: core"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2015 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; we include here some REBOL functions easier than original opencv func

; call c fonctions
do %imgproc_c.r


; cvLine rebol  version
rcvLine: func [ptr start [pair!] end [pair!] color [tuple!] thickness [integer!] lineType [integer!] offset [integer!] 
/local r g b a]
[ tmp: tocvRGB color r: tmp/1 g: tmp/2 b: tmp/3 a: tmp/4
  cvLine ptr start/x start/y end/x end/y r g b a thickness lineType offset
]

;rebol version
rcvRectangle: func [ptr start [pair!] end [pair!] color [tuple!] thickness [integer!] lineType [integer!] offset [integer!]
/local r g b a]
[ tmp: tocvRGB color r: tmp/3 g: tmp/2 b: tmp/1 a: tmp/4
  cvRectangle ptr start/x start/y end/x end/y r g b a thickness lineType offset
]
;rebol version
rcvCircle: func [ptr center [pair!] radius [integer!] color [tuple!] thickness [integer!] lineType [integer!] offset [integer!] 
/local r g b a] 
[ tmp: tocvRGB color r: tmp/3 g: tmp/2 b: tmp/1 a: tmp/4
  cvCircle ptr center/x center/y radius r g b a thickness lineType offset
]

; rebol version
rcvEllipse: func [ptr center [pair!] axes [pair!] angle [number!] start_angle [number!] end_angle [number!] color [tuple!] thickness [integer!] lineType [integer!] offset [integer!]
/local r g b a] 
[  tmp: tocvRGB color r: tmp/3 g: tmp/2 b: tmp/1 a: tmp/4
  cvEllipse ptr center/x center/y axes/x axes/y to-decimal angle to-decimal start_angle to-decimal end_angle r g b a thickness lineType offset
]

; rebol version using a block of pairs as parameter
rcvFillConvexPoly: func [ptr pts [block!] color [tuple!] lineType [integer!] offset [integer!] 
/local r g b a ]
[
	tmp: tocvRGB color r: tmp/3 g: tmp/2 b: tmp/1 a: tmp/4
	;how to pass an array of coords as a pointer to cvFillConvexPoly
	npts: length? pts 
	points: make binary! 2 * npts * sizeof 'integer!
	; y first then x
	foreach p pts [insert points convert second p insert points convert first p]
	&pts:  string-address? points ; pointer to array
	cvFillConvexPoly  ptr &pts npts r g b a  lineType offset
]

; cvFillPoly is rather complicated to use with rebol: pointer of pointers! 
; rcvFillPoly does the same job with a repetition of cvFillConvexPoly according to the  numbers of polygons to be drawn
rcvFillPoly:  func [ptr polygons [block!] color [tuple!] lineType [integer!] offset [integer!] 
/local r g b a]
[
	tmp: tocvByteRGB/signed color r: tmp/3 g: tmp/2 b: tmp/1 a: tmp/4
	foreach p polygons [
			npts: length? p ; nbr of vertices in the polygon 
			points: make binary! 2 * npts * sizeof 'integer!
			foreach pp p [insert points convert second pp insert points convert first pp] ; make the array of coordinates in binary
			&pts:  string-address? points ; pointer to array of binary (returns an integer!) 
			cvFillConvexPoly  ptr &pts npts r g b a  lineType offset ; draw polygon
	]
]
; idem uses cvLine to make polygons
rcvPolyLine: func [ptr lines [block!] isClosed [logic!] color [tuple!] thickness [integer!] lineType [integer!] offset [integer!] 
/local r g b a ]
[
	tmp: tocvByteRGB/signed color r: tmp/3 g: tmp/2 b: tmp/1 a: tmp/4
	nbofLines: to-integer length? lines
	; transforms pair! in 2 integers
	coords: copy []
	foreach l lines [
		bloc: copy []
		val: first l
		append bloc val/x
		append bloc val/y
	    append/only coords bloc
	]
	
	; if isClosed closes the polygon 
	either isClosed [lastPoint: nbofLines] [lastPoint: nbofLines - 1] 
	
	; get starting and ending point for each lines
	for i 1 lastPoint 1 [
		val1: coords/(i)
		val2: coords/(i + 1)
		if i = nbofLines [val2: coords/1]
		cvLine ptr first val1 second val1 first val2 second val2 r g b a thickness lineType offset
	]
]

; OK returns 0
rcvClipLine: func [size [pair!] pt1 [pair!] pt2 [pair!]] [
	w: first size
	h: second size
	; creates pointers to cvPoint
	*pt1: make binary! 2 * sizeof 'integer!
	insert *pt1 convert second pt1 insert *pt1 convert first pt1
	&pt1: string-address? *pt1
	*pt2: make binary! 2 * sizeof 'integer!
	insert *pt2 convert second pt2 insert *pt2 convert first pt2
	&pt2: string-address? *pt2
	ret: cvClipLine w h &pt1 &pt2
	return ret
]