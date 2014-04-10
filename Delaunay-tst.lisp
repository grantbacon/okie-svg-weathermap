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

;tests for distance SQ
(check-expect (distanceSQ (point 0 0 nil) (point 5 5 nil)) 50)
(check-expect (distanceSQ (point nil 0 nil) (point 5 5 nil)) nil)
(check-expect (distanceSQ nil (point 5 5 nil)) nil)
(check-expect (distanceSQ (point 0 -5 nil) (point 5 5 nil)) 125)

;tests for crossProduct
(check-expect (equal (crossProduct (point 0 0 nil) (point 0 5 nil) (point 1 1 nil))
                     0) nil)
(check-expect (crossProduct (point 0 0 nil) (point 0  5 nil) (point 0 1 nil))
              0)
(check-expect (crossProduct (point nil 0 nil) (point 0 5 nil) (point 1 1 nil)) nil)
(check-expect (crossProduct nil (point 0 5 nil) (point 1 1 nil)) nil)
                     

;tests for circumCircle
(check-expect (circumCircle nil (point 0 0 nil) 
                            (point 0 6 nil) (point 3 3 nil))
              (circle (point 0 3 nil) 9))
(check-expect (circumCircle nil (point nil 0 nil) 
                            (point 0 6 nil) (point 3 3 nil)) nil)
(check-expect (circumCircle nil nil (point 0 6 nil) (point 3 3 nil)) nil)


;tests for updateLeftFace
(check-expect (updateLeftFace (vEdge 3 15 nil 0) 3 1) (vEdge 3 15 1 0))
(check-expect (updateLeftFace (vEdge 3 15 0 0) 3 1) nil)
(check-expect (updateLeftFace (vEdge 3 15 nil 0) nil 1) nil)
(check-expect (updateLeftFace nil 3 1) nil)

;tests for findEdge
(check-expect (findEdge 1 3 (avl-insert (empty-tree) 1 (vEdge 1 3 nil nil)) 1) 1)
(check-expect (findEdge 5 3 (avl-insert (empty-tree) 1 (vEdge 1 3 nil nil)) 1) nil)
(check-expect (findEdge 1 3 (avl-insert (empty-tree) 1 (vEdge 1 nil nil nil)) 1) nil)
(check-expect (findEdge 1 3 (empty-tree) 1) nil)

;tests for updateEdges


;tests for findPoint
(defun samplePoints ()
   (avl-insert (avl-insert (avl-insert (avl-insert (empty-tree) 
                                                   0 (point 1 4 nil))
                                       1 (point 0 3 nil)) 
                           2 (point 0 3 nil)) 
               3 (point 1 2 nil)))              
(check-expect (findPoint 0 0 2 (samplePoints) 4) 3)
(check-expect (findPoint 0 1 2 (samplePoints) 4) 5)
(check-expect (findPoint 0 0 -2 (samplePoints) 4) nil)
(check-expect (findPoint 0 0 2 (empty-tree) 4) nil)
 

;tests for bestPoint


;tests for completeFacet


;tests for triangulate


;tests for closest-help


;tests for findClosestNeighors


;tests for conatins


;tests for prepData


;tests for sameSide


;tests for pointInTriangle


;tests for process-help


;tests for processEdges


;tests for genTriangles


;tests for delstart