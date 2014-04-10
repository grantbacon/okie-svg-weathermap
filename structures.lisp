(in-package "ACL2")
(include-book "data-structures/structures" :dir :system)

(defstructure point (x (:assert (rationalp x))) (y (:assert (rationalp y))) 
   color (:options (:assert (and (rationalp x) (rationalp y))):slot-writers))
(defstructure triangle p1 p2 p3 
   (:options (:assert (and (point-p p1) (point-p p2) (point-p p3)))))
