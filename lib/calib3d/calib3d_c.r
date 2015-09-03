#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV Binding: calib3D"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2015 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;                      Camera Calibration, Pose Estimation and Stereo                   

cvCreatePOSITObject: cvFunc [
	"Allocates and initializes CvPOSITObject structure before doing cvPOSIT"
	points		[ptr!] 		;CvPoint3D32f*
	point_count	[integer!]
	return: 	[ptr!]		;CvPOSITObject*
] calib3d "cvCreatePOSITObject" 

;Runs POSIT (POSe from ITeration) algorithm for determining 3d position of
;an object given its model and projection in a weak-perspective case */
cvPOSIT: cvFunc [
	"Runs POSIT (POSe from ITeration) algorithm "
	posit_object		[ptr!]		;CvPOSITObject*
	image_points		[ptr!]		;CvPoint2D32f*
	focal_length		[decimal!]
	ctype				[integer!] 	;CvTermCriteria struct non pointer
	max_iter			[integer!]	;CvTermCriteria
	epsilon				[decimal!]	;CvTermCriteria end of struct
	rotation_matrix		[ptr!]		;float*
	translation_vector	[ptr!]		;float*
] calib3d "cvPOSIT"

cvReleasePOSITObject: cvFunc [
	"Releases CvPOSITObject structure"
	posit_object	[ptr!] ;CvPOSITObject**
] calib3d "cvReleasePOSITObject" 

cvRANSACUpdateNumIters: cvFunc [
	"updates the number of RANSAC iterations"
	p				[decimal!]
	err_prob		[decimal!]
	model_points	[integer!]
	max_iters		[integer!]
	return:			[integer!]
] calib3d "cvRANSACUpdateNumIters"

cvConvertPointsHomogeneous: cvFunc [
	src			[ptr!] ; cvMat
	dst			[ptr!] ; cvMat
] calib3d "cvConvertPointsHomogeneous"

; */

CV_FM_7POINT: 1
CV_FM_8POINT: 2
CV_LMEDS: 4
CV_RANSAC: 8
CV_FM_LMEDS_ONLY:  CV_LMEDS
CV_FM_RANSAC_ONLY: CV_RANSAC
CV_FM_LMEDS: CV_LMEDS
CV_FM_RANSAC: CV_RANSAC

CV_ITERATIVE: 0
CV_EPNP: 1;F.Moreno-Noguer, V.Lepetit and P.Fua "EPnP: Efficient Perspective-n-Point Camera Pose Estimation"
CV_P3P: 2;X.S. Gao, X.-R. Hou, J. Tang, H.-F. Chang; "Complete Solution Classification for the Perspective-Three-Point Problem"

cvFindFundamentalMat: cvFunc [	
	"Calculates fundamental matrix given a set of corresponding points"
	points1				[ptr!] ;cvMat
	points2				[ptr!] ;cvMat
	fundamental_matrix	[ptr!] ;cvMat
	method				[integer!]		;CV_DEFAULT(CV_FM_RANSAC 
	param1				[decimal!]		;CV_DEFAULT(3.)
	param2				[decimal!]		;CV_DEFAULT(0.99)
	status				[ptr!] 			;cvMat CV_DEFAULT(NULL)
	return:				[integer!]
] calib3d "cvFindFundamentalMat" 


;For each input point on one of images computes parameters of the corresponding 
; epipolar line on the other image

cvComputeCorrespondEpilines: cvFunc [
	"computes parameters of the corresponding epipolar line"
	points				[ptr!] ;cvMat
	which_image			[integer!]
	fundamental_matrix	[ptr!] ;cvMat
	correspondent_lines	[ptr!] ;cvMat	
] calib3d "cvComputeCorrespondEpilines" 

cvTriangulatePoints: cvFunc [
	"Triangulation functions "
	projMatr1		[ptr!] ;cvMat
	projMatr2		[ptr!] ;cvMat
	projPoints1		[ptr!] ;cvMat
	projPoints2		[ptr!] ;cvMat
	points4D		[ptr!] ;cvMat
] calib3d "cvTriangulatePoints" 

cvCorrectMatches: cvFunc [
	f				[ptr!] ;cvMat
	points1			[ptr!] ;cvMat
	points2			[ptr!] ;cvMat
	new_points1		[ptr!] ;cvMat
	new_points1		[ptr!] ;cvMat
] calib3d "cvCorrectMatches"

{Computes the optimal new camera matrix according to the free scaling parameter alpha:
alpha=0 - only valid pixels will be retained in the undistorted image
alpha=1 - all the source image pixels will be retained in the undistorted image}

cvGetOptimalNewCameraMatrix: cvFunc [
	"Computes the optimal new camera matrix"
	camera_matrix			[ptr!] 			;cvMat
	dist_coeffs				[ptr!] 			;cvMat
	image_size_w			[integer!]		;cvSize width
	image_size_h			[integer!]		;cvSize height
	alpha					[decimal!];
	new_camera_matrix		[ptr!] 			;cvMat		
	new_imag_size_w			[integer!]		;cvSize width CV_DEFAULT(0)
	new_imag_size_h			[integer!]		;cvSize height CV_DEFAULT(0)
	valid_pixel_ROI			[ptr!]			;CvRect* CV_DEFAULT(0)
	center_principal_point	[integer!]		;CV_DEFAULT(0)
] calib3d "cvGetOptimalNewCameraMatrix"

cvRodrigues2: cvFunc [
	"Converts rotation vector to rotation matrix or vice versa"
	src			[ptr!] 			;cvMat
	dst			[ptr!] 			;cvMat
	jacobian	[ptr!] 			;cvMat CV_DEFAULT(0)
] calib3d "cvRodrigues2" 

cvFindHomography: cvFunc [
	"Finds perspective transformation between the object plane and image (view) plane"
	src						[ptr!] 			;cvMat
	dst						[ptr!] 			;cvMat
	homography				[ptr!] 			;cvMat
	method					[integer!]		;CV_DEFAULT(0)
	ransacReprojThreshold	[decimal!]		;CV_DEFAULT(3)
	mask					[ptr!]			;cvMat CV_DEFAULT(0)
] calib3d "cvFindHomography"
	
cvRQDecomp3x3: cvFunc [
	"Computes RQ decomposition for 3x3 matrices"
	matrixM				[ptr!] 			;cvMat
	matrixR				[ptr!] 			;cvMat
	matrixQ				[ptr!] 			;cvMat
	matrixQx			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	matrixQy			[ptr!] 			;cvMat	CV_DEFAULT(NULL)
	matrixQz			[ptr!] 			;cvMat	CV_DEFAULT(NULL)
	eulerAngles			[ptr!]			; CvPoint3D64f CV_DEFAULT(NULL)
] calib3d "cvRQDecomp3x3"

cvDecomposeProjectionMatrix: cvFunc [
	"Computes projection matrix decomposition"
	projMatr			[ptr!] 			;cvMat
	calibMatr			[ptr!] 			;cvMat
	rotMatr				[ptr!] 			;cvMat
	posVect				[ptr!] 			;cvMat
	rotMatrX			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	rotMatrY			[ptr!] 			;cvMat	CV_DEFAULT(NULL)
	rotMatrZ			[ptr!] 			;cvMat	CV_DEFAULT(NULL)
	eulerAngles			[ptr!]			; CvPoint3D64f CV_DEFAULT(NULL)
] calib3d "cvDecomposeProjectionMatrix"

cvCalcMatMulDeriv: cvFunc [
	"Computes d(AB)/dA and d(AB)/dB"
	A					[ptr!] 			;cvMat
	B					[ptr!] 			;cvMat
	C					[ptr!] 			;cvMat
	dABdA				[ptr!] 			;cvMat
	dABdB				[ptr!] 			;cvMat
] calib3d "cvCalcMatMulDeriv"

cvComposeRT: cvFunc [
	"Computes r3 = rodrigues(rodrigues(r2)*rodrigues(r1)), t3 = rodrigues(r2)*t1 + t2 and the respective derivatives"
	_rvec1			[ptr!] 			;cvMat
	_tvec1			[ptr!] 			;cvMat
	_rvec2			[ptr!] 			;cvMat
	_tvec2			[ptr!] 			;cvMat
	_rvec3			[ptr!] 			;cvMat
	_tvec3			[ptr!] 			;cvMat
	dr3dr1			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dr3dt1			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dr3dr2			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dr3dt2			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dt3dr1			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dt3dt1			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dt3dr2			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dt3dt2			[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
] calib3d "cvComposeRT"

cvProjectPoints2: cvFunc [
	"Projects object points to the view plane using the specified extrinsic and intrinsic camera parameters"
	object_points			[ptr!] 			;cvMat
	rotation_vector			[ptr!] 			;cvMat
	translation_vector		[ptr!] 			;cvMat
	camera_matrix			[ptr!] 			;cvMat
	distortion_coeffs		[ptr!] 			;cvMat
	image_points			[ptr!] 			;cvMat
	dpdrot					[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dpdt					[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dpdf					[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dpdc					[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	dpddist					[ptr!] 			;cvMat 	CV_DEFAULT(NULL)
	aspect_ratio			[decimal!] 		; 	CV_DEFAULT(0)
] calib3d "cvProjectPoints2" 

cvFindExtrinsicCameraParams2: cvFunc [
	"Finds extrinsic camera parameters from a few known corresponding point pairs and intrinsic parameters"
   	object_points			[ptr!] 			;cvMat
   	image_points			[ptr!] 			;cvMat
   	camera_matrix			[ptr!] 			;cvMat
   	distortion_coeffs		[ptr!] 			;cvMat
   	rotation_vector			[ptr!] 			;cvMat
   	translation_vector		[ptr!] 			;cvMat
   	use_extrinsic_guess		[integer!]		;cvMat	
] calib3d "cvFindExtrinsicCameraParams2"

cvInitIntrinsicParams2D: cvFunc [
	"Computes initial estimate of the intrinsic camera parameters in case of planar calibration target (e.g. chessboard)"
	object_points			[ptr!] 			;cvMat
   	image_points			[ptr!] 			;cvMat
   	npoints					[ptr!] 			;cvMat
   	image_size_w			[integer!]		; cvSize
   	image_size_h			[integer!]
   	camera_matrix			[ptr!] 			;cvMat
   	aspect_ratio			[decimal!] 		; 	CV_DEFAULT(1.0)
] calib3d "cvInitIntrinsicParams2D"


CV_CALIB_CB_ADAPTIVE_THRESH:	  1
CV_CALIB_CB_NORMALIZE_IMAGE:	  2
CV_CALIB_CB_FILTER_QUADS:	      4
CV_CALIB_CB_FAST_CHECK:		      8

cvCheckChessboard: cvFunc [
	"Performs a fast check if a chessboard is in the input image"
	src			[ptr!]	;iplImage
	size_w		[integer!]		; cvSize
	size_y		[integer!]		; 
] calib3d "cvCheckChessboard"

cvFindChessboardCorners: cvFunc [
	"Detects corners on a chessboard calibration pattern"
	image				[ptr!]			;iplImage
	pattern_size_w		[integer!]		; cvSize
	pattern_size_y		[integer!]		; 
	corner_count		[ptr!]			; integer
	flags				[integer!]		;V_DEFAULT(CV_CALIB_CB_ADAPTIVE_THRESH+CV_CALIB_CB_NORMALIZE_IMAGE) )	
] calib3d "cvFindChessboardCorners"

cvDrawChessboardCorners: cvFunc [
	"Draws individual chessboard corners or the whole chessboard detected"
	image				[ptr!]			;iplImage
	pattern_size_w		[integer!]		; cvSize
	pattern_size_y		[integer!]		; 
	corners				[ptr!]			; CvPoint2D32f
	count				[integer!]
	pattern_was_found	[integer!]
] calib3d "cvDrawChessboardCorners"

 CV_CALIB_USE_INTRINSIC_GUESS:  1
 CV_CALIB_FIX_ASPECT_RATIO:     2
 CV_CALIB_FIX_PRINCIPAL_POINT:  4
 CV_CALIB_ZERO_TANGENT_DIST:    8
 CV_CALIB_FIX_FOCAL_LENGTH:		16
 CV_CALIB_FIX_K1:  				32
 CV_CALIB_FIX_K2:  				64
 CV_CALIB_FIX_K3:  				128
 CV_CALIB_FIX_K4:  				2048
 CV_CALIB_FIX_K5:  				4096
 CV_CALIB_FIX_K6:  				8192
 CV_CALIB_RATIONAL_MODEL: 		16384
 CV_CALIB_THIN_PRISM_MODEL: 	32768
 CV_CALIB_FIX_S1_S2_S3_S4:  	65536
 
 cvCalibrateCamera2: cvFunc [
 	"Finds intrinsic and extrinsic camera parameters from a few views of known calibration pattern"
 	object_points			[ptr!] 			;cvMat
   	image_points			[ptr!] 			;cvMat
   	point_counts			[ptr!] 			;cvMat
   	image_size_w			[integer!]		; cvSize
	image_size_y			[integer!]		; 
 	camera_matrix			[ptr!] 			;cvMat
   	distortion_coeffs		[ptr!] 			;cvMat
   	rotation_vectors		[ptr!] 			;cvMat CV_DEFAULT(NULL)
   	translation_vectors		[ptr!] 			;cvMat CV_DEFAULT(NULL)
   	flags					[integer!]		;CV_DEFAULT(0)
   	term_crit				[ptr!]			;CvTermCriteria
   	return:					[decimal!]
 ] calib3d "cvCalibrateCamera2"
 
 cvCalibrationMatrixValues: cvFunc [
 	"Computes various useful characteristics of the camera from the data computed by cvCalibrateCamera2"
 	camera_matrix			[ptr!] 			;cvMat
 	image_size_w			[integer!]		; cvSize
	image_size_y			[integer!]		; 
	aperture_width			[decimal!]
	aperture_height			[decimal!]
	fovx					[ptr!] 			;*double
	fovy					[ptr!] 			;*double
	focal_length			[ptr!] 			;*double
	principal_point			[ptr!] 			;CvPoint2D64f CV_DEFAULT(NULL)
	pixel_aspect_ratio		[ptr!] 			;*double	CV_DEFAULT(NULL)
 ] calib3d "cvCalibrationMatrixValues"
 
CV_CALIB_FIX_INTRINSIC:		  	256
CV_CALIB_SAME_FOCAL_LENGTH:		512

cvStereoCalibrate: cvFunc [
	"Computes the transformation from one camera coordinate system to another one"
	object_points			[ptr!] 			;cvMat
   	image_points1			[ptr!] 			;cvMat
   	image_points2			[ptr!] 			;cvMat
   	npoints					[ptr!] 			;cvMat
	camera_matrix1			[ptr!] 			;cvMat
   	distortion_coeffs1		[ptr!] 			;cvMat
   	camera_matrix2			[ptr!] 			;cvMat
   	distortion_coeffs2		[ptr!] 			;cvMat
   	image_size_w			[integer!]		; cvSize
	image_size_y			[integer!]		; 
	R						[ptr!] 			;cvMat
	T						[ptr!] 			;cvMat
	E						[ptr!] 			;cvMat  CV_DEFAULT(0)
	F						[ptr!] 			;cvMat	CV_DEFAULT(0)
	flags					[integer!]		;CV_DEFAULT(CV_CALIB_FIX_INTRINSIC)	
	term_crit				[ptr!]			;CvTermCriteria
	return:					[decimal!]
] calib3d "cvStereoCalibrate" 

CV_CALIB_ZERO_DISPARITY: 1024

cvStereoRectify: cvFunc [
	"Computes 3D rotations (+ optional shift) for each camera coordinate system"
	camera_matrix1			[ptr!] 			;cvMat
	camera_matrix2			[ptr!] 			;cvMat
	distortion_coeffs1		[ptr!] 			;cvMat
	distortion_coeffs2		[ptr!] 			;cvMat
	image_size_w			[integer!]		; cvSize
	image_size_y			[integer!]
	R						[ptr!] 			;cvMat
	T						[ptr!] 			;cvMat
	R1						[ptr!] 			;cvMat
	R2						[ptr!] 			;cvMat
	P1						[ptr!] 			;cvMat
	P2						[ptr!] 			;cvMat						
	Q						[ptr!] 			;cvMat  CV_DEFAULT(0)	
	flags					[integer!]		;CV_DEFAULT(CV_CALIB_ZERO_DISPARITY)
	alpha					[decimal!]		;CV_DEFAULT(-1)
	new_image_size_w		[integer!]		; cvSize 0x0
	new_image_size_y		[integer!]
	valid_pix_ROI1			[ptr!]			; CvRect
	valid_pix_ROI2			[ptr!]			; CvRect
] calib3d "cvStereoRectify"

cvStereoRectifyUncalibrated: cvFunc [
	"Computes rectification transformations for uncalibrated pair of images using a set of point correspondences"
	points1				[ptr!] 			;cvMat
	points2				[ptr!] 			;cvMat
	F					[ptr!] 			;cvMat
	image_size_w		[integer!]		; cvSize
	image_size_y		[integer!]
	H1					[ptr!] 			;cvMat
	H2					[ptr!] 			;cvMat
	threshold			[decimal!]		;
	return:				[integer!]
] calib3d "cvStereoRectifyUncalibrated"

CV_STEREO_BM_NORMALIZED_RESPONSE:  0
CV_STEREO_BM_XSOBEL:               1

 CvStereoBMState!: make struct! [
	preFilterType:			[integer!]
	preFilterSize:			[integer!]
	preFilterCap:			[integer!]
	SADWindowSize:			[integer!]
	minDisparity:			[integer!]
	numberOfDisparities:	[integer!]
	textureThreshold:		[integer!]
	uniquenessRatio:		[integer!]
	speckleWindowSize:		[integer!]
	speckleRange:			[integer!]
	trySmallerWindows:		[integer!]
	roi1_x					[integer!]	;CvRect
	roi1_y					[integer!]
	roi1_w					[integer!]
	roi1_H					[integer!]
	roi2_x					[integer!]	;CvRect
	roi2_y					[integer!]
	roi2_w					[integer!]
	roi2_H					[integer!]
	disp12MaxDiff:			[integer!]
	preFilteredImg0			[ptr!] 			;cvMat
	preFilteredImg1			[ptr!] 			;cvMat
	slidingSumBuf			[ptr!] 			;cvMat
	cost					[ptr!] 			;cvMat
	disp					[ptr!] 			;cvMat
] none
 
CV_STEREO_BM_BASIC:			 0
CV_STEREO_BM_FISH_EYE:		 1
CV_STEREO_BM_NARROW:		 2


cvCreateStereoBMState: cvFunc [
	"Creates block matching"
	preset:					[integer!] 	;CV_DEFAULT(CV_STEREO_BM_BASIC)
	numberOfDisparities:	[integer!] 	;CV_DEFAULT(0)
	return:					[ptr!]		;CvStereoBMState
] calib3d "cvCreateStereoBMState"

cvReleaseStereoBMState: cvFunc [
	"Releases block matching"
	state	[ptr!] ;CvStereoBMState** state 
] calib3d "cvReleaseStereoBMState"

cvFindStereoCorrespondenceBM: cvFunc [
	left				[ptr!] 			;CvArr
	right				[ptr!] 			;CvArr
	disparity			[ptr!] 			;CvArr
	state				[ptr!]		;CvStereoBMState
] calib3d "cvFindStereoCorrespondenceBM"

cvGetValidDisparityROI: cvFunc [
	roi1_x					[integer!]	;CvRect
	roi1_y					[integer!]
	roi1_w					[integer!]
	roi1_H					[integer!]
	roi2_x					[integer!]	;CvRect
	roi2_y					[integer!]
	roi2_w					[integer!]
	roi2_H					[integer!]
	minDisparity:			[integer!]
	preFilterCap:			[integer!]
	return:					[CvRect!]	
] calib3d "cvGetValidDisparityROI"

cvValidateDisparity: cvFunc [
	disparity				[ptr!] 			;CvArr
	cost					[ptr!] 			;CvArr
	minDisparity:			[integer!]
	numberOfDisparities:	[integer!]
	disp12MaxDiff:			[integer!]		;CV_DEFAULT(1)
] calib3d "cvValidateDisparity"

cvReprojectImageTo3D: cvFunc [
	disparityImage			[ptr!] 			;CvArr
	_3dImage				[ptr!] 			;CvArr
	Q						[ptr!] 	
	handleMissingValues		[integer!]		;CV_DEFAULT(0)
] calib3d "cvReprojectImageTo3D"

