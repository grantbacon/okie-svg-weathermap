(include-book "doublecheck" :dir :teachpacks)
(include-book "testing" :dir :teachpacks)

(include-book "Delaunay")

;sample data of points and correct edges to simplify testing
(defun samplePoints ()
   (let* ((p0 (avl-insert (empty-tree) 0 (point 0 0 nil)))
          (p1 (avl-insert p0 1 (point 5 5 nil)))
          (p2 (avl-insert p1 2 (point 0 3 nil)))
          (p3 (avl-insert p2 3 (point 5 0 nil)))
          (p4 (avl-insert p3 4 (point -2 -2 nil)))
          (p5 (avl-insert p4 5 (point 9/2 3 nil)))
          (p6 (avl-insert p5 6 (point 2 7 nil)))
          (p7 (avl-insert p6 7 (point 0 10 nil)))
          (p8 (avl-insert p7 8 (point 5 10 nil)))
          (p9 (avl-insert p8 9 (point -5 8 nil))))
         p9))

(defun sampleEdges ()
   (avl-insert
        (list 5 7 (vEdge 2 6 1 0)
           (list 3 3 (vEdge 3 5 1 0)
              (list 2 1 (vEdge 1 6 0 1)
                 (list 1 0 (vEdge 1 5 0 0) NIL NIL)
                 (list 1 2 (vEdge 5 6 1 0) NIL NIL))
              (list 2 5 (vEdge 1 8 0 1)
                 (list 1 4 (vEdge 1 3 1 0) NIL NIL)
                 (list 1 6 (vEdge 6 8 1 0) NIL NIL)))
           (list 4 15 (vEdge 0 2 1 1)
              (list 3 11 (vEdge 7 8 1 0)
                 (list 2 9 (vEdge 0 5 1 1)
                    (list 1 8 (vEdge 2 5 0 1) NIL NIL)
                    (list 1 10 (vEdge 0 3 0 1) NIL NIL))
                 (list 2 13 (vEdge 6 9 1 1)
                    (list 1 12 (vEdge 6 7 1 0) NIL NIL)
                    (list 1 14 (vEdge 2 9 1 0) NIL NIL)))
              (list 3 17 (vEdge 3 4 1 0)
                 (list 1 16 (vEdge 0 4 0 1) NIL NIL)
                 (list 2 18 (vEdge 7 9 0 1)))))
               19 (vEdge 0 9 1 0)))        

(include-book "arithmetic/top" :dir :system)


#| distanceSQ |#
;; Theorems

; Given x^2 > 0 for all x (where x is a real number)
; this implies that distance^2 should also be > 0
(defthm distanceSQ-is-positive
   (implies (and (point-p p1) (point-p p2))
            (and (>= (distanceSQ p1 p2) 0)
                 (rationalp (distanceSQ p1 p2)))))

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

;tests for distanceSQ
(check-expect (distanceSQ (point 0 0 nil) (point 5 5 nil)) 50)
(check-expect (distanceSQ (point nil 0 nil) (point 5 5 nil)) nil)
(check-expect (distanceSQ nil (point 5 5 nil)) nil)
(check-expect (distanceSQ (point 0 -5 nil) (point 5 5 nil)) 125)

;tests for crossProduct
(defthm crossProduct-is-Scalar
   (implies (and (point-p a) (point-p b) (point-p c))
            (rationalp (crossProduct a b c))))
(check-expect (equal (crossProduct (point 0 0 nil) 
                                   (point 0 5 nil) (point 1 1 nil))
                     0) nil)
(check-expect (crossProduct (point 0 0 nil) (point 0  5 nil) (point 0 1 nil))
              0)
(check-expect (crossProduct (point nil 0 nil) (point 0 5 nil) (point 1 1 nil)) 
              nil)
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
(check-expect (findEdge 1 3 (avl-insert (empty-tree) 1 (vEdge 1 3 nil nil))
                         1) 1)
(check-expect (findEdge 5 3 (avl-insert (empty-tree) 1 (vEdge 1 3 nil nil))
                         1) nil)
(check-expect (findEdge 1 3 (avl-insert (empty-tree) 1 (vEdge 1 nil nil nil))
                         1) nil)
(check-expect (findEdge 1 3 (empty-tree) 1) nil)

;tests for updateEdges


;tests for findPoint          
(check-expect (findPoint 0 0 2 (samplePoints) 10) 4)
(check-expect (findPoint 0 1 2 (samplePoints) 10) 0)
(check-expect (findPoint 0 0 -2 (samplePoints) 10) nil)
(check-expect (findPoint 0 0 2 (empty-tree) 10) nil)
 

;tests for bestPoint
(check-expect (bestPoint 0 0 (circle (point 7/2 3/2 nil) 29/2)
                         1 2 (samplePoints) 10) 5)
(check-expect (bestPoint 0 0 nil
                         1 2 (samplePoints) 10) nil)
(check-expect (bestPoint 0 0 (circle (point 7/2 3/2 nil) 29/2)
                         321 2 (samplePoints) 10) nil)
(check-expect (bestPoint 0 0 (circle (point 7/2 3/2 nil) 29/2)
                         1 2 nil 10) nil)


;tests for completeFacet


;tests for triangulate


;tests for findClosestNeighors+help
(check-expect (findClosestNeighbors 0 -1 (samplePoints) 10 0 0) (point 1 5 nil))
(check-expect (findClosestNeighbors 0 -1 (samplePoints) -10 0 0) nil)
(check-expect (findClosestNeighbors 0 -1 (samplePoints) 10 11 0) nil)
(check-expect (findClosestNeighbors 0 -1 nil 10 0 0) nil)


;tests for contains
(check-expect (contains 5 (list 1 3 5 6)) T)
(check-expect (contains (list 1 2) (list (list 4) (list 1 2))) T)
(check-expect (contains nil (list 1 3 6)) nil)
(check-expect (contains nil nil) nil)

;tests for prepData
(check-expect (tree? (prepdata 19 0 (sampleEdges) (empty-tree))) t)
(check-expect (prepdata 1 0 (avl-insert (avl-insert (empty-tree) 
                                         0 (vEdge 2 5 0 0)) 
                                        1 (vEdge 2 3 0 0)) (empty-tree)) 
              (avl-insert (empty-tree) 2 (list 3 5)))
(check-expect (prepdata -19 0 (sampleEdges) (empty-tree)) (empty-tree))
(check-expect (prepdata 19 0 nil (empty-tree)) nil)



;tests for sameSide
(check-expect (sameSide (point 2 2 nil) (point 0 5 nil) 
                        (point 0 0 nil) (point 5 0 nil)) T)
(check-expect (sameSide (point -2 -2 nil) (point 0 -5 nil) 
                        (point 0 0 nil) (point -5 0 nil)) T)
(check-expect (sameSide (point 2 2 nil) (point nil 5 nil) 
                        (point 0 0 nil) (point 5 0 nil)) nil)
(check-expect (sameSide nil (point 0 5 nil) 
                        (point 0 0 nil) (point 5 0 nil)) nil)


;tests for pointInTriangle
(check-expect (pointInTriangle 10 (samplePoints) (point 0 0 nil) 
                               (point 5 0 nil) (point 0 10 nil)) T)
(check-expect (pointInTriangle 10 (samplePoints) (point 0 0 nil) 
                               (point 5 0 nil) (point 0 3 nil)) nil)
(check-expect (pointInTriangle 10 nil (point 0 0 nil) 
                               (point 5 0 nil) (point 0 3 nil)) nil)
(check-expect (pointInTriangle 10 (samplePoints) (point 0 0 nil) 
                               nil (point 0 3 nil)) nil)


;tests for genTriangles+help
(check-expect (car (genTriangles 10 0 (samplePoints) 
                                 (prepdata 18 0 (sampleEdges) (empty-tree))
                                 (empty-tree)))
              (triangle (point 0 0 NIL) (point -2 -2 NIL) (point 5 0 NIL)))
(check-expect (len (genTriangles 10 0 (samplePoints) 
                                 (prepdata 18 0 (sampleEdges) (empty-tree))
                                 (empty-tree))) 10)
(check-expect (genTriangles 10 0 nil 
                                 (prepdata 18 0 (sampleEdges) (empty-tree))
                                 (empty-tree)) nil)
(check-expect (genTriangles 10 0 (samplePoints) nil (empty-tree)) nil)
               

;tests for delstart