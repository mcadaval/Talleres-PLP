import Util
import Data.List

-- Ejercicio 1
vacio :: [b] -> MEN a b
vacio sigma = AM sigma (\q s -> [])
-- vacio sigma = AM sigma (\x -> const [])
-- vacio sigma = AM sigma (const $ const [])

agregarTransicion :: (Eq a, Eq b) => MEN a b -> a -> b -> a -> MEN a b
agregarTransicion m q0 s q1 = AM (sigma m) nuevaDelta
    where nuevaDelta x y = if (x == q0 && y == s) 
                           then q1:(delta m x y)
                           else delta m x y

aislarEstado :: Eq a => MEN a b -> a -> MEN a b
aislarEstado m q = AM (sigma m) nuevaDelta
    where nuevaDelta x y = if q == x 
                           then []
                           else filter (/= q) (delta m x y)

-- Ejercicio 2
trampaUniversal :: a -> [b] -> MEN a b
trampaUniversal q ss = AM ss (const $ const [q])

completo :: (Eq a, Eq b) => MEN a b ->  a  ->  MEN a b
completo m q = AM (sigma m) nuevaDelta
    where nuevaDelta x y = if elem y (sigma m)
                           then union (delta m x y) [q]
                           else delta m x y

-- Ejercicio 3
consumir :: Eq a => MEN a b -> a -> [b] -> [a]
consumir m q0 = foldl (\xs c -> foldr union [] (map (\q -> delta m q c) xs)) [q0]

-- Ejercicio 4
acepta :: Eq a => MEN a b -> a -> [b] -> [a] -> Bool
acepta m q0 s qf = foldr (\q b -> b || (elem q qf)) False (consumir m q0 s)

lenguaje :: Eq a => MEN a b -> a -> [a] -> [[b]]
lenguaje m q0 qf = filter (\s -> acepta m q0 s qf) (kleene (sigma m))

-- Sugerencia (opcional)
kleene :: [b] -> [[b]]
kleene sigma = concat [palabrasLongN x | x <- [0..]] 
    where palabrasLongN n = foldNat [[]] (\xs -> [ c:x | x <- xs, c <- sigma ]) n

-- Ejercicio 5
trazas :: Eq a => MEN a b -> a -> [[b]]
trazas m q0 = foldr (++) [] (takeWhile (\x -> length x /= 0) [ trazasLongN n | n <- [1..] ])
    where trazasLongN n = filter (\s -> length (consumir m q0 s) /= 0) (palabrasLongN n)
          palabrasLongN n = foldNat [[]] (\xs -> [ c:x | x <- xs, c <- sigma m ]) n

--Ejercicio 6

deltaS :: Eq a => MEN a b -> [a] -> [a]
deltaS = undefined

fixWhile :: (a -> a) -> (a -> Bool) -> a -> a
fixWhile = undefined

fixWhileF :: (a -> a) -> (a -> Bool) -> a -> a
fixWhileF = undefined

alcanzables :: Eq a => MEN a b -> a -> [a]
alcanzables = undefined
