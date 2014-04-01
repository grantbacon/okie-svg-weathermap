(in-package "ACL2")
(include-book "io-utilities" :dir :teachpacks) ; for str->rat
(include-book "structures")

(defun round-frac (frac)
   (round (numerator frac) (denominator frac)))

; converts temperature to color as RGB triplet
; white when temp<-10F, gray when temp>110F, between red and blue otherwise
(defun temp-to-color (temp)
   (let ((scale (/ (+ temp 10) 120)))
        (if (< scale 0)
            (list 0 0 0)
            (if (> scale 1)
                (list 128 128 128)
                (list (round-frac (* 255 scale))
                      0
                      (round-frac (* 255 (- 1 scale))))
))))

; splits space-delimited character list into list of string tokens
(defun tokenizeCharList (charList)
   (let ((index (search (list #\Space) charList)))
        (if (integerp index)
            (let ((firstToken (take index charList))
                  (restOfString (nthcdr (1+ index) charList)))
                 (cons (coerce firstToken 'string)
                       (tokenizeCharList restOfString)))
            (list (coerce charList 'string)))))

; splits space-delimited character list into list of string tokens
(defun tokenizeCommaCharList (charList)
   (let ((index (search (list #\,) charList)))
        (if (integerp index)
            (let ((firstToken (take index charList))
                  (restOfString (nthcdr (1+ index) charList)))
                 (cons (str->rat (coerce firstToken 'string))
                       (tokenizeCommaCharList restOfString)))
            (list (str->rat (coerce charList 'string))))))

(defun string->point (str)
   (let ((tokens (tokenizeCharList (coerce str 'list))))
        (point (str->rat (first tokens))
               (str->rat (second tokens))
               (third tokens))))

(defun string->list (str)
   (let ((tokens (tokenizeCharList (coerce str 'list))))
        (list (str->rat (first tokens))
               (str->rat (second tokens))
               (tokenizeCommaCharList (coerce (third tokens) 'list)))))

; temp
(defun string->list2 (str)
   (let ((tokens (tokenizeCharList (coerce str 'list))))
        (list (str->rat (second tokens))
               (str->rat (first tokens))
               (temp-to-color (str->rat (third tokens))))))

(tokenizeCharList (coerce "36.07 -99.90 47" 'list))
(string->point "36.07 -99.90 47")
(string->list "36.07 -99.90 47")

(set-state-ok t)
(include-book "io-utilities-ex")

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

(defun string-list->stdout (strli state)
  (let ((channel *standard-co*))
     (if (null channel)
         (mv "Error while opening stdout"
             state)
         (mv-let (channel state)
                 (write-all-strings strli channel state)
            (let ((state (close-output-channel channel state)))
              (mv nil state))))))

(defun stdin->lines (state)
  (mv-let (chnl state) 
		 (mv *standard-ci* state)
     (if (null chnl)
         (mv "Error opening standard input" state)
         (mv-let (c1 state)                       ; get one char ahead
                 (read-char$ chnl state)
            (mv-let (rv-lines state)      ; get line, record backwards
                    (rd-lines 4000000000 c1 nil chnl state)
               (let* ((state (close-input-channel chnl state)))
                     (mv (reverse rv-lines) state))))))); rev, deliver

(defun lines->lists2 (lines)
   (if (consp lines)
       (cons (string->list (car lines)) (lines->lists2 (cdr lines)))
       nil))

(include-book "svg")
(include-book "Delaunay")

(defun main2 (input-lines)
   ;(triangulation (lines->lists2 input-lines)))
   (svgTriangle (car (delstart (lines->lists2 input-lines))) 0))
   ;(tri-write (svgTriangle (car (triangulation (lines->lists2 input-lines))) 0)) "output.svg" state))

(defun svgLines (triangulation i)
   (if (consp triangulation)
       (cons (svgTriangle (car triangulation) i)
             (svgLines (cdr triangulation) (1+ i)))
       nil))

(defun main3 ()
   (svgLines (delstart (lines->lists2 (list
"34.81 -98.02 0,191,255"
"34.80 -96.67 0,191,255"
"34.59 -99.34 0,207,255"
"36.71 -98.71 0,31,255"
"34.25 -95.67 0,255,159"
"34.91 -98.29 0,207,255"
"34.19 -97.09 0,255,254"
"36.07 -99.90 0,63,255"
"36.80 -100.53 0,31,255"
"35.40 -99.06 0,111,255"
"35.96 -95.87 0,143,255"
"36.75 -97.25 0,79,255"
"36.69 -102.50 0,15,255"
"35.17 -96.63 0,175,255"
"36.41 -97.69 0,47,255"
"35.78 -96.35 0,143,255"
"34.04 -94.62 0,255,111"
"36.83 -99.64 0,15,255"
"36.63 -96.81 0,95,255"
"33.89 -97.27 0,255,47"
"35.59 -99.27 0,111,255"
"34.85 -97.00 0,159,255"
"36.03 -99.35 0,47,255"
"36.15 -97.29 0,143,255"
"34.61 -96.33 0,207,255"
"35.65 -96.80 0,159,255"
"36.75 -98.36 0,47,255"
"35.55 -99.73 0,79,255"
"35.03 -97.91 0,191,255"
"34.66 -95.33 0,255,175"
"34.22 -95.25 0,255,175"
"36.32 -95.65 0,127,255"
"35.68 -94.85 0,255,254"
"36.91 -95.89 0,95,255"
"33.92 -96.32 0,255,79"
"35.55 -98.04 0,111,255"
"35.20 -99.80 0,127,255"
"35.30 -95.66 0,191,255"
"36.26 -98.50 0,63,255"
"34.55 -96.72 0,143,255"
"36.84 -96.43 0,79,255"
"36.73 -99.14 0,47,255"
"35.15 -98.47 0,159,255"
"36.60 -101.60 0,15,255"
"34.24 -98.74 0,255,254"
"35.85 -97.48 0,143,255"
"35.75 -95.64 0,127,255"
"35.84 -96.00 0,127,255"
"34.99 -99.05 0,143,255"
"35.07 -96.36 0,191,255"
"34.69 -99.83 0,191,255"
"36.86 -101.23 0,95,255"
"34.03 -95.54 0,255,63"
"33.83 -94.88 0,255,47"
"36.14 -95.45 0,95,255"
"36.48 -94.78 0,111,255"
"36.83 -102.88 0,47,255"
"34.53 -97.76 0,159,255"
"35.85 -97.95 0,111,255"
"36.38 -98.11 0,63,255"
"34.31 -96.00 0,255,175"
"34.04 -96.94 0,255,95"
"34.84 -99.42 0,175,255"
"36.06 -97.21 0,127,255"
"36.99 -99.01 0,47,255"
"34.88 -95.78 0,191,255"
"36.79 -97.75 0,47,255"
"34.73 -98.57 0,207,255"
"36.89 -94.84 0,95,255"
"35.27 -97.96 0,175,255"
"36.12 -97.61 0,111,255"
"34.31 -94.82 0,255,175"
"36.90 -96.91 0,63,255"
"34.23 -97.20 0,239,255"
"34.97 -97.95 0,207,255"
"36.74 -95.61 0,143,255"
"35.24 -97.46 0,175,255"
"36.03 -96.50 0,143,255"
"35.47 -97.46 0,159,255"
"35.56 -97.51 0,143,255"
"35.47 -97.58 0,159,255"
"35.43 -96.26 0,159,255"
"35.58 -95.91 0,159,255"
"34.72 -97.23 0,127,255"
"36.36 -96.77 0,127,255"
"36.00 -97.05 0,127,255"
"35.83 -95.56 0,127,255"
"36.37 -95.27 0,95,255"
"36.36 -97.15 0,111,255"
"35.12 -99.36 0,127,255"
"34.19 -97.59 0,255,223"
"35.44 -94.80 0,255,207"
"36.19 -99.04 0,47,255"
"35.36 -96.95 0,159,255"
"36.42 -96.04 0,111,255"
"36.60 -100.26 0,31,255"
"35.54 -97.34 0,143,255"
"35.27 -95.18 0,239,255"
"36.12 -97.10 0,143,255"
"34.88 -96.07 0,191,255"
"34.57 -96.95 0,191,255"
"35.97 -94.99 0,175,255"
"34.71 -95.01 0,255,159"
"34.44 -99.14 0,255,239"
"34.33 -96.68 0,175,255"
"36.20 -95.94 0,111,255"
"36.78 -95.22 0,95,255"
"34.40 -98.35 0,175,255"
"34.98 -97.52 0,175,255"
"34.17 -97.99 0,255,191"
"35.49 -95.12 0,239,255"
"36.01 -94.64 0,191,255"
"34.90 -95.35 0,255,239"
"34.98 -94.69 0,255,159"
"36.42 -99.42 0,47,255"
"36.52 -96.34 0,127,255"))) 0))

(defun main (state)
  (mv-let (input-lines state)
          (stdin->lines state)
     (if nil
         (mv nil state)
         (mv-let (error-close state)
                 (string-list->stdout ;input-lines
                                      (svgLines (delstart (lines->lists2 input-lines)) 0)
                                      state)
            (if error-close
                (mv error-close state)
                (mv (string-append "input file: "
                     (string-append "stdin"
                      (string-append ", output file: " "stdout")))
                    state))))))

