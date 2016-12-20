#! /usr/local/bin/rebol
rebol [
]

do %../../opencv.r

mat1: cvCreateMat 2 2 CV_8UC1 			
mat1S: getPointerValues mat1 CvMat!
print mold  first mat1S
print ["CV_8UC1: " second mat1S]

mat1: cvCreateMat 2 2 CV_8UC2 			
mat1S: getPointerValues mat1 CvMat!
print ["CV_8UC2: " second mat1S]

mat1: cvCreateMat 2 2 CV_8UC3 			
mat1S: getPointerValues mat1 CvMat!
print ["CV_8UC3: " second mat1S]

mat1: cvCreateMat 2 2 CV_32FC1 			
mat1S: getPointerValues mat1 CvMat!
print ["CV_32FC1: " second mat1S]

mat1: cvCreateMat 2 2 CV_32FC2 			
mat1S: getPointerValues mat1 CvMat!
print ["CV_32FC2: " second mat1S]

mat1: cvCreateMat 2 2 CV_32FC3 			
mat1S: getPointerValues mat1 CvMat!
print ["CV_32FC3: " second mat1S]

mat1: cvCreateMat 2 2 CV_32FC4			
mat1S: getPointerValues mat1 CvMat!
print ["CV_32FC4: " second mat1S]

mat1: cvCreateMat 2 2 CV_64FC1			
mat1S: getPointerValues mat1 CvMat!
print ["CV_64FC1: " second mat1S]

mat1: cvCreateMat 2 2 CV_64FC2			
mat1S: getPointerValues mat1 CvMat!
print ["CV_64FC2: " second mat1S]

mat1: cvCreateMat 2 2 CV_64FC3			
mat1S: getPointerValues mat1 CvMat!
print ["CV_64FC3: " second mat1S]

mat1: cvCreateMat 2 2 CV_64FC4			
mat1S: getPointerValues mat1 CvMat!
print ["CV_64FC4: " second mat1S]

free-mem mat1 
free-mem Mat1S

