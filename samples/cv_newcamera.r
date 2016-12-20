#! /usr/local/bin/rebol
REBOL [
	
]
;C++ Camera lib made with Xcode. Fine !
; for windows users

do %../opencv.r

openCamera 0
print lf
print ["camera size : " getCameraProperty 3]
print ["camera size : " getCameraProperty 4]
setCameraProperty  3 640.00
setCameraProperty  4 480.00

print ["camera size now : " getCameraProperty 3]
print ["camera size now : " getCameraProperty 4]

rep: grabFrame
print ["Frame Captured?  " to-logic rep]
img: readCamera
print ["Image Pointer " img]
cvNamedWindow "test" 0
cvShowImage "test" img

rep: 0
	while [rep <> 113] [
		img: readCamera
		cvShowImage "test" img
		rep: cvWaitkey 40
	]
cvWaitKey 0
releaseCamera