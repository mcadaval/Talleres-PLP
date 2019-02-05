module Util where

data MEN a b = AM {sigma :: [b], delta :: (a->b->[a])}

-- Ejemplo del enunciado

mPLP :: MEN Int Char
mPLP = AM ['l','p'] tran
       where tran q s |q == 0 && s == 'p' = [1]
                      |q == 1 && s == 'l' = [2, 3]
                      |q == 2 && s == 'p' = [3]
                      |otherwise = []

fix :: (a -> a) -> a
fix f = f (fix f)

foldNat :: a -> (a->a) -> Integer -> a
foldNat caso0 casoSuc n | n == 0 = caso0
                        | n > 0 = casoSuc (foldNat caso0 casoSuc (n-1))
                        | otherwise = error "El argumento de foldNat no puede ser negativo"
