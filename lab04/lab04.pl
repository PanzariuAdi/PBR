language(armeana).
language(persana).
language(greaca).
language(aramaica).


same_person_different_languages(X,Y):-
	language(X),
	language(Y),
	X\==Y.

different_languages(X, Y, Z, T):-
	language(X),
	language(Y),
	language(Z),
	language(T),
	X\==Z, X\==T,
	Y\==Z, Y\==T.
	
same_language(X, Y, Z, T):-
	language(X),
	language(Y),
	language(Z),
	language(T),
	((X==Z,Y\==T);(X==T, Y\==Z);((Y==Z, X\==T); (Y==T, X\==Z))).

lang_diff(X,Y,Z):-
	language(X),
	language(Y),
	X\==Z,
	Y\==Z.
	
lang_aa(X,Y,Z,T):-
	language(X),
	language(Y),
	\+((X==Z,Y==T);(X==T,Y==Z)).


professors_unique(Salal1, Salal2, Atar1, Atar2, Zaman1, Zaman2):-
(same_language(Salal1, Salal2, Atar1, Atar2), same_language(Atar1, Atar2, Zaman1, Zaman2), different_languages(Salal1, Salal2, Zaman1, Zaman2));
(same_language(Salal1, Salal2, Atar1, Atar2), same_language(Salal1, Salal2, Zaman1, Zaman2), different_languages(Atar1, Atar2, Zaman1, Zaman2));
(same_language( Zaman1, Zaman2, Atar1, Atar2), same_language(Salal1, Salal2, Zaman1, Zaman2), different_languages(Atar1, Atar2, Salal1, Salal2)).


professors(Salal1, Salal2, Atar1, Atar2, Eber1, Eber2, Zaman1, Zaman2 ):-

same_person_different_languages(Salal1,Salal2),
same_person_different_languages(Atar1,Atar2),
same_person_different_languages(Eber1,Eber2),
same_person_different_languages(Zaman1,Zaman2),

Eber1=aramaica,

lang_diff(Zaman1, Zaman2, aramaica),
lang_diff(Salal1, Salal2, persana),

lang_aa(Salal1, Salal2, aramaica, armeana),
lang_aa(Atar1, Atar2, aramaica, armeana),
lang_aa(Zaman1, Zaman2, aramaica, armeana),

different_languages(Atar1, Atar2, Eber1, Eber2),

same_language(Salal1, Salal2, Atar1, Atar2),
same_language(Salal1, Salal2, Eber1, Eber2),

same_language(Eber1, Eber2, Zaman1, Zaman2),

professors_unique(Salal1, Salal2, Atar1, Atar2, Zaman1, Zaman2).

