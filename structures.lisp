(in-package "ACL2")
(include-book "data-structures/structures" :dir :system)

(defstructure point x y color (:options :slot-writers))
(defstructure triangle p1 p2 p3)
