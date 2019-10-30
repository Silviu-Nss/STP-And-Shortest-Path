head(L, X) :- L = cons(X, _).

tail(L, X) :- L = cons(_, X).

empty(L) :- L = void.

nonempty(L) :- L = cons(_, _).

head2(L, X) :- L = [X|_].
tail2(L, X) :- L = [_|X].
empty2(L) :- L = [].
nonempty2(L) :- L = [_|_].

len([], 0).
len([_|Tail], X) :- len(Tail, Y), X is Y+1.

contains(E, [Head|_]):- E = Head.
contains(E, [Head | Tail]):- E \= Head, contains(E, Tail). 

member(E, [E|_]).
member(E, [_|Tail]) :- member(E, Tail).

rev([], Acc, Acc).
rev([Head|Tail], Acc, R) :- rev(Tail, [Head|Acc], R).
                


reverse(L, R) :- rev(L, [], R).