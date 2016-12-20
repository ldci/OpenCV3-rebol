#! /usr/local/bin/rebol
REBOL [
	Title:		"OpenCV Tests: Stat functions "
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2016 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
do %../opencv.r
set 'appDir what-dir 

wName2: "Image 8b"
wName22: "Image 32b"
i8B: cvCreateImage 512 512 IPL_DEPTH_8U 1
i32B: cvCreateImage 512 512 IPL_DEPTH_32F 1

p1: cvScalar 100 0 0 0
p2: cvScalar random 255  random 255 random 255 random 255

ptr: pointer 'integer! random 255
&ptr: struct-address? ptr

cvRandArr &ptr i8B CV_RAND_NORMAL p1/v0 p1/v1 p1/v2 p1/v3 p2/v0 p2/v1 p2/v2 p2/v3

cvShowImage wName2 i8B

cvSetImageCOI i8B 0 ; all channels 
print ["Non Zero values: " cvCountNonZero i8B]
m: make struct! cvScalar! none
sd: make struct! cvScalar! none

cvAvgSdv i8B &pointer m &pointer sd none
print ["Mean: " m/v0 ]
print ["STD: " sd/v0]

min_val: pointer 'decimal! 0.0
max_val: pointer 'decimal! 0.0

min_loc: make struct! CvPoint! reduce [0 0]
max_loc: make struct! CvPoint! reduce [0 0]

cvMinMaxLoc i8B &pointer min_val &pointer max_val &pointer min_loc &pointer max_loc none
print ["Mini: " min_val/value " at " min_loc/x " " min_loc/y]
print ["Max: " max_val/value " at " max_loc/x " " max_loc/y ]

print ["Calculated norm: " cvNorm i8B none CV_L2 none]
cvNormalize i8B i32B 1.0 0.0 CV_L2 none
cvShowImage wName22 i32B

cvWaitKey 0
print "Done"
free-mem i8B
free-mem i32B
freeDylib