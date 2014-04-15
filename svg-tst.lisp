(include-book "testing" :dir :teachpacks)
(include-book "doublecheck" :dir :teachpacks)

(include-book "svg")

; Semicolon Tests
(check-expect (semicolon) #\;)
(check-expect t (stringp (semicolon)))

;oppositePoint Tests
(check-expect (oppositePoint (point 0 5 nil) (point -3 1 nil) 
                             (point 3 1 nil)) (point 0 1 nil))
(check-expect (oppositePoint (point 3 4 nil) (point -3 1 nil)
                              (point 3 1 nil)) (point 3 1 nil))
(check-expect (oppositePoint (point 0 3 nil) 
                              (point -3 -1 nil) (point 0 0 nil)) (POINT 9/10 3/10 NIL))
(check-expect (oppositePoint (point 0 3 nil) (point -3 -1 nil)
                              (point 3 6 nil)) (POINT 21/85 237/85 NIL))
              
; appendStrings tests
(check-expect (appendStrings '("hello " "world")) "hello world")
(check-expect (appendStrings '(" " "")) " ")
(check-expect (appendStrings '("a" "b" "c" "d" "e")) "abcde")
(check-expect (appendStrings '("hello")) "hello")

; minXY tests
(check-expect (minXY (list (point 3 3 nil) (point -3 5 nil) (point 4 0 nil))) 
              (point -3 0 NIL))
(check-expect (minXY (list (point 3 2 nil) (point 3 5 nil) (point 4 2 nil))) 
              (POINT 3 2 NIL))
(check-expect (minXY (list (point 0 0 nil) (point 3 5 nil) (point 4 2 nil))) 
              (POINT 0 0 NIL))
(check-expect (minXY (list (point 3 3 nil) (point -3 5 nil) (point 4 0 nil))) 
              (point -3 0 NIL))


; color->str tests
(check-expect "255,255,255" (color->str '(255 255 255)))
(check-expect "0,0,0" (color->str '(0 0 0) ))
(check-expect "255,134,0" (color->str '(255 134 0) ))
(check-expect "0,23,54" (color->str '(0 23 54) ))
(defproperty color->str-returns-a-string
   (c1 :value (random-integer)
    c2 :value (random-integer)
    c3 :value (random-integer))
   (equal (stringp (color->str `(c1 c2 c3))) t))

; svgGradient
(defproperty svgGradient-always-returns-string
   (x1 :value (random-integer)
    y1 :value (random-integer)
    x2 :value (random-integer)
    y2 :value (random-integer))
   (let* ((p1 (point x1 y1 nil))
      	(p2 (point x2 y2 nil)))
        (equal t (stringp (svgGradient p1 p2 "a" "233,444,222")))))
