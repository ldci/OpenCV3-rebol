REBOL [
	Title:		"OpenCV Binding: video_c"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2015 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

CV_LKFLOW_PYR_A_READY:       1
CV_LKFLOW_PYR_B_READY:       2
CV_LKFLOW_INITIAL_GUESSES:   4
CV_LKFLOW_GET_MIN_EIGENVALS: 8


;************************************ optical flow ***************************************

{It is Lucas & Kanade method, modified to use pyramids.
   Also it does several iterations to get optical flow for
   every point at every pyramid level.
   Calculates optical flow between two images for certain set of points (i.e.
   it is a "sparse" optical flow, which is opposite to the previous 3 methods)}
   
cvCalcOpticalFlowPyrLK: cvFunc [
	"Calculates optical flow between two images"
	prev 			[ptr!] 
	curr 			[ptr!]
	prevPyr 		[ptr!]
	currPyr 		[ptr!]
	prevFeatures	[ptr!]	
	currFeatures	[ptr!]
	count			[integer!]
	w				[integer!]
	h				[integer!]
	level			[integer!]
	status			[string!]
	track_error		[ptr!]
	criteria		[ptr!]
	flags			[integer!]
] video "cvCalcOpticalFlowPyrLK"

;(region can be selected by setting ROIs and/or by composing a valid gradient mask
;with the region mask) 

;double 	cvCalcGlobalOrientation (const CvArr *orientation, const CvArr *mask, const CvArr *mhi, double timestamp, double duration)


cvEstimateRigidTransform: cvFunc [
	"Estimate rigid transformation between 2 images or 2 point sets"
	A				[ptr!]
	B				[ptr!]
	M				[ptr!]	;ptr!
	full_affine		[integer!]
	return:			[integer!]
] video "cvEstimateRigidTransform"


cvCalcOpticalFlowFarneback: cvFunc [
	"Estimate optical flow for each pixel using the two-frame G. Farneback algorithm"
	prev 			[ptr!] 
	curr 			[ptr!]
	flow 			[ptr!]
	pyr_scale		[decimal!]
	levels			[integer!]
	winsize			[integer!]
	iterations		[integer!]
	poly_n			[integer!]
	poly_sigma		[decimal!]
	flags			[integer!]
] video "cvCalcOpticalFlowFarneback"

;********************************* motion templates *************************************
{****************************************************************************************\
*        All the motion template functions work only with single channel images.         *
*        Silhouette image must have depth IPL_DEPTH_8U or IPL_DEPTH_8S                   *
*        Motion history image must have depth IPL_DEPTH_32F,                             *
*        Gradient mask - IPL_DEPTH_8U or IPL_DEPTH_8S,                                   *
*        Motion orientation image - IPL_DEPTH_32F                                        *
*        Segmentation mask - IPL_DEPTH_32F                                               *
*        All the angles are in degrees, all the times are in milliseconds                *
****************************************************************************************}






;****************************************************************************************
;*                                       Tracking                                       *
;****************************************************************************************

;determines object position, size and orientation from the object histogram back project (extension of meanshift)

cvCamShift: cvFunc [
	"Implements CAMSHIFT algorithm"
	prob_image	[ptr!]
	window_x	[integer!]	; cvRect (structure)
	window_y	[integer!]
	window_w	[integer!]
	window_h	[integer!]  ; end cvRect
	ctype		[integer!] 	; CvTermCriteria may be combination of  CV_TERMCRIT_ITER CV_TERMCRIT_EPS
	max_iter	[integer!]	
	epsilon		[decimal!]	; end CvTermCriteria
	comp		[ptr!]		; CvConnectedComp*
	box			[ptr!]		; CvBox2D*
	return:		[integer!]
] video "cvCamShift"

; - determines object position from the object histogram back project

cvMeanShift: cvFunc [
	"Implements MeanShift algorithm"
	prob_image	[ptr!]
	window_x	[integer!]	; cvRect (structure)
	window_y	[integer!]
	window_w	[integer!]
	window_h	[integer!]  ; end cvRect
	ctype		[integer!] 	; CvTermCriteria may be combination of  CV_TERMCRIT_ITER CV_TERMCRIT_EPS
	max_iter	[integer!]	
	epsilon		[decimal!]	; end CvTermCriteria
	comp		[ptr!]		; CvConnectedComp*
	return:		[integer!]
] video "cvMeanShift" 

;standard Kalman filter (in G. Welch' and G. Bishop's notation):
;x(k)=A*x(k-1)+B*u(k)+w(k)  p(w)~N(0,Q)
;z(k)=H*x(k)+v(k),   p(v)~N(0,R)
;struct CvKalman is not defined here see tracking.ppp 
 
cvCreateKalman: cvFunc [
	"Creates Kalman filter and sets A, B, Q, R and state to some initial values"
	dynam_params		[integer!]
	measure_params		[integer!]
	control_params		[integer!]	;CV_DEFAULT(0)
	return:				[ptr!] 		;CvKalman*
] video "cvCreateKalman" 

; WARNING: in rebol best way : free-mem kalman structure!
cvReleaseKalman: cvFunc [
	"Releases Kalman filter state"
	kalman				[ptr!] ; pointer of pointer (CvKalman**)
] video "cvReleaseKalman"


cvKalmanPredict: cvFunc [
	"Updates Kalman filter by time (predicts future state of the system)"
	kalman			[ptr!]		;CvKalman*
	control			[ptr!]	;CvMat CV_DEFAULT(NULL)		
	return:			[ptr!]	;CvMat*
] video "cvKalmanPredict" 

;
cvKalmanCorrect: cvFunc [
	"Updates Kalman filter by measurement (corrects state of the system and internal matrices)"
	kalman			[ptr!]		;CvKalman*
	measurement		[ptr!]
	return:			[ptr!]	;CvMat*
] video "cvKalmanCorrect" 

; alternative 
cvKalmanUpdateByTime: cvFunc [
	kalman			[ptr!]		;CvKalman*
	control			[ptr!]	; CvMat CV_DEFAULT(NULL)		
	return:			[ptr!]	;CvMat*
] video "cvKalmanPredict" 

cvKalmanUpdateByMeasurement: cvFunc [
	kalman			[ptr!]		;CvKalman*
	measurement		[ptr!]
	return:			[ptr!]	;CvMat*
] video "cvKalmanCorrect" 



