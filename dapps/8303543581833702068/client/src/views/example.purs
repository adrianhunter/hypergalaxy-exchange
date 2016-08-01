module Test where

import Prelude

gcd :: Int -> Int -> Int
gcd n m | n == 0 = m
gcd n m | m == 0 = n
gcd n m | n > m = gcd (n - m) m
gcd n m = gcd (m - n) n
