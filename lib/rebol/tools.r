#! /usr/bin/rebol
REBOL [
	Title:		"OpenCV Rebol Utilities"
	Author:		"Franois Jouen"
	Rights:		"Copyright (c) 2012-2013 Franois Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


;****************** we need some specific tools for talking to OpenCV  **************

byte-ptr!: make struct! [value [char!]] none
int-ptr!: make struct! [value [integer!]] none
float-ptr!: make struct! [value [decimal!]] none

; a collection of tools made by famous rebolers
;from Piotr Gapinski" %ieee.r
  
from-ieee: func [
 "Zamienia binarna liczbe float ieee-32 na number!"
 [catch]
  dat [binary!] "liczba w formacie ieee-32"
 /local ieee-sign ieee-exponent ieee-mantissa] [

  ieee-sign: func [dat] [either zero? ((to-integer dat) and (to-integer 2#{10000000000000000000000000000000})) [1][-1]] ;; 1 bit
  ieee-exponent: func [dat] [
    exp: (to-integer dat) and (to-integer 2#{01111111100000000000000000000000}) ;; 8 bitow
    exp: (exp / power 2 23) - 127 ;; 127=[2^(k-1) - 1] (k=8 dla IEEE-32bit)
  ]
  ieee-mantissa: func [dat] [
    ((to-integer dat) and 
     (to-integer 2#{00000000011111111111111111111111})) + (to-integer (1 * power 2 23)) ;; 23 bity
  ]

  s: ieee-sign dat
  e: ieee-exponent dat
  m: ieee-mantissa dat
  d: s * (to-integer m) / power 2 (23 - e)
]

to-ieee: func [
 "Zamienia decimal! lub integer! na binary! w formacie ieee-32."
 [catch]
  dat [number!] "liczba do konwersji (24 bity)"
 /local ieee-sign ieee-exponent ieee-mantissa integer-to-binary] [

  integer-to-binary: func [i [number!]] [debase/base to-hex i 16]
  ieee-sign: func [dat] [either positive? dat [0][1]]
  ieee-exponent: func [dat] [ ;; only for -0.5 > x > 0.5
    dat: to-integer dat
    weight: to-integer #{800000}
    i: 0
    forever [
      i: i + 1 
      if ((weight and dat) = weight) [break] 
      weight: to-integer (weight / 2)
    ]
    24 - i + 127
  ]
  ieee-mantissa: func [dat e] [
    m: to-integer (dat * (power 2 (23 - e + 127)))
    m: m and to-integer 2#{0111 1111 1111 1111 1111 1111}
  ]

  s: ieee-sign dat
  dat: abs dat
  e: ieee-exponent dat
  m: ieee-mantissa dat e
  integer-to-binary to-integer (m + (e * power 2 23) + (s * power 2 31))
]

;from "Glenn M. Lewis"  %bin-to-float.r

bin-to-float: func [
    "Converts a binary series to a series of floats"
    dat [binary!] "Binary data to be converted to floats"
    /local result val
] [
    result: copy []
    for i ((length? dat) / 4) 1 -1 [
        val: from-ieee skip dat (4 * i - 4)
        insert result val
    ]
    result
]

float-to-bin: func [
    "Converts a series of floats to a binary series"
    dat [series!] "Float series to be converted to binary"
    /local result val
] [
    result: copy #{}
    for i (length? dat) 1 -1 [
        val: to-ieee pick dat i
        insert result val
    ]
    result
]

; Nenad Rakocevic' routines for memory release
zero-char: #0
malloc: func [size [integer!] "size in bytes"][head insert/dup copy {} zero-char size]
free-mem: func ['word] [set :word make none! recycle]

; this a slight adaptation of fabulous memory access functions written by Ladislav Mecir;
;see %library-utils.r on rebol.org for original

sizeof: func [
		{get the size of a datatype in bytes}
		datatype [word! block!]
	] [
		length? third make struct! compose/deep [value [(datatype)]] none
]


string-address?: func [
		{get the address of the given string}
		string [any-string!]
		/local str ptr
	] [
	    ptr: make struct! [value [integer!]] none
	    str: make struct! [buffer [string!]] none
		str/buffer: string
		change third ptr third str
		ptr/value
	]


address-to-string: func [
		{get a copy of the nul-terminated string at the given address}
		address [integer!]
		/local str ptr
	] [
		ptr: make struct! [value [integer!]] reduce [address]
	    str: make struct! [buffer [string!]] none
		change third str third ptr
		str/buffer
	]
	
struct-address?: func [
		{get the address of the given struct}
		struct [struct!]
	] [
		string-address? third struct
	]


	
; specific for binary (char-array)
get-memory: func [
		{
			copy a region of memory having the given address and size,
			the result is a REBOL binary value
		}
		address [integer!]
		size [integer!]
		/local ptr struct
	] [
	    ptr: make struct! [value [integer!]] reduce [address]
		struct: make struct! compose/deep [bin [char-array (size)]] none
		change third struct third ptr
		as-binary struct/bin
]
	
	
set-memory: func [
		{change a region of memory at the given address}
		address [integer!]
		contents [binary! string!]
		/local ptr 
	] [
		ptr: make struct! [value [integer!]] reduce [address]
		pStruct: make struct! [struct [struct! [[save] c [char]]]] none
		foreach char as-string contents [
			change third pStruct third ptr
			pStruct/struct/c: char
			ptr/value: ptr/value + 1
		]
]

; datatype conversion
convert: func [
    x
    /to type [word!]
    /local y
] [
    any [to type: type?/word x]
    y: make struct! compose/deep [x [(type)]] reduce [x]
    third y
]

reverse-conversion: func [
    x [binary!]
    type [word!]
    /local y
] [
    y: make struct! compose/deep [x [(type)]] none
    change third y x
    y/x
]



; OpenCV memory access
; this function  creates pointer with a structure  for integer, decimal ...
pointer: func [datatype [word!] val][make struct! compose/deep [value [(datatype)]] reduce [val]]

; get any structure address : short cut for struct-address?
&pointer: func [struct [struct!]] [struct-address? struct]



; From rebol to cv colors 
; OpenCV color depends on image depth [8 16 32 64] and on type [Signed ou Unsigned]
; Rebol use just 8-bit unsigned depth (0..255)

; for 8 bit images 0..255 for IPL_DEPTH_8U  and -127 .. 128 IPL_DEPTH_8S
tocvByteRGB: func [color [tuple!] /signed /local n divider val r g b a]
[ 
	n: to-integer length? color
	either signed [
  		val: color/1 / 255 either val > 0.5 [r: val * 128] [r: negate (val * 127)]
  		val: color/2 / 255 either val > 0.5 [g: val * 128] [g: negate  (val * 127)]
  		val: color/3 / 255 either val > 0.5 [b: val * 128] [b: negate (val * 127)]
  		if (n = 3) [a: 0.0]
  		if (n = 4 ) [ val: color/4 / 255 either val > 0.5 [a: val * 127] [a: - (val * 128)]]
  		]
  		[
			r: color/1 
			g: color/2
			b: color/3
			if (n = 3) [a: 0.0]
			if (n = 4 ) [a: color/4]
		]
  return reduce [r g b a]
]

;for 16 bit images 0... 65535 for IPL_DEPTH_16U  and -32767 ...32768 for IPL_DEPTH_16S 
tocvIntRGB: func [color [tuple!] /signed /local n r g b a][
	n: to-integer length? color
	either signed [
  		val: color/1 / 255 either val > 0.5 [r: val * 32768] [r: negate (val * 32767)]
  		val: color/2 / 255 either val > 0.5 [g: val * 32768] [g: negate  (val * 32767)]
  		val: color/3 / 255 either val > 0.5 [b: val * 32768] [b: negate (val * 32767)]
  		if (n = 3) [a: 0.0]
  		if (n = 4 ) [ val: color/4 / 255 either val > 0.5 [a: val * 127] [a: - (val * 128)]]
  		]
  		[
			r: color/1 / 255 * 65535
			g: color/2 / 255 * 65535
			b: color/3 / 255 * 65535
			if (n = 3) [a: 0.0]
			if (n = 4 ) [a: color/4 / 255 * 65535]
		]
  return reduce [r g b a]
]


; float value between 0 and 1 for 32 and 64 bit images IPL_DEPTH_32F and IPL_DEPTH_64F
tocvFloatRGB: func [color [tuple!] /local divider] [
	divider: 255
 	r: color/1 / divider
 	g:  color/2  / divider 
	b: color/3 / divider
	n: to-integer length? color
 	either (n = 3) [a: 0.0] [a: color/4 / 255]
 return reduce [r g b a]
]



cvSavetoRebol: func [src dest] [
 cvSaveImage to-string to-local-file join appDir "images/tmp.jpg" src
 dest/image: load to-file join appDir "images/tmp.jpg"
 show dest
]





; generic function to access to members of  any defined opencv structure !
; when cvFunctions return a pointer to a structure 
;use a pointer (address of opencv structure) and the type of the structure

getPointerValues: func [ptr [integer!] structureType [struct!]] [
	"Gets the contents of opencv structures" 
	struct: make struct! (structureType) none			; make a rebol structure for cv Structure
	content: get-memory ptr length? third struct		; get the content of the pointer
	change third struct content							; update rebol structure
	struct												; return structure 
]

;generic function to set value for all members of  any defined opencv structure !
; not use
setPointerValues: func [address  [integer!] pStruct [struct!]] [
	; set a structure content to memory address
	set-memory address third pStruct
]


; if there is no memory alignment pb
cvtoRebolByPtr: func [img dest /local src] [
"Transforms OpenCV image to REBOL image"
    src: getIPLImage img 							; get values of IplImage
	data: src/imageData								; address of image data
	rgb: reverse get-memory data src/imageSize		;get the data in rgb order
	; mow makes a REBOL image
    dest/image: make image! reduce [as-pair (src/width) (src/height) rgb]
    dest/effect: [fit flip 1x1]
	show dest
] 

;this is for memory alignment of IplImage in OpenCV;
; processes line by line 
;get the line data with the ACTUAL size : width * nChannels and not widthStep
 
cvtoRebol: func [img dest /local src rgb] [
"Transforms OpenCV image to REBOL image"
    src: getIPLImage img 							; get values of IplImage
	rgb: copy #{}									; make a binary 
	for y 0 src/height - 1 1 [
		index: y * src/widthStep 					; go to line y and get data
		line: get-memory (src/imageData + index) (src/width * src/nChannels)  
		append tail rgb line
	]
	; mow makes the REBOL image
    dest/image: make image! reduce [as-pair (src/width) (src/height) reverse rgb]
    dest/effect: [fit flip 1x1] ;
	show dest
] 


atan2: func [x y][
	x: x + 0.00000001
	x: either x > 0 [arctangent y / x][180 + arctangent y / x]
	360 + x // 360
]



