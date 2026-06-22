(define/contract (three-sum nums)
  (-> (listof exact-integer?) (listof (listof exact-integer?)))
  (define v (list->vector (sort nums <)))
  (define n (vector-length v))
  (define result '())
  (for ([i (in-range (- n 2))])
    (when (or (= i 0)
              (not (= (vector-ref v i)
                      (vector-ref v (- i 1)))))
      (let loop ([left (+ i 1)]
                 [right (- n 1)])
        (when (< left right)
          (define sum
            (+ (vector-ref v i)
               (vector-ref v left)
               (vector-ref v right)))
          (cond
            [(< sum 0)
             (loop (+ left 1) right)]
            [(> sum 0)
             (loop left (- right 1))]
            [else
             (set! result
                   (cons (list (vector-ref v i)
                               (vector-ref v left)
                               (vector-ref v right))
                         result))
             (define next-left
               (let skip ([l (+ left 1)])
                 (if (and (< l right)
                          (= (vector-ref v l)
                             (vector-ref v left)))
                     (skip (+ l 1))
                     l)))
             (define next-right
               (let skip ([r (- right 1)])
                 (if (and (> r left)
                          (= (vector-ref v r)
                             (vector-ref v right)))
                     (skip (- r 1))
                     r)))
             (loop next-left next-right)])))))
  (reverse result))