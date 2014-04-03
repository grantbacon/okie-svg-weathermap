(in-package "ACL2")
(include-book "data-structures/structures" :dir :system)
(include-book "avl-rational-keys" :dir :teachpacks)
(include-book "io-utilities" :dir :teachpacks)
(include-book "io-utilities-ex" :dir :teachpacks)

(include-book "svg")

(set-state-ok t)

(defstructure point x y color (:options :slot-writers))
(defstructure vEdge s tt l r (:options :slot-writers))
(defstructure circle c r2 (:options :slot-writers))
(defstructure tData nPoints nEdges points edges (:options :slot-writers))
(defstructure helper minDist u v)
(defstructure triangle p1 p2 p3)

(defun stdin->string (state)
   (mv-let (chli error state)
           (let ((channel *standard-ci*))
              (if (null channel)
                  (mv nil
                      "Error while opening stdin for input"
                      state)
                  (mv-let (chlist chnl state)
                          (read-n-chars 4000000000 '() channel state)
                     (let ((state (close-input-channel chnl state)))
                       (mv chlist nil state)))))
      (mv (reverse (chrs->str chli)) error state)))
  
(defun stdin->lines (state)
  (mv-let (chnl state)
(mv *standard-ci* state)
     (if (null chnl)
         (mv "Error opening standard input" state)
         (mv-let (c1 state) ; get one char ahead
                 (read-char$ chnl state)
            (mv-let (rv-lines state) ; get line, record backwards
                    (rd-lines 4000000000 c1 nil chnl state)
               (let* ((state (close-input-channel chnl state)))
                     (mv (reverse rv-lines) state))))))); rev, deliver

(defun parseNums (xs)
   (if (endp xs)
       nil
       (cons (str->rat (coerce (car xs) 'string))
             (parseNums (cdr xs)))))

(defun strings->num-lists (lst)
   (if (endp lst)
       nil
       (cons (parseNums (remove nil (packets-set (list #\, #\' #\space) (coerce (car lst) 'list))))
             (strings->num-lists (cdr lst)))))

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
             (circle (point cx cy nil) (distanceSQ (point cx cy nil) p1)))))             

(defun updateLeftFace (edge s nFaces)
   (if (and (equal s (vEdge-s edge))
            (NULL (vEdge-l edge)))
       (set-vEdge-l nFaces edge)
       (if (and (equal s (vEdge-tt edge))
                (NULL (vEdge-r edge)))
           (set-vEdge-r nFaces edge)
           nil)))
                                 
(defun findEdge (s tt edges nEdges)
   (if (not (posp nEdges))
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
                      (avl-insert edges1 (tData-nEdges triData)
                                  (if (< bP s) (vEdge bP s 1 nil) (vEdge s bP nil 1)))
                      (avl-insert edges1 eI1 (updateLeftFace (cdr (avl-retrieve edges1 eI1)) bP 1))))
          (eI2 (findEdge tt bP edges2 nEdges1))
          (nEdges2 (+ nEdges1 (if (NULL eI2) 1 0)))
          (edges3 (if (NULL eI2)
                      (avl-insert edges2 nEdges1 
                                  (if (< tt bP) (vEdge tt bP 1 nil) (vEdge bP tt nil 1)))
                      (avl-insert edges2 eI2 (updateLeftFace (cdr (avl-retrieve edges2 eI2)) tt 1)))))
         (set-tData-edges edges3 (set-tData-nEdges nEdges2 triData))))

(defun findPoint (u s tt points nPoints)
   (if (or (zp (- u nPoints)) (> u nPoints))
       (1+ nPoints)
       (if (or (= nPoints s) (= nPoints tt))
           (findPoint (1+ u) s tt points nPoints)
           (let* ((pS (cdr (avl-retrieve points s)))
                  (pT (cdr (avl-retrieve points tt)))
                  (pU (cdr (avl-retrieve points u))))
                 (if (> (crossProduct pS pT pU) 0)
                     u
                     (findPoint (1+ u) s tt points nPoints))))))

(defun bestPoint (u bP bC s tt points nPoints)
   (if (or (zp (- u nPoints)) (> u nPoints))
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
          (s (if (NULL (vEdge-l edge)) (vEdge-s edge) (vEdge-tt edge)))
          (tt (if (NULL (vEdge-l edge)) (vEdge-tt edge) (vEdge-s edge)))
          (points (tData-points triData))
          (nPoints (tData-nPoints triData))
          (bP (findPoint 0 s tt points nPoints))
          (bC (if (< bP nPoints) 
                  (circumCircle nil 
                                (cdr (avl-retrieve points s))
                                (cdr (avl-retrieve points tt))
                                (cdr (avl-retrieve points bP)))
                  nil))
          (bP2 (if (< bP nPoints) (bestPoint bP bP bC s tt points nPoints) bP)))
         (if (> bP2 nPoints)
             (set-tData-edges (avl-insert edges eI (updateLeftFace edge s 0)) triData)
             (updateEdges eI s tt bP2 triData))))
     
;main recursive call
(defun triangulate (currentEdge triData)
   (if (or (zp (- currentEdge (tData-nEdges triData)))
           (> currentEdge (tData-nEdges triData)))
       triData
       (let* ((l (vEdge-l (cdr (avl-retrieve (tData-edges triData) currentEdge))))
              (triData1 (if (NULL l) (completeFacet currentEdge triData) triData))
              (r (vEdge-r (cdr (avl-retrieve (tData-edges triData1) currentEdge))))                
              (triData2 (if (NULL r) (completeFacet currentEdge triData1) triData1)))
             (triangulate (1+ currentEdge) triData2)))) 

(defun closest-help (i j minDist points nPoints u v)
   (if (or (zp (- j nPoints))
           (> j nPoints))
       (helper minDist u v)
       (let ((d (distanceSQ (cdr (avl-retrieve points i))
                            (cdr (avl-retrieve points j)))))
            (if (or (= minDist -1)
                    (< d minDist))
                (closest-help i (1+ j) d points nPoints i j)
                (closest-help i (1+ j) minDist points nPoints u v)))))

(defun findClosestNeighbors (i minDist points nPoints u v)
   (if (or (zp (- i (1- nPoints)))
           (> i (1- nPoints)))
       (if (< u v) (point u v nil) (point v u nil))
       (let ((ret (closest-help i (1+ i) minDist points nPoints u v)))
            (findClosestNeighbors (1+ i) (helper-minDist ret) 
                                  points nPoints
                                  (helper-u ret) (helper-v ret)))))
   
(defun parse (n xs ys)
   (if (endp xs)
       (cons n ys)
       (let ((p (point (cadar xs) (caar xs) (cddar xs))))
            (parse (1+ n) (cdr xs) (avl-insert ys n p)))))
 
(defun contains (x xs)
   (if (endp xs)
       nil
       (if (= x (car xs))
           t
           (contains x (cdr xs)))))

;convert triangulation results into sorted set of 
;edge references for triangle extraction
(defun prepdata (nEdges n edges tree)
   (if (< nEdges 0)
       tree
       (let* ((edge (cdr (avl-retrieve edges nEdges)))
              (key (vEdge-s edge))
              (data (cdr (avl-retrieve tree key))))
             (prepdata (1- nEdges) (max n key) edges
                        (avl-insert tree key (append data (list (vEdge-tt edge))))))))

(defun sameSide (p1 p2 a b)
   (let* ((cp1 (crossProduct a b p1))
          (cp2 (crossProduct a b p2)))
         (>= (* cp1 cp2) 0)))

(defun pointInTriangle (n points a b c)
   (if (< n 0)
       nil
       (let ((p (cdr (avl-retrieve points n))))
            (if (or (equal p a) (equal p b) (equal p c))
                (pointInTriangle (1- n) points a b c)
                (if (and (sameSide p a b c)
                         (sameSide p b a c)
                         (sameSide p c a b))
                    T
                    (pointInTriangle (1- n) points a b c))))))

;had to split up process functions to prove termination
(defun process-help (nPoints n n2 points tree tris set)
   (if (endp set)
       tris
       (let* ((aSet (cdr (avl-retrieve tree n2)))
              (bSet (cdr (avl-retrieve tree (car set))))
              (tri (if (or (contains (car set) aSet)
                           (contains n2 bSet))
                       (triangle (cdr (avl-retrieve points n))
                                 (cdr (avl-retrieve points n2))
                                 (cdr (avl-retrieve points (car set))))
                       nil))
              (tris2 (if (NULL tri) tris 
                         (if (pointInTriangle (1- nPoints) points 
                                              (triangle-p1 tri)
                                              (triangle-p2 tri)
                                              (triangle-p3 tri))
                             tris
                             (append tris (list tri))))))
             (process-help nPoints n n2 points tree tris2 (cdr set)))))

(defun processEdges (nPoints n points tree tris set)
   (if (endp (cdr set))
       tris
       (processEdges nPoints n points tree 
                     (process-help nPoints n (car set) points tree tris (cdr set))
                     (cdr set))))

(defun genTriangles (nPoints n points tree tris)
   (let ((set (cdr (avl-retrieve tree n))))
        (if (or (zp nPoints) (NULL set))
            tris
            (genTriangles (1- nPoints) (1+ n) points tree (processEdges nPoints n points tree tris set)))))         
   
;starter function
(defun delstart (xs)
   (let* ((parsed (parse 0 xs (empty-tree)))
          (pair (findCLosestNeighbors 0 -1 (cdr parsed) (car parsed) 0 0))
          (edge (vEdge (point-x pair) (point-y pair) nil nil))
          (data (tData (car parsed) 1 (cdr parsed) (avl-insert (empty-tree) 0 edge)))
          (triData (triangulate 0 data))
          (triangles (genTriangles (tData-nPoints triData) 0 (tData-points triData)
                                   (prepdata (1- (tData-nEdges triData)) 0 (tData-edges triData) (empty-tree)) nil)))
         triangles)) ;replace with call to svg generator
    

(defun svgLines (triangulation i)
   (if (consp triangulation)
       (cons (svgTriangle (car triangulation) i)
             (svgLines (cdr triangulation) (1+ i)))
       nil))                         
                                                                   
;quick test code based on expected live input format (list of (lat, lon, color))
(let* ((input (list "34.81, -98.02, '15,0,255'"
                    "34.80, -96.67, '31,0,255'"
                    "34.59, -96.67, '0,63,255'"
                    "35.40, -99.90, '0,15,255'"
                    "34.04, -96.35, '63,0,255'"
                    "36.63, -96.81, '47,0,255'"))
       (points (strings->num-lists input)))
      (svgLines  (delstart points) 0))

(defun string-list->stdout (strli state)
  (let ((channel *standard-co*))
     (if (null channel)
         (mv "Error while opening stdout"
             state)
         (mv-let (channel state)
                 (write-all-strings strli channel state)
            (let ((state (close-output-channel channel state)))
              (mv nil state))))))



(defun main (state)
  (mv-let (input-lines state)
          (stdin->lines state)
     (if nil
         (mv nil state)
         (mv-let (error-close state)
                 (string-list->stdout ;input-lines
                  (append
                                     (cons "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"4000\" height=\"4000\">"
                                     
                                     
                                      (svgLines (delstart (strings->num-lists input-lines)) 0)
                                     )(list "</svg>"))
                                       state)
            (if error-close
                (mv error-close state)
                (mv (string-append "input file: "
                     (string-append "stdin"
                      (string-append ", output file: " "stdout")))
                    state))))))