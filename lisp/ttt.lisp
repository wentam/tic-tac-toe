(defvar peices (make-array '(3 3) :initial-contents '((" " " " " ") 
						      (" " " " " ") 
						      (" " " " " "))))
(defun print-board () 
  (format t "-------------~%")
  (format t "|1  |2  |3  |~%")
  (format t "| ~a | ~a | ~a |~%" (aref peices 0 0) (aref peices 0 1) (aref peices 0 2))
  (format t "|   |   |   |~%")
  (format t "-------------~%")
  (format t "|4  |5  |6  |~%")
  (format t "| ~a | ~a | ~a |~%" (aref peices 1 0) (aref peices 1 1) (aref peices 1 2))
  (format t "|   |   |   |~%")
  (format t "-------------~%")
  (format t "|7  |8  |9  |~%")
  (format t "| ~a | ~a | ~a |~%" (aref peices 2 0) (aref peices 2 1) (aref peices 2 2))
  (format t "|   |   |   |~%")
  (format t "-------------~%"))


(defun add-peice (location value)
  (let ((col 0) (row 0) (return_val)) 
    (loop for i from 1 to 3 do 

	 (if (= location i)
	     (progn
	       (setf col location)
	       (setf row 1)))
	 
	 (if (= (- location 3) i)
	     (progn
	       (setf col (- location 3))
	       (setf row 2)))
	 
	 (if (= (- location 6) i)
	     (progn
	       (setf col (- location 6))
	       (setf row 3))))
    
    (if (not (string= " " (aref peices (- row 1) (- col 1))))
	(setf return_val 0)
	(progn
	  (setf return_val 1)
	  (setf (aref peices (- row 1) (- col 1)) value)))

    return_val))


(defun check-win (player)
  (let ((rows_result 0) (cols_result 0) (d_result 0) (final_result 0))
    (loop for i from 0 to 2 do
	 (if (and (string= (aref peices i 0) player) 
		  (string= (aref peices i 1) player)
		  (string= (aref peices i 2) player))
	     (setf rows_result 1))

	 (if (and (string= (aref peices 0 i) player)
		  (string= (aref peices 1 i) player)
		  (string= (aref peices 2 i) player)
		  )
	     (setf cols_result 1)))

    (if (or (and (string= (aref peices 0 0) player)
		 (string= (aref peices 1 1) player)
		 (string= (aref peices 2 2) player))

	    (and (string= (aref peices 0 2) player)
		 (string= (aref peices 1 1) player)
		 (string= (aref peices 2 0) player)))

	(setf d_result 1))
    
    (if (or (= rows_result 1)
	    (= cols_result 1)
	    (= d_result 1))

	(setf final_result 1))
    final_result))


;; begin game loop ;;
(let ((gamerunning 1))
  (print-board)
  (loop while(= gamerunning 1) do

     ;;--player X

       (format t "Player X: ")
       (let ((input))
	 (setq input (read-line))
	 (if (= (add-peice (parse-integer input) "X") 0)
	     (format t "No taking spots! you forfeit your turn.~%")))

       (print-board)

       (if (= (check-win "X") 1)
	   (progn
	     (format t "player X wins!")
	     (quit)))


     ;;--player O
       (format t "Player O: ")
       (let ((input))
	 (setq input (read-line))
	 (if (= (add-peice (parse-integer input) "O") 0)
	     (format t "No taking spots! you forfeit your turn.~%")))

       (print-board)
       
       (if (= (check-win "O") 1)
	   (progn
	     (format t "player O wins!")
	     (quit)))))
