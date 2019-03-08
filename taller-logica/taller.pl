% :- [paradas, esquinas].
:- [basetest].
:- multifile parada/3.

% ------------------------------------------------------------------------------
% Ejercicios

% 1. Dar consultas para obtener:
% a. Dada una calle, todas los números donde hay una parada de colectivos y
%    la lista de las líneas que paran allí.

% paradasCalle(+Calle, -Numero, -Lineas)
paradasCalle(Calle, Numero, Lineas) :- 
  parada(Calle, Numero, Lineas).

% b. Dada una lista de líneas, todos los pares (calle, número) donde paran
%    exactamente esas líneas.

% paradasLineas(+Lineas, -(Calle, Numero))
paradasLineas(Lineas, (Calle, Numero)) :- 
  parada(Calle, Numero, LineasEnCalleYNumero), 
  permutation(Lineas, LineasEnCalleYNumero).

% 2. compartenParada(+Linea1, +Linea2, ?Calle, ?Numero).
compartenParada(Linea1, Linea2, Calle, Numero) :- 
  parada(Calle, Numero, LineasEnCalleYNumero1), 
  parada(Calle, Numero, LineasEnCalleYNumero2), 
  member(Linea1, LineasEnCalleYNumero1), 
  member(Linea2, LineasEnCalleYNumero2).

% 3. viaje(?Linea, ?CalleOrig, ?NumOrig, ?CalleDest, ?NumDest)
viaje(Linea, CalleOrig, NumOrig, CalleDest, NumDest) :- 
  parada(CalleOrig, NumOrig, LineasEnCalleOYNumeroO),
  member(Linea, LineasEnCalleOYNumeroO),
  parada(CalleDest, NumDest, LineasEnCalleDYNumeroD),
  member(Linea, LineasEnCalleDYNumeroD),
  diferentes(CalleOrig, NumOrig, CalleDest, NumDest).

% 4. a. lineasQueParan(+Calle, -Lineas).
lineasQueParan(Calle, Lineas) :- 
  setof(Linea, lineaQuePara(Calle, Linea) , Lineas).

% lineaQuePara(+Calle, -Linea).
lineaQuePara(Calle, Linea) :-
  parada(Calle, _, LineasQueParanEnCalleYNumero),
  member(Linea, LineasQueParanEnCalleYNumero).

% 4. b. lineasQueParan(+Calle, +Numero, -Lineas)
lineasQueParan(Calle, Numero, Lineas) :-
  setof(Linea, lineaQuePara(Calle, Numero, Linea) , Lineas).

% lineaQuePara(+Calle, +Numero, -Linea).
lineaQuePara(Calle, Numero, Linea) :-
  parada(Calle, Numero, LineasQueParanEnCalleYNumero),
  member(Linea, LineasQueParanEnCalleYNumero).

% 5. Extender parada/3
% parada(?Calle, ?Numero, ?Lineas)
parada(Calle, Numero, Lineas) :-
  esquina(Calle, Numero, OtraCalle, _),
  paradaEsquina(Calle, OtraCalle, Lineas).

parada(Calle, Numero, Lineas) :-
  esquina(OtraCalle, _, Calle, Numero),
  paradaEsquina(OtraCalle, Calle, Lineas).

% 6. paradaCercana(+Calle, +Numero, +Distancia, ?Parada)
paradaCercana(Calle, Numero, Distancia, Parada) :-
  paradaCercanaEnMismaCalle(Calle, Numero, Distancia, Parada).

paradaCercana(Calle, Numero, Distancia, Parada) :-
  esquina(Calle, NumeroEsquinaCalle, CalleInterseccion, NumeroEsquinaCalleInterseccion),
  NumeroEsquinaCalle =< Numero + Distancia,
  NumeroEsquinaCalle >= Numero - Distancia,
  DistanciaRestante is Distancia - abs(Numero - NumeroEsquinaCalle), 
  paradaCercanaEnMismaCalle(CalleInterseccion, NumeroEsquinaCalleInterseccion, DistanciaRestante, Parada).

paradaCercana(Calle, Numero, Distancia, Parada) :-
  esquina(CalleInterseccion, NumeroEsquinaCalleInterseccion, Calle, NumeroEsquinaCalle),
  NumeroEsquinaCalle =< Numero + Distancia,
  NumeroEsquinaCalle >= Numero - Distancia,
  DistanciaRestante is Distancia - abs(Numero - NumeroEsquinaCalle), 
  paradaCercanaEnMismaCalle(CalleInterseccion, NumeroEsquinaCalleInterseccion, DistanciaRestante, Parada).

% paradaCercanaEnMismaCalle(+Calle, +Numero, +Distancia, ?Parada)
paradaCercanaEnMismaCalle(Calle, Numero, Distancia, Parada) :-
  NumeroMinimo is Numero - Distancia,
  NumeroMaximo is Numero + Distancia,
  between(NumeroMinimo, NumeroMaximo, NumeroParadaCercana),
  parada(Calle, NumeroParadaCercana, Lineas),
  Parada = parada(Calle, NumeroParadaCercana, Lineas).

% 7. pasaPor(+Recorrido, ?Calle, ?Numero)


% 8. recorrido(+CalleOrig, +NumOrig, +CalleDest, +NumDest, +Dist,
%              +CantTrasbordos, -Recorrido)


% ------------------------------------------------------------------------------
% Predicado auxiliar

% diferentes(+Calle1, +Numero1, +Calle2, +Numero2)
diferentes(Calle1, _, Calle2, _) :- Calle1 \= Calle2, !.
diferentes(_, Numero1, _, Numero2) :- Numero1 \= Numero2.