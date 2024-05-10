(fiasco:define-test-package :timelib-tests
  (:use :timelib))

(in-package :timelib-tests)

;; https://github.com/dlowe-net/local-time/issues/67
;; play with hour between 1 and 2 and observe timezone

(deftest timezones-calc-test ()
  (let ((at-four (make-zoned-datetime 0 0 4 30 3 2014 "Europe/Stockholm"))
        (at-one (make-zoned-datetime 0 0 1 30 3 2014 "Europe/Stockholm")))
    (is (= (timestamp-difference at-four at-one) 7200)))

  (let ((ts (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (lt (local-time:encode-timestamp 0 0 0 1 1 1 2024 :timezone (local-time:find-timezone-by-location-name "America/Argentina/Buenos_Aires"))))
    (is (local-time:timestamp= lt (timestamp->local-time ts)))
    (is (local-time:timestamp=
         (timestamp->local-time (timestamp+ ts 1 :hour))
         (local-time:timestamp+ (timestamp->local-time ts) 1 :hour)))
    (is (= 2 (hour-of (timestamp+ ts 1 :hour))))))

;; https://github.com/dlowe-net/local-time/issues/67
;; play with hour between 1 and 2 and observe timezone
(let ((ts (make-zoned-datetime 0 0 1 30 3 2014 "Europe/Stockholm")))
  (timestamp+ ts 60 :minute))

(deftest equality-test ()
  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "America/Montevideo")))
    (is (zerop (timestamp-difference ts1 ts2))))

  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "America/Montevideo")))
    (is (timestamp= ts1 ts2) "Equal timestamp. Different timezone name, but same offset"))

  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires")))
    (is (timestamp= ts1 ts2) "Equal timestamp")))

(deftest timezones-test ()
  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "America/Montevideo")))
    (is (zerop (timestamp-difference ts1 ts2))))

  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "America/Montevideo")))
    (is (timestamp= ts1 ts2) "Equal timestamp. Different timezone name, but same offset"))

  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "Europe/Stockholm")))
    (is (= (timestamp-difference ts1 ts2 :hours) 4)))

  (let ((ts1 (make-zoned-datetime 0 0 1 1 1 2024 "America/Argentina/Buenos_Aires"))
        (ts2 (make-zoned-datetime 0 0 1 1 1 2024 "Europe/Stockholm")))
    (is (not (timestamp= ts1 ts2)))))

(deftest conversion-tests ()
  (let ((dt (make-datetime 1 2 3 4 5 2024)))
    (is (timestamp= (timestamp-convert dt 'date)
                    (make-date 4 5 2024)))))
