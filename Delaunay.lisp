(include-book "data-structures/structures" :dir :system)
(include-book "avl-rational-keys" :dir :teachpacks)

(defstructure point x y (:options :slot-writers))
(defstructure vEdge s tt l r (:options :slot-writers))
(defstructure circle c r2 (:options :slot-writers))
(defstructure tData nPoints nEdges points edges (:options :slot-writers))
(defstructure helper minDist u v)
  

(defun distanceSQ (a b)
   (let* ((dx (- (point-x a) (point-x b)))
          (dy (- (point-y a) (point-y b))))
         (+ (* dx dx) (* dy dy))))

(defun crossProduct (p1 p2 p3)
   (let* ((u1 (- (point-x p2) (point-x p1)))
          (v1 (- (point-y p2) (point-y p1)))
          (u2 (- (point-x p3) (point-x p1)))
          (v2 (- (point-y p3) (point-y p1))))
         (- (* u1 v2) (* v1 u2))))        

(defun circumCircle (bC p1 p2 p3)
   (let* ((cP (crossProduct p1 p2 p3))
          (p1SQ (+ (* (point-x p1) (point-x p1))
                   (* (point-y p1) (point-y p1))))
          (p2SQ (+ (* (point-x p2) (point-x p2))
                   (* (point-y p2) (point-y p2))))
          (p3SQ (+ (* (point-x p3) (point-x p3))
                   (* (point-y p3) (point-y p3))))
          (num1 (+ (* p1SQ (- (point-y p2) (point-y p3)))
                   (* p2SQ (- (point-y p3) (point-y p1)))
                   (* p3SQ (- (point-y p1) (point-y p2)))))
          (num2 (+ (* p1SQ (- (point-x p3) (point-x p2)))
                   (* p2SQ (- (point-x p1) (point-x p3)))
                   (* p3SQ (- (point-x p2) (point-x p1)))))
          (cx (/ num1 (* 2 cP)))
          (cy (/ num2 (* 2 cP))))
         (if (= cP 0)
             (circle (circle-c bC) (distanceSQ (circle-c bC) p1))
             (circle (point cx cy) (distanceSQ (point cx cy) p1)))))             

(defun updateLeftFace (edge s nFaces)
   (if (and (equal s (vEdge-s edge))
            (NULL (vEdge-l edge)))
       (set-vEdge-l nFaces edge)
       (if (and (equal s (vEdge-tt edge))
                (NULL (vEdge-r edge)))
           (set-vEdge-r nFaces edge)
           nil)))
                                 
(defun findEdge (s tt edges nEdges)
   (if (> 0 nEdges)
       nil
       (let ((edge (cdr (avl-retrieve edges nEdges))))
            (if (or (and (equal s (vEdge-s edge))
                     (equal tt (vEdge-tt edge)))
                    (and (equal s (vEdge-tt edge))
                     (equal tt (vEdge-s edge))))
                nEdges
                (findEdge s tt edges (1- nEdges))))))
         
;returns tData
(defun updateEdges (eI s tt bP triData)
   (let* ((edges (tData-edges triData))
          (newEdge1 (updateLeftFace (cdr (avl-retrieve edges eI)) s 0))
          (edges1 (avl-insert edges eI newEdge1))
          (eI1 (findEdge bP s edges1 (tData-nEdges triData)))
          (nEdges1 (+ (tData-nEdges triData) (if (NULL eI1) 1 0)))
          (edges2 (if (NULL eI1)
                      (avl-insert edges1 nEdges1 (vEdge bP s 1 nil))
                      (avl-insert edges1 eI1 (updateLeftFace (cdr (avl-retrieve edges1 eI1)) bP 1))))
          (eI2 (findEdge tt bP edges2 nEdges1))
          (nEdges2 (+ nEdges1 (if (NULL eI2) 1 0)))
          (edges3 (if (NULL eI2)
                      (avl-insert edges2 nEdges2 (vEdge tt bP 1 nil))                                                    
                      (avl-insert edges2 eI2 (updateLeftFace (cdr (avl-retrieve edges2 eI2)) tt 1)))))
         (set-tData-edges edges3 (set-tData-nEdges nEdges2 triData))))

(defun findPoint (u s tt points nPoints)
   (if (>= u nPoints)
       nil
       (if (or (= nPoints s) (= nPoints tt))
           (findPoint (1+ u) s tt points nPoints)
           (let* ((pS (cdr (avl-retrieve points s)))
                  (pT (cdr (avl-retrieve points tt)))
                  (pU (cdr (avl-retrieve points u))))
                 (if (> (crossProduct pS pT pU) 0)
                     u
                     (findPoint (1+ u) s tt points nPoints))))))

(defun bestPoint (u bP bC s tt points nPoints)
   (if (= u nPoints)
       bP
       (if (or (= u s) (= u tt))
           (bestPoint (1+ u) bP bC s tt points nPoints)
           (let* ((pS (cdr (avl-retrieve points s)))
                  (pT (cdr (avl-retrieve points tt)))
                  (pU (cdr (avl-retrieve points u))))
                 (if (and (> (crossProduct pS pT pU) 0)
                          (< (distanceSQ (circle-c bC) pU) 
                             (circle-r2 bC)))
                     (bestPoint (1+ u) u (circumCircle bC pS pT pU) s tt points nPoints)
                     (bestPoint (1+ u) bP bC s tt points nPoints))))))

;returns tData
(defun completeFacet (eI triData)
   (let* ((edges (tData-edges triData))
          (edge (cdr (avl-retrieve edges eI)))
          ;) (if t triData eI)))
          (s (if (NULL (vEdge-l edge)) (vEdge-s edge) (vEdge-tt edge)))
          (tt (if (NULL (vEdge-l edge)) (vEdge-tt edge) (vEdge-s edge)))
          (points (tData-points triData))
          (nPoints (tData-nPoints triData))
          (bP (findPoint 0 s tt points nPoints))
          (bC (circumCircle nil (cdr (avl-retrieve points s))(cdr (avl-retrieve points tt))(cdr (avl-retrieve points bP))))
          (bP2 (if (< bP nPoints) (bestPoint bP bP bC s tt points nPoints) bP)))
         (if (> bP2 nPoints)
             (set-tData-edges (avl-insert edges eI (updateLeftFace edge s 0)) triData)
             (updateEdges eI s tt bP2 triData))))
     
;main recursive call
(defun triangulate (currentEdge triData)
   (if (>= currentEdge (tData-nPoints triData))
       triData
       (let* ((l (vEdge-l (cdr (avl-retrieve (tData-edges triData) currentEdge))))
              (triData1 (if (NULL l) (completeFacet currentEdge triData) triData))
              (r (vEdge-r (cdr (avl-retrieve (tData-edges triData1) currentEdge))))
                            
              (triData2 (if (NULL r) (completeFacet currentEdge triData1) triData1)))
             (triangulate (1+ currentEdge) triData2)))) 
     
(defun closest-help (i j minDist points nPoints u v)
   (if (< j nPoints)
       (let ((d (distanceSQ (cdr (avl-retrieve points i))
                            (cdr (avl-retrieve points j)))))
            (if (or (= minDist -1)
                    (< d minDist))
                (closest-help i (1+ j) d points nPoints i j)
                (closest-help i (1+ j) minDist points nPoints u v)))
       (helper minDist u v)))

(defun findClosestNeighbors (i minDist points nPoints u v)
   (if (< i (1- nPoints))
       (let ((ret (closest-help i (1+ i) minDist points nPoints u v)))
            (findClosestNeighbors (1+ i) (helper-minDist ret) 
                                  points nPoints
                                  (helper-u ret) (helper-v ret)))                         
       (if (< u v) (point u v) (point v u))))
   
;temporary starter function
(defun delstart (p points nPoints)   
   (triangulate 0 (tData nPoints 0 points 
                         (avl-insert (empty-tree) 0 (vEdge (point-x p) (point-y p) nil nil)))))


;quick test code
(let* ((tree (avl-insert (empty-tree) 0 (point 1 1)))
       (tree1 (avl-insert tree 1 (point 2 21)))
       (tree2 (avl-insert tree1 2 (point 32 2)))
       (tree3 (avl-insert tree2 3 (point 5 30)))
       (tree4 (avl-insert tree3 4 (point 11 5)))
       (tree5 (avl-insert tree4 5 (point 10 10)))
       (tree6 (avl-insert tree5 6 (point 3 7))))
      (delstart (findClosestNeighbors 1 -1 tree6 7 0 0) tree6 7))
          
          
