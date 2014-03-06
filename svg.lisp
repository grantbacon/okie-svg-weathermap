(include-book "data-structures/structures" :dir :system)

(defstructure point x y temp (:options :slot-writers)) ; from Delaunay.lisp

; estimate: 12 lines
(defun oppositePoint (point others)
   (let ((x1 (point-x point))
         (y1 (point-y point))
         (x2 (point-x (car others)))
         (y2 (point-y (car others)))
         (x3 (point-x (cadr others)))
         (y3 (point-y (cadr others))))
        (if (= x3 x2)
            (point x2 y1 nil) ; line is vertical, don't try to calculate slope
            (let* ((m (/ (- y3 y2) (- x3 x2)))
                   (b (- y2 (* m x2)))
                   (msq (* m m))
                   (oppX (/ (+ (* m y1) x1 (- (* m b))) (+ msq 1)))
                   (oppY (/ (+ (* msq y1) (* m x1) b) (+ msq 1))))
                  (point oppX oppY nil)))))

; estimate: 10 lines
; TODO: get ACL2 to prove termination
(defun minXY (points)
   (if (>= (len points) 2)
       (let* ((x1 (point-x (car points)))
              (y1 (point-y (car points)))
              (x2 (point-x (cadr points)))
              (y2 (point-y (cadr points)))
              (xmin (min x1 x2))
              (ymin (min y1 y2)))
             (minXY (cons (point xmin ymin nil) (cddr points))))
       (car points)))

; subtracts the X and Y values of base from every point in points
(defun rebasePoints (points base)
   (if (consp points)
       (let ((pt (car points)))
            (cons (point (- (point-x pt) (point-x base))
                         (- (point-y pt) (point-y base))
                         (point-temp pt))
                  (rebasePoints (cdr points) base)))
       nil))

; sanity checks for oppositePoint
(oppositePoint (point 0 5 nil) (list (point -3 1 nil) (point 3 1 nil)))
(oppositePoint (point 5 0 nil) (list (point 1 -3 nil) (point 1 3 nil)))

; sanity check for minXY
(minXY (list (point 3 3 nil) (point -3 5 nil) (point 4 0 nil)))

; sanity check for rebasePoints
(let ((lst (list (point 3 3 nil) (point -3 5 nil) (point 4 0 nil))))
     (rebasePoints lst (minXY lst)))

