head([X|_], X).
tail([_|X], X).
empty([]).
nonempty([_|_]).

len([], 0) :- !.
len([_|Tail], X) :- len(Tail, Y), X is Y+1.

contains(Head, [Head|_]) :- !.
contains(E, [Head | Tail]):- E \= Head, contains(E, Tail). 

rev([], Acc, Acc) :- !.
rev([Head|Tail], Acc, R) :- rev(Tail, [Head|Acc], R).

reverse(L, R) :- rev(L, [], R).

insOrd(E, [], [E]) :- !.
insOrd(E, [H|T], R) :- E =< H, R = [E,H|T], !.
insOrd(E, [H|T], R) :- E > H, insOrd(E, T, Rez), R = [H|Rez].

root(L, R) :- getRoot(L, [1000000, 1000000], R).

getNodes([Nodes, _], Nodes).
getEdges([_, Edges], Edges).

getCvints([], _, Acc, Acc) :- !.
getCvints([[S,D,W]|T], Nodes, Acc, Rez) :- getPr(S, Nodes, Pr1), getPr(D, Nodes, Pr2), getCvints(T, Nodes, [Acc|[S,Pr1, D, Pr2, W]], Rez).

getPr(S, [S, Pr], Pr) :- !.
getPr(S, [[S, Pr]|_], Pr) :- !.
getPr(S1, [[S2, _]|T], Rez) :- S1 \= S2, getPr(S1, T, Rez).

getDist(S, [S, _, Dist, _], Dist) :- !.
getDist(S, [[S, _, Dist, _]|_], Dist) :- !.
getDist(S1, [[S2, _, _, _]|T], Rez) :- S1 \= S2, getDist(S1, T, Rez).

getRoot([], _,[-1, -1]) :- !.
getRoot([[_,P]], [R1, R2], R) :- P >= R2, R = [R1, R2], !.
getRoot([[N,P]], [_, R2], R) :- P < R2, R = [N, P], !.
getRoot([[_,P]|Tail], [R1, R2] , R) :- P >= R2, getRoot(Tail, [R1, R2], R).
getRoot([[N,P]|Tail], [_, R2] , R) :- P < R2, getRoot(Tail, [N, P], R).

ini(Graph, Root, Rez) :- getNodes(Graph, Nodes), len(Nodes, Nr), init_list(Nr, Root, [], Rez).
init_list(0, _, Acc, Acc) :- !.
init_list(N, [N, Pr], Acc, Rez) :- Nr is N - 1, init_list(Nr, [N, Pr], [[N, Pr, 0, 0] | Acc], Rez).
init_list(N, [Nod, Pr], Acc, Rez) :- N \= Nod, Nr is N - 1, init_list(Nr, [Nod, Pr], [[1000000, 1000000, 1000000, -1]|Acc], Rez).

loop(0, _, Acc, Acc) :- !.
loop(N, Edges, Dist, Rez) :- update_edges(Edges, Dist, Dist2), Nr is N - 1, loop(Nr, Edges, Dist2, Rez).

update_edges([], Dist, Dist) :- !.
update_edges([H|T], Dist, Rez) :- update(H, Dist, Dist2), update_edges(T, Dist2, Rez).

update([S,Pr1,D,Pr2,W],Dist,Rez) :- getDist(S,Dist,DistS), condition(S,Pr1,D,W,Dist,DistS,DistD,[],Dist2), check(D,Pr2,S,Pr1,W,Dist2,DistD,DistS,Rez).

condition(_, _, D, W, DistS, [[D,Pri,Dst,Par]], DistD, Acc, Rez) :- Dst > DistS + W, DistD = Dst, Rez = [Acc|[[D,Pri,Dst,Par]]], !.
condition(_, Pr, D, W, DistS, [[D,Pri,Dst,Par]], DistD, Acc, Rez) :- Dst =:= DistS + W, Pr > Pri, DistD = Dst, Rez = [Acc|[[D,Pri,Dst,Par]]], !.
condition(S, Pr, D, W, DistS, [[D,Pri,Dst,_]], DistD, Acc, Rez) :- Dst =:= DistS + W, Pr < Pri, DistD = DistS + W, Rez = [Acc|[[D,Pri,DistD,S]]], !.
condition(S, _, D, W, DistS, [[D,Pri,Dst,_]], DistD, Acc, Rez) :- Dst < DistS + W, DistD = DistS + W, Rez = [Acc|[[D,Pri,DistD,S]]], !.

condition(S, _, D, W, DistS, [[D,Pri,Dst,_]|T], DistD, Acc, Rez) :- Dst > DistS + W, DistD = Dst, Acc2 = [Acc|[[D,Pri,DistD,S]]], Rez = [Acc2|T], !.
condition(_, Pr, D, W, DistS, [[D,Pri,Dst,Par]|T], DistD, Acc, Rez) :- Dst =:= DistS + W, Pr > Pri, DistD = Dst, Acc2 = [Acc|[[D,Pri,Dst,Par]]], Rez = [Acc2|T], !.
condition(S, Pr, D, W, DistS, [[D,Pri,Dst,_]|T], DistD, Acc, Rez) :- Dst =:= DistS + W, Pr < Pri, DistD = DistS + W, Acc2 = [Acc|[[D,Pri,DistD,S]]], Rez = [Acc2|T], !.
condition(S, _, D, W, DistS, [[D,Pri,Dst,_]|T], DistD, Acc, Rez) :- Dst < DistS + W, DistD = DistS + W, Acc2 = [Acc|[[D,Pri,DistD,S]]], Rez = [Acc2|T], !.

condition(S, Pr, D, W, DistS, [[Nod,Pri,Dst,Par]|T], DistD, Acc, Rez) :- Nod \= D, condition(S, Pr, D, W, DistS, T, DistD, [Acc|[Nod,Pri,Dst,Par]], Rez).

check(_,_,_,_,W,Dist,DistS,DistD,Rez) :- DistS + W > DistD, Rez = Dist, !.
check(_,Pr1,_,Pr2,W,Dist,DistS,DistD,Rez) :- DistS + W =:= DistD, Pr1 > Pr2, Rez = Dist, !.
check(S,Pr1,D,Pr2,W,Dist,DistS,DistD,Rez) :- DistS + W =:= DistD, Pr1 < Pr2, condition(S,Pr1,D,W,Dist,DistS,DistD,[],Rez), !.
check(S,Pr1,D,_,W,Dist,DistS,DistD,Rez) :- DistS + W < DistD, condition(S,Pr1,D,W,Dist,DistS,DistD,[],Rez), !.



