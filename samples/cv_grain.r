#! /usr/bin/rebolREBOL [	Title:		"OpenCV Tests: AGrains "	Author:		"Fran�ois Jouen"	Rights:		"Copyright (c) 2012-2014 Fran�ois Jouen. All rights reserved."	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"]do %../opencv.rset 'appDir what-dir DEMO_MIXED_API_USE: 1picture:  to-string to-local-file join appDir "_images/lena.jpg"cvNamedWindow "image with grain" CV_WINDOW_AUTOSIZE iplimg: cvLoadImage picture CV_LOAD_IMAGE_COLOR; CV_LOAD_IMAGE_GRAYSCALE; iplimgS: getPointerValues iplimg Iplimage!img: cvCreateImage iplimgS/width iplimgS/height iplimgS/depth iplimgS/nChannels ;IPL_DEPTH_8U 1;cvCvtColor iplimg img CV_BGR2XYZ cvShowImage "image with grain" imgcvWaitKey 0 free-mem iplimgfree-mem iplimgSfree-mem imgfreeDylib