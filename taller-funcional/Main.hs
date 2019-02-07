import Util
import Data.List

-- Ejercicio 1
-- Una máquina sin transiciones se modela como una máquina
-- cuya función de transición devuelve siempre la lista vacía.
vacio :: [b] -> MEN a b
vacio sigma = AM sigma (\q s -> [])
-- Acá otra implementación de vacío:
-- vacío sigma = AM sigma (const $ const [])

-- Creemos sin embargo que la implementación elegida es más intuitiva y fácil de leer:
-- En la misma estamos definiendo explícitamente que la función de transición,
-- que toma dos parámetros, q y s, devuelve siempre la lista vacía. Muy parecido a lo que
-- queremos modelar en palabras.

-- Una forma de testear vacio es hacer:
-- delta (vacio ['a', 'b', 'c']) q s
-- y ver que para cualquier combinación de estado q y símbolo s,
-- la función anterior devuelve una lista vacía

agregarTransicion :: (Eq a, Eq b) => MEN a b -> a -> b -> a -> MEN a b
agregarTransicion m q0 s q1 = AM (sigma m) nuevaDelta
    where nuevaDelta x y = if (x == q0 && y == s) 
                           then q1:(delta m x y)
                           else delta m x y

-- Para testear podemos hacer:
-- delta mPLP 0 'l'
-- devuelve: [] (no hay transición desde q0 con 'l')
-- Luego,
-- delta (agregarTransicion mPLP 0 'l' 1) 0 'l'
-- devuelve: [1] (la transición que acabamos de agregar)

aislarEstado :: Eq a => MEN a b -> a -> MEN a b
aislarEstado m q = AM (sigma m) nuevaDelta
    where nuevaDelta x y = if q == x 
                           then []
                           else filter (/= q) (delta m x y)

-- Para testear podemos hacer:
-- delta mPLP 1 'l'
-- Devuelve: [2,3]
-- Luego hacer:
-- delta (aislarEstado mPLP 1) 1 'l'
-- Y vemos que devuelve: [], es decir, efectivamente eliminamos las transiciones del estado 1 por l
-- Además, si hacemos:
-- delta (aislarEstado mPLP 1) 0 'p'
-- Devuelve: [], es decir, eliminamos también la única transición entrante al estado 1

-- Ejercicio 2
trampaUniversal :: a -> [b] -> MEN a b
trampaUniversal q ss = AM ss (const $ const [q])

completo :: (Eq a, Eq b) => MEN a b ->  a  ->  MEN a b
completo m q = AM (sigma m) nuevaDelta
    where nuevaDelta x y = if elem y (sigma m)
                           then union (delta m x y) [q]
                           else delta m x y

-- Para testear esta función podemos hacer:
-- delta (completo mPLP 7) q s
-- y ver que para cualquier combinación de estado q y símbolo s,
-- la función anterior devuelve una lista donde el elemento 7 pertenece a la misma

-- Ejercicio 3
consumir :: Eq a => MEN a b -> a -> [b] -> [a]
consumir m q0 = foldl (\xs c -> foldr union [] (map (\q -> delta m q c) xs)) [q0]

-- Para testear esta función podemos hacer:
-- consumir mPLP 0 "pl"
-- Devuelve: [2,3], que son los estados en los que se encuentra el autómata
-- partiendo del estado 0 y después de haber consumido la cadena "pl"

-- Si al autómata mPLP le agregamos un loop en el estado 1 con 'l':
-- consumir (agregarTransicion mPLP 1 'l' 1) 1 "l"
-- Devuelve: [1,2,3], que son todos los estados a los que se llega desde
-- el estado 1 consumiendo el símbolo 'l'

-- consumir mPLP 0 "l"
-- Devuelve: [], ya que no hay ningún estado por el cual se puede avanzar en el autómata
-- a partir del estado 0 y leyendo el símbolo (y en particular, la cadena) "l"

-- Ejercicio 4
acepta :: Eq a => MEN a b -> a -> [b] -> [a] -> Bool
acepta m q0 s qf = foldr (\q b -> b || (elem q qf)) False (consumir m q0 s)

-- Para testear esta función podemos hacer:
-- acepta mPLP 0 "plp" [3]
-- Devuelve: True, ya que existe un camino de 0 a 3 consumiendo la cadena "plp"

-- Si hacemos:
-- acepta mPLP 0 "plp" [2]
-- Devuelve: False, ya que, partiendo del estado 0 y consumiendo "plp", se llega al estado 3, y no al 2

lenguaje :: Eq a => MEN a b -> a -> [a] -> [[b]]
lenguaje m q0 qf = filter (\s -> acepta m q0 s qf) (kleene (sigma m))

-- Para testear esta función podemos hacer:
-- lenguaje mPLP 0 [0]
-- Devuelve: [""
-- Por cómo está hecha la función, por más que el lenguaje es finito en este caso, la misma
-- devuelve una lista que no termina
-- Podemos hacer take 1 (lenguaje mPLP 0 [0]) para forzar el cierre de la lista

-- Otro ejemplo:
-- Si hacemos:
-- lenguaje mPLP 0 [2]
-- Devuelve: ["pl"
-- Es decir, al igual que antes, la función no termina, pero sin embargo la misma devuelve la totalidad del lenguaje
-- Sin embargo, si agregamos un ciclo en alguna parte del camino:
-- lenguaje (agregarTransicion mPLP 0 'p' 0) 0 [2]
-- Devuelve: ["pl","ppl","pppl","ppppl","pppppl","ppppppl","pppppppl","ppppppppl","pppppppppl","ppppppppppl"]
-- En este caso el lenguaje es infinito, ya que, al agregar un ciclo en el estado 0, estamos permitiendo cadenas
-- que contengan cualquier cantidad de 'p' al comienzo de las mismas

-- Sugerencia (opcional)
kleene :: [b] -> [[b]]
kleene sigma = concat [palabrasLongN x | x <- [0..]] 
    where palabrasLongN n = foldNat [[]] (\xs -> [ c:x | x <- xs, c <- sigma ]) n

-- La función kleene devuelve la clausura de kleene del alfabeto especificado por parámetro
-- Dicha clausura es el conjunto de todas las palabras que se pueden formar con
-- los símbolos del alfabeto, con lo cual, si el alfabeto tiene al menos un símbolo,
-- la clausura de kleene es un conjunto infinito
-- Por ejemplo,
-- kleene ['a', 'b', 'c']
-- Devuelve: ["","a","b","c","aa","ba","ca","ab","bb","cb","ac","bc","cc","aaa","baa","caa","aba","bba","cba","aca", ...]

-- Ejercicio 5
trazas :: Eq a => MEN a b -> a -> [[b]]
trazas m q0 = foldr (++) [] (takeWhile (\x -> length x /= 0) [ trazasLongN n | n <- [1..] ])
    where trazasLongN n = filter (\s -> length (consumir m q0 s) /= 0) (palabrasLongN n)
          palabrasLongN n = foldNat [[]] (\xs -> [ c:x | x <- xs, c <- sigma m ]) n

-- Para testear:
-- trazas mPLP 0
-- Devuelve: ["p", "pl", "plp"]

-- Si agregamos un loop en el estado dos por el símbolo 'a':
-- trazas (agregarTransicion mPLP {sigma = ['p', 'l', 'a']} 2 'a' 2) 0
-- Devuelve: ["p","pl","plp","pla","plap","plaa","plaap","plaaa","plaaap","plaaaa","plaaaap","plaaaaa","plaaaaap","plaaaaaa","plaaaaaap", ...]
-- Podemos ver que la transición agregada aparece en la solución
