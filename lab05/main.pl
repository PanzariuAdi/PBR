edge(1,4).
edge(2,4).
edge(3,2).
edge(4,3).
edge(4,5).
edge(5,6).


connected(X,Y) :- edge(X,Y).

path(A,B,Path) :-
       travel(A,B,[],Q), 
       reverse(Q,Path).

travel(A,B,P,[A-B|P]) :- 
       connected(A,B).
travel(A,B,Visited,Path) :-
       connected(A,C),           
       C \== B,
       \+member(A-C,Visited),
       travel(C,B,[A-C|Visited],Path).  


len([], LenResult):-
        LenResult is 0.

len([_|Y], LenResult):-
        len(Y, L),
        LenResult is L + 1.

list(L):-
        findall(X-Y,edge(X,Y),L).

eulerian(A,B,Path,List,Length1, Length2):-
        path(A,B,Path),
        list(List),

        len(Path,Length1),
        len(List, Length2),

        Length1==Length2.

rule(A,B):-
    (eulerian(A,B,Path,List, Length1, Length2), write("Este drum eulerian : "), write(Path));
    (\+(eulerian(A,B,Path,List, Length1, Length2)), path(A,B,Path), write("Nu este drum eulerian : "), write(Path)).
