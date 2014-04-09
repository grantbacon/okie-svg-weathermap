(include-book "doublecheck" :dir :teachpacks)
(include-book "testing" :dir :teachpacks)

(include-book "Delaunay")

(defun pointp (p)
   (not (and (null (point-x p)) (null (point-y p)))))

#| distanceSQ |#
;; Theorems

; Given x^2 > 0 for all x (where x is a real number)
; this implies that distance^2 should also be > 0
(defthm distanceSQ-is-positive
   (implies (and (pointp p1) (pointp p2))
            (> (distanceSQ p1 p2) 0)))

;; Check Expects
; The distance squared of (1, 1) --> (2, 2) == 2
(check-expect
 (let* ((pointa (point 1 1 0))
    (pointb (point 2 2 0)))     
  (distanceSQ pointa pointb)) 2)

; The distance squared from a point to itself is 0
(check-expect
 (let* ((pointa (point 1 1 0))
        (pointb (point 1 1 0)))
       (distanceSQ pointa pointb)) 0)
