#! /usr/bin/rebol
REBOL[
	Title:		"OpenCV cvtypes"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012 François Jouen. All rights reserved."
	License: {
		Redistribution and use in source and binary forms, with or without modification,
		are permitted provided that the following conditions are met:

		    * Redistributions of source code must retain the above copyright notice,
		      this list of conditions and the following disclaimer.
		    * Redistributions in binary form must reproduce the above copyright notice,
		      this list of conditions and the following disclaimer in the documentation
		      and/or other materials provided with the distribution.

		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
		ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
		WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
		DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
		FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
		DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
		SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
		CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
		OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
		OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	}
]


;**************************** Connected Component  **************************************
CvConnectedComp!: make struct! [
    area		[decimal!]	;area of the connected component
    v0 			[decimal!]  		; cvScalar!average color of the connected component
    v1			[decimal!]
    v2			[decimal!]
    v3			[decimal!]
    x 			[integer!]	;CvRect! ROI of the component
	y 			[integer!]
	width 		[integer!]
	height 		[integer!]		
    contour 	[int]		;Pointer CvRect!optional component boundary (the contour might have child contours corresponding to the holes)
] none

;Image smooth methods
CV_BLUR_NO_SCALE: 	0
CV_BLUR:  			1
CV_GAUSSIAN:  		2
CV_MEDIAN:			3
CV_BILATERAL:	 	4

;Filters used in pyramid decomposition
CV_GAUSSIAN_5x5:	7

;Special filters
CV_SCHARR:			-1,
CV_MAX_SOBEL_KSIZE:		7

;Constants for color conversion
CV_BGR2BGRA:    0
CV_RGB2RGBA:    CV_BGR2BGRA

CV_BGRA2BGR:    1
CV_RGBA2RGB:    CV_BGRA2BGR

CV_BGR2RGBA:    2
CV_RGB2BGRA:    CV_BGR2RGBA

CV_RGBA2BGR:    3
CV_BGRA2RGB:    CV_RGBA2BGR

CV_BGR2RGB:     4
CV_RGB2BGR:     CV_BGR2RGB

CV_BGRA2RGBA:   5
CV_RGBA2BGRA:   CV_BGRA2RGBA

CV_BGR2GRAY:    6
CV_RGB2GRAY:    7
CV_GRAY2BGR:    8
CV_GRAY2RGB:    CV_GRAY2BGR
CV_GRAY2BGRA:   9
CV_GRAY2RGBA:   CV_GRAY2BGRA
CV_BGRA2GRAY:   10
CV_RGBA2GRAY:   11

CV_BGR2BGR565:  12
CV_RGB2BGR565:  13
CV_BGR5652BGR:  14
CV_BGR5652RGB:  15
CV_BGRA2BGR565: 16
CV_RGBA2BGR565: 17
CV_BGR5652BGRA: 18
CV_BGR5652RGBA: 19

CV_GRAY2BGR565: 20
CV_BGR5652GRAY: 21

CV_BGR2BGR555:  22
CV_RGB2BGR555:  23
CV_BGR5552BGR:  24
CV_BGR5552RGB:  25
CV_BGRA2BGR555: 26
CV_RGBA2BGR555: 27
CV_BGR5552BGRA: 28
CV_BGR5552RGBA: 29

CV_GRAY2BGR555: 30
CV_BGR5552GRAY: 31

CV_BGR2XYZ:     32
CV_RGB2XYZ:     33
CV_XYZ2BGR:     34
CV_XYZ2RGB:     35

CV_BGR2YCrCb:   36
CV_RGB2YCrCb:   37
CV_YCrCb2BGR:   38
CV_YCrCb2RGB:   39

CV_BGR2HSV:     40
CV_RGB2HSV:     41

CV_BGR2Lab:     44
CV_RGB2Lab:     45

CV_BayerBG2BGR: 46
CV_BayerGB2BGR: 47
CV_BayerRG2BGR: 48
CV_BayerGR2BGR: 49

CV_BayerBG2RGB: CV_BayerRG2BGR
CV_BayerGB2RGB: CV_BayerGR2BGR
CV_BayerRG2RGB: CV_BayerBG2BGR
CV_BayerGR2RGB: CV_BayerGB2BGR

CV_BGR2Luv:     50
CV_RGB2Luv:     51
CV_BGR2HLS:     52
CV_RGB2HLS:     53

CV_HSV2BGR:     54
CV_HSV2RGB:     55

CV_Lab2BGR:     56
CV_Lab2RGB:     57
CV_Luv2BGR:     58
CV_Luv2RGB:     59
CV_HLS2BGR:     60
CV_HLS2RGB:     61

CV_BayerBG2BGR_VNG: 62
CV_BayerGB2BGR_VNG: 63
CV_BayerRG2BGR_VNG: 64
CV_BayerGR2BGR_VNG: 65

CV_BayerBG2RGB_VNG: CV_BayerRG2BGR_VNG
CV_BayerGB2RGB_VNG: CV_BayerGR2BGR_VNG
CV_BayerRG2RGB_VNG: CV_BayerBG2BGR_VNG
CV_BayerGR2RGB_VNG: CV_BayerGB2BGR_VNG

CV_BGR2HSV_FULL:  66
CV_RGB2HSV_FULL:  67
CV_BGR2HLS_FULL:  68
CV_RGB2HLS_FULL:  69

CV_HSV2BGR_FULL:  70
CV_HSV2RGB_FULL:  71
CV_HLS2BGR_FULL:  72
CV_HLS2RGB_FULL:  73

CV_LBGR2Lab:  74
CV_LRGB2Lab:  75
CV_LBGR2Luv:  76
CV_LRGB2Luv:  77

CV_Lab2LBGR:  78
CV_Lab2LRGB:  79
CV_Luv2LBGR:  80
CV_Luv2LRGB:  81

CV_BGR2YUV:  82
CV_RGB2YUV:  83
CV_YUV2BGR:  84
CV_YUV2RGB:  85

CV_BayerBG2GRAY:  86
CV_BayerGB2GRAY:  87
CV_BayerRG2GRAY:  88
CV_BayerGR2GRAY:  89

;YUV 4:2:0 formats family
CV_YUV2RGB_NV12:  90
CV_YUV2BGR_NV12:  91
CV_YUV2RGB_NV21:  92
CV_YUV2BGR_NV21:  93
CV_YUV420sp2RGB:  CV_YUV2RGB_NV21
CV_YUV420sp2BGR:  CV_YUV2BGR_NV21

CV_YUV2RGBA_NV12:  94
CV_YUV2BGRA_NV12:  95
CV_YUV2RGBA_NV21:  96
CV_YUV2BGRA_NV21:  97
CV_YUV420sp2RGBA:  CV_YUV2RGBA_NV21
CV_YUV420sp2BGRA:  CV_YUV2BGRA_NV21

CV_YUV2RGB_YV12:  98
CV_YUV2BGR_YV12:  99
CV_YUV2RGB_IYUV:  100
CV_YUV2BGR_IYUV:  101
CV_YUV2RGB_I420:  CV_YUV2RGB_IYUV
CV_YUV2BGR_I420:  CV_YUV2BGR_IYUV
CV_YUV420p2RGB:  CV_YUV2RGB_YV12
CV_YUV420p2BGR:  CV_YUV2BGR_YV12

CV_YUV2RGBA_YV12:  102
CV_YUV2BGRA_YV12:  103
CV_YUV2RGBA_IYUV:  104
CV_YUV2BGRA_IYUV:  105
CV_YUV2RGBA_I420:  CV_YUV2RGBA_IYUV
CV_YUV2BGRA_I420:  CV_YUV2BGRA_IYUV
CV_YUV420p2RGBA:  CV_YUV2RGBA_YV12
CV_YUV420p2BGRA:  CV_YUV2BGRA_YV12

CV_YUV2GRAY_420:  106
CV_YUV2GRAY_NV21:  CV_YUV2GRAY_420
CV_YUV2GRAY_NV12:  CV_YUV2GRAY_420
CV_YUV2GRAY_YV12:  CV_YUV2GRAY_420
CV_YUV2GRAY_IYUV:  CV_YUV2GRAY_420
CV_YUV2GRAY_I420:  CV_YUV2GRAY_420
CV_YUV420sp2GRAY:  CV_YUV2GRAY_420
CV_YUV420p2GRAY:  CV_YUV2GRAY_420

;YUV 4:2:2 formats family
CV_YUV2RGB_UYVY:  107
CV_YUV2BGR_UYVY:  108
//CV_YUV2RGB_VYUY:  109
//CV_YUV2BGR_VYUY:  110
CV_YUV2RGB_Y422:  CV_YUV2RGB_UYVY
CV_YUV2BGR_Y422:  CV_YUV2BGR_UYVY
CV_YUV2RGB_UYNV:  CV_YUV2RGB_UYVY
CV_YUV2BGR_UYNV:  CV_YUV2BGR_UYVY

CV_YUV2RGBA_UYVY:  111
CV_YUV2BGRA_UYVY:  112
;CV_YUV2RGBA_VYUY:  113
;CV_YUV2BGRA_VYUY:  114
CV_YUV2RGBA_Y422:  CV_YUV2RGBA_UYVY
CV_YUV2BGRA_Y422:  CV_YUV2BGRA_UYVY
CV_YUV2RGBA_UYNV:  CV_YUV2RGBA_UYVY
CV_YUV2BGRA_UYNV:  CV_YUV2BGRA_UYVY

CV_YUV2RGB_YUY2:  115
CV_YUV2BGR_YUY2:  116
CV_YUV2RGB_YVYU:  117
CV_YUV2BGR_YVYU:  118
CV_YUV2RGB_YUYV:  CV_YUV2RGB_YUY2
CV_YUV2BGR_YUYV:  CV_YUV2BGR_YUY2
CV_YUV2RGB_YUNV:  CV_YUV2RGB_YUY2
CV_YUV2BGR_YUNV:  CV_YUV2BGR_YUY2

CV_YUV2RGBA_YUY2:  119
CV_YUV2BGRA_YUY2:  120
CV_YUV2RGBA_YVYU:  121
CV_YUV2BGRA_YVYU:  122
CV_YUV2RGBA_YUYV:  CV_YUV2RGBA_YUY2
CV_YUV2BGRA_YUYV:  CV_YUV2BGRA_YUY2
CV_YUV2RGBA_YUNV:  CV_YUV2RGBA_YUY2
CV_YUV2BGRA_YUNV:  CV_YUV2BGRA_YUY2

CV_YUV2GRAY_UYVY:  123
CV_YUV2GRAY_YUY2:  124
;CV_YUV2GRAY_VYUY:  CV_YUV2GRAY_UYVY
CV_YUV2GRAY_Y422:  CV_YUV2GRAY_UYVY
CV_YUV2GRAY_UYNV:  CV_YUV2GRAY_UYVY
CV_YUV2GRAY_YVYU:  CV_YUV2GRAY_YUY2
CV_YUV2GRAY_YUYV:  CV_YUV2GRAY_YUY2
CV_YUV2GRAY_YUNV:  CV_YUV2GRAY_YUY2

;alpha premultiplication
CV_RGBA2mRGBA:  125
CV_mRGBA2RGBA:  126

CV_RGB2YUV_I420:  127
CV_BGR2YUV_I420:  128
CV_RGB2YUV_IYUV:  CV_RGB2YUV_I420
CV_BGR2YUV_IYUV:  CV_BGR2YUV_I420

CV_RGBA2YUV_I420:  129
CV_BGRA2YUV_I420:  130
CV_RGBA2YUV_IYUV:  CV_RGBA2YUV_I420
CV_BGRA2YUV_IYUV:  CV_BGRA2YUV_I420
CV_RGB2YUV_YV12:  131
CV_BGR2YUV_YV12:  132
CV_RGBA2YUV_YV12:  133
CV_BGRA2YUV_YV12:  134

CV_COLORCVT_MAX:  135

;Sub-pixel interpolation methods
CV_INTER_NN:        0
CV_INTER_LINEAR:    1
CV_INTER_CUBIC:     2
CV_INTER_AREA:      3

;and other image warping flags
CV_WARP_FILL_OUTLIERS: 8
CV_WARP_INVERSE_MAP:  16

;Shapes of a structuring element for morphological operations
CV_SHAPE_RECT:      0
CV_SHAPE_CROSS:     1
CV_SHAPE_ELLIPSE:   2
CV_SHAPE_CUSTOM:    100

; Morphological operations
CV_MOP_ERODE:		0
CV_MOP_DILATE:		1
CV_MOP_OPEN:         2
CV_MOP_CLOSE:        3
CV_MOP_GRADIENT:     4
CV_MOP_TOPHAT:       5
CV_MOP_BLACKHAT:     6         

;spatial and central moments
CvMoments!: make struct! [
	;/* spatial moments */ all values should be double
    m00: [decimal!]
    m10: [decimal!]
    m01: [decimal!]
    m20: [decimal!]
    m11: [decimal!]
    m02: [decimal!]
    m30: [decimal!]
    m21: [decimal!]
    m12: [decimal!]
    m03: [decimal!]
    ; /* central moments */ 
    mu20: [decimal!]
    mu11: [decimal!]
    mu02: [decimal!]
    mu30: [decimal!]
    mu21: [decimal!]
    mu12: [decimal!]
    mu03: [decimal!]
    inv_sqrt_m00: [decimal!]		; /* m00 != 0 ? 1/sqrt(m00) : 0 */
] none 

;Hu invariants
CvHuMoments!: make struct! [
    hu1: [decimal!] 
    hu2: [decimal!] 
    hu3: [decimal!] 
    hu4: [decimal!] 
    hu5: [decimal!] 
    hu6: [decimal!] 
    hu7: [decimal!] 
] none

;Template matching methods
CV_TM_SQDIFF:        0
CV_TM_SQDIFF_NORMED: 1
CV_TM_CCORR:         2
CV_TM_CCORR_NORMED:  3
CV_TM_CCOEFF:        4
CV_TM_CCOEFF_NORMED: 5

;typedef float (CV_CDECL * CvDistanceFunction)( const float* a, const float* b, void* user_param )

;contour retrieval mode
CV_RETR_EXTERNAL:			 0
CV_RETR_LIST:			     1
CV_RETR_CCOMP:			     2
CV_RETR_TREE:			     3

;contour approximation method
CV_CHAIN_CODE:               0
CV_CHAIN_APPROX_NONE:        1
CV_CHAIN_APPROX_SIMPLE:      2
CV_CHAIN_APPROX_TC89_L1:     3
CV_CHAIN_APPROX_TC89_KCOS:   4
CV_LINK_RUNS:                5


;Internal structure that is used for sequental retrieving contours from the image.
;It supports both hierarchical and plane variants of Suzuki algorithm

;typedef struct _CvContourScanner* CvContourScanner

;Freeman chain reader state 

;use array 8 lines 2 columns and pass as binary to the structure
_delta: array/initial [8 2] none
delta: to-binary mold _delta 

CvChainPtReader!: make struct! [
    csrf			[int] 		;CV_SEQ_READER_FIELDS!
    code			[char!]
    pt				[int]		;cvPoint!
    deltas			[binary!]	;un tableau deltas[8][2];
] none

;initializes 8-element array for fast access to 3x3 neighborhood of a pixel
CV_INIT_3X3_DELTAS: func [step [integer!] nch [integer!] /local deltas] [       
	deltas: array/initial 8 0
	deltas/1: nch
	deltas/2: negate step + nch
	deltas/3: negate step
	deltas/4: negate step - nch
	deltas/5: negate nch
	deltas/6: step - nch
	deltas/7: step
	deltas/8: step + nch
	return deltas
]


;************ Data structures and related enumerations for Planar Subdivisions ************/

CvSubdiv2DEdge: make integer! 4

CV_QUADEDGE2D_FIELDS!: make struct! [
	flags			[integer!]               
    pt_4			[int]		;pointer to struct CvSubdiv2DPoint* ];
    next_4          [int]   	;CvSubdiv2DEdge;
] none


CV_SUBDIV2D_POINT_FIELDS!: make struct!  [
    flags			[integer!]
    _first			[int] ;CvSubdiv2DEdge;
    pt              [int] ;CvPoint2D32f!
] none

CV_SUBDIV2D_VIRTUAL_POINT_FLAG:  Shift/left 1 30 

CvQuadEdge2D:func [edge]
[
    return (first CV_QUADEDGE2D_FIELDS!)
] 

CvSubdiv2DPoint!: make struct! [
    ptr		[int] ;CV_SUBDIV2D_POINT_FIELDS!
] none

CV_SUBDIV2D_FIELDS!: make struct! [ 
    ptr					[int] 		;CV_GRAPH_FIELDS!
    quad_edges			[integer!]         
    is_geometry_valid	[integer!]
    recent_edge			[integer!]
    topleft				[int] 		;CvPoint2D32f!
    bottomright			[int] 		;CvPoint2D32f!
] none


CvSubdiv2D!: make struct! compose/deep/only [
	ptr					[int] ;CV_SUBDIV2D_FIELDS!)
] none

CvSubdiv2DPointLocation: [
    CV_PTLOC_ERROR: -2
    CV_PTLOC_OUTSIDE_RECT: -1
    CV_PTLOC_INSIDE: 0
    CV_PTLOC_VERTEX: 1
    CV_PTLOC_ON_EDGE: 2
]

CvNextEdgeType: [
    CV_NEXT_AROUND_ORG:	#00
    CV_NEXT_AROUND_DST:	#22
    CV_PREV_AROUND_ORG:	#11
    CV_PREV_AROUND_DST:	#33
    CV_NEXT_AROUND_LEFT: #13
    CV_NEXT_AROUND_RIGHT: #31
    CV_PREV_AROUND_LEFT: #20
    CV_PREV_AROUND_RIGHT: #02
]

;get the next edge with the same origin point (counterwise)
CV_SUBDIV2D_NEXT_EDGE: func [edge]
[
	CvQuadEdge2D edge
	
	; & ~3))->next[(edge)&3])
]


;Contour approximation algorithms
CV_POLY_APPROX_DP: 0

; Shape matching methods
CV_CONTOURS_MATCH_I1:  1
CV_CONTOURS_MATCH_I2:  2
CV_CONTOURS_MATCH_I3:  3
 
;Shape orientation
CV_CLOCKWISE:         1
CV_COUNTER_CLOCKWISE: 2
 
 ;Convexity defect 
 CvConvexityDefect: make struct! [
 	start		[int]	;pointer to CvPoint
 	end			[int]	;pointer to CvPoint
 	depth_point	[int]	;pointer to CvPoint
 ] none
 
;Histogram comparison methods
CV_COMP_CORREL:              0
CV_COMP_CHISQR:              1
CV_COMP_INTERSECT:           2
CV_COMP_BHATTACHARYYA:       3

;Mask size for distance transform
CV_DIST_MASK_3:   3
CV_DIST_MASK_5:   5
CV_DIST_MASK_PRECISE: 0

; Content of output label array: connected components or pixels */
CV_DIST_LABEL_CCOMP:	0
CV_DIST_LABEL_PIXEL:	1

;Distance types for Distance Transform and M-estimators
CV_DIST_USER:    -1  ; User defined distance 
CV_DIST_L1:      1   ; distance = |x1-x2| + |y1-y2| 
CV_DIST_L2:      2   ; the simple euclidean distance 
CV_DIST_C:       3   ; distance = max(|x1-x2|,|y1-y2|) 
CV_DIST_L12:     4   ; L1-L2 metric: distance = 2(sqrt(1+x*x/2) - 1)) 
CV_DIST_FAIR:    5   ; distance = c^2(|x|/c-log(1+|x|/c)), c = 1.3998 
CV_DIST_WELSCH:  6   ; distance = c^2/2(1-exp(-(x/c)^2)), c = 2.9846 
CV_DIST_HUBER:   7   ; distance = |x|<c ? x^2/2 : c(|x|-c/2), c=1.345 

; Types of thresholding 
CV_THRESH_BINARY:      0  ; value = value > threshold ? max_value : 0       
CV_THRESH_BINARY_INV:  1  ; value = value > threshold ? 0 : max_value       
CV_THRESH_TRUNC:       2  ; value = value > threshold ? threshold : value   
CV_THRESH_TOZERO:      3  ; value = value > threshold ? value : 0           
CV_THRESH_TOZERO_INV:  4  ; value = value > threshold ? 0 : value           
CV_THRESH_MASK:        7
CV_THRESH_OTSU:        8  ; use Otsu algorithm to choose the optimal threshold value; combine the flag with one of the above CV_THRESH_* values 

; Adaptive threshold methods
CV_ADAPTIVE_THRESH_MEAN_C:  0
CV_ADAPTIVE_THRESH_GAUSSIAN_C:  1

;FloodFill flags
CV_FLOODFILL_FIXED_RANGE:    shift/left 1 16
CV_FLOODFILL_MASK_ONLY:      shift/left 1 17

;Canny edge detector flags
CV_CANNY_L2_GRADIENT:  shift/left 1 31

;Variants of a Hough transform
CV_HOUGH_STANDARD: 		0
CV_HOUGH_PROBABILISTIC: 1
CV_HOUGH_MULTI_SCALE: 	2
CV_HOUGH_GRADIENT: 		3


;Fast search data structures 
CvFeatureTree: integer!
CvLSH: integer!
CvLSHOperations: integer!