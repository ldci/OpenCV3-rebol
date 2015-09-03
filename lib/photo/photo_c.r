REBOL [
	Title:		"OpenCV Binding: photo_c"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2015 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


;Inpainting algorithms
CV_INPAINT_NS: 		0
CV_INPAINT_TELEA:	1


;Inpaints the selected region in the image


cvInpaint: cvFunc [
	src				[ptr!] 
	inpaint_mask	[ptr!]
	dst				[ptr!]	
	inpaintRange	[decimal!]
	flags			[integer!]
] photo "cvInpaint"


