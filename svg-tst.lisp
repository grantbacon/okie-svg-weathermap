(include-book "testing" :dir :teachpacks)
(include-book "doublecheck" :dir :teachpacks)

(include-book "svg")

; Semicolon Tests
(check-expect (semicolon) #\;)
(check-expect t (stringp (semicolon)))

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

