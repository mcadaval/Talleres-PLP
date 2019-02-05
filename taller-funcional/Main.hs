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
                           then q1:(delta m q0 s)
                           else delta m q0 s

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
                           then (filter (/= q) (delta m x y))++[q]
                           else delta m x y

-- Ejercicio 3
consumir :: Eq a => MEN a b -> a -> [b] -> [a]
consumir = undefined


-- Ejercicio 4
acepta :: Eq a => MEN a b -> a -> [b] -> [a] -> Bool
acepta = undefined

lenguaje :: Eq a => MEN a b -> a ->  [a] -> [[b]]
lenguaje = undefined

-- Sugerencia (opcional)
kleene :: [b] -> [[b]]
kleene = undefined

-- Ejercicio 5
trazas :: MEN a b -> a -> [[b]]
trazas = undefined

--Ejercicio 6

deltaS :: Eq a => MEN a b -> [a] -> [a]
deltaS = undefined

fixWhile :: (a -> a) -> (a -> Bool) -> a -> a
fixWhile = undefined

fixWhileF :: (a -> a) -> (a -> Bool) -> a -> a
fixWhileF = undefined

alcanzables :: Eq a => MEN a b -> a -> [a]
alcanzables = undefined
