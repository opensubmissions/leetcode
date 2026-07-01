(require data/queue data/heap)

(define/contract (maximum-safeness-factor grid)
  (-> (listof (listof exact-integer?)) exact-integer?)

  (define n (length grid))
  (define grid-vec (list->vector (map list->vector grid)))

  ;; distance-to-nearest-thief grid, initialized to -1
  (define dist (build-vector n (lambda (_) (make-vector n -1))))

  (define (neighbors r c)
    (filter (lambda (p) (and (>= (car p) 0) (< (car p) n)
                              (>= (cdr p) 0) (< (cdr p) n)))
            (list (cons (- r 1) c) (cons (+ r 1) c)
                  (cons r (- c 1)) (cons r (+ c 1)))))

  ;; ---------- multi-source BFS from all thief cells ----------
  (define q (make-queue))
  (for* ([r (in-range n)] [c (in-range n)])
    (when (= (vector-ref (vector-ref grid-vec r) c) 1)
      (vector-set! (vector-ref dist r) c 0)
      (enqueue! q (cons r c))))

  (let loop ()
    (unless (queue-empty? q)
      (define rc (dequeue! q))
      (define r (car rc))
      (define c (cdr rc))
      (define d (vector-ref (vector-ref dist r) c))
      (for ([nb (neighbors r c)])
        (define nr (car nb))
        (define nc (cdr nb))
        (when (= (vector-ref (vector-ref dist nr) nc) -1)
          (vector-set! (vector-ref dist nr) nc (+ d 1))
          (enqueue! q (cons nr nc))))
      (loop)))

  ;; ---------- Dijkstra-style maximum bottleneck (maximin) path ----------
  (define best (build-vector n (lambda (_) (make-vector n -1))))
  (define start-val (vector-ref (vector-ref dist 0) 0))
  (vector-set! (vector-ref best 0) 0 start-val)

  ;; min-heap on negated value => behaves as a max-heap on value
  (define heap (make-heap (lambda (a b) (<= (car a) (car b)))))
  (heap-add! heap (list (- start-val) 0 0))

  (let loop ()
    (cond
      [(= (heap-count heap) 0)
       (vector-ref (vector-ref best (- n 1)) (- n 1))]
      [else
       (define top (heap-min heap))
       (heap-remove-min! heap)
       (define val (- (car top)))
       (define r (cadr top))
       (define c (caddr top))
       (cond
         [(not (= val (vector-ref (vector-ref best r) c)))
          (loop)]
         [(and (= r (- n 1)) (= c (- n 1)))
          val]
         [else
          (for ([nb (neighbors r c)])
            (define nr (car nb))
            (define nc (cdr nb))
            (define nd (vector-ref (vector-ref dist nr) nc))
            (define cand (min val nd))
            (define cur-best (vector-ref (vector-ref best nr) nc))
            (when (> cand cur-best)
              (vector-set! (vector-ref best nr) nc cand)
              (heap-add! heap (list (- cand) nr nc))))
          (loop)])])))