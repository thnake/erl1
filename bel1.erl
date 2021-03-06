-module(bel1).
-compile(export_all).
-compile(debug_info).

%-export([encode/2, decode/2, createCodeTree/1]).
% bel1:decode(bel1_tests:exampleTree(),[1,0,0,0,0,1,1,1,1,1,1,1,0,0]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ein Huffman Code wird durch einen Binaermaum repraesentiert.
%
%  Jedes Blatt beinhaltet ein Zeichen, das durch den Baum kodiert wird.
%  Das Gewicht entspricht der Haeufigkeit des Vorkommens eines Zeichen innerhalb eines Texts.
%    
%  Die inneren Knoten repraesentieren die Kodierung. Die assoziierten Zeichen weisen auf die 
%  darunter liegenden Blaetter. Das Gewicht entspricht der Summe aller Zeichen, die darunter liegen.
% 
%
% Definition of the Tree: two kinds of nodes:
% fork - representing the inner nodes (binary tree)
% leaf - representing the leafs of the tree
%
-type tree():: fork() | leaf().

-record(fork, {left::tree(), right::tree(), chars::list(char()), weight::non_neg_integer()}).
-type fork() :: #fork{}.
-record(leaf, {char::char(), weight::non_neg_integer()}).
-type leaf() :: #leaf{}.
-type bit() :: 0 | 1. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Basisfunktionen
-spec weight(tree()) -> non_neg_integer().
weight(#fork{weight=W}) -> W;
weight(#leaf{weight=W}) -> W.

-spec chars(tree()) -> list(char()).
chars(#fork{chars=C}) -> C;
chars(#leaf{char=C}) -> [C].

createOrderedList() -> [#leaf{char=$a, weight=5},#leaf{char=$b, weight=6},#leaf{char=$c, weight=7},
									#leaf{char=$d, weight=8},#leaf{char=$e, weight=14}].


% Erzeugung eines CodeTrees aus zwei Teilbaeumen
% Aus Gruenden der Testbarkeit werden links die Teilbaeume mit dem alphabetisch kleinerem Wert der 
% Zeichenketten angeordnet. 
-spec makeCodeTree( T1::tree(), T2::tree()) -> tree().
makeCodeTree(T1 , T2) -> toBeDefined.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Erzeugung eines Huffman Trees
%
%   Schreiben Sie eine Funktion createFrequencies, die aus einem Text die Haeufigkeiten des Vorkommens
%   eines Zeichen in der Zeichenkette berechnet.
% 
%  Ergebnis der Funktion soll eine Liste von Zweiertupeln sein, die als erstes Element den Character und als 
%  zweites die Haeufigkeit enthaelt.
%
%  createFrequencies("Dies ist ein Test") waere also [{$D,1}, {$i,3}, {$e,3}, {$s, 3}, {$ , 3}, {$t, 2}, {$n, 1}, {$T,1}] 
%  
%  Auf die Elemente eines Tupels kann ueber Pattern Matching zugegriffen werden: 
%  z.B. {X,Y} = {$a,4}
%  Tipp: Splitten Sie die Funktion auf:
%  1. Funktion zum Eingliedern des Buchstabens in die Tupelliste (z.B. addLetter(...))
%  2. Aufruf der Funktion fuer jeden Buchstaben
%



countChar([], Letter, N) -> [{Letter, N}];
countChar([ T | Ext], Letter, N) when T =:= Letter -> countChar(Ext, Letter, N+1);
countChar([ T | Ext], Letter, N) -> countChar(Ext, Letter, N).

member(_,[])->false;
member(X,[X|_])->true;
member(X,[_|YS])->member(X,YS).

scanText([], List, Result)-> Result;
scanText([T|Ext], List, Result)->  case member(T, List) of
true  -> scanText(Ext, List, Result) ;       
false -> scanText(Ext,  List++[T], Result++countChar(Ext, T, 1))
end.


% Setze Die Liste Zusammen 
% addLetter([], C, W)-> [{C, W}];
% addLetter(List, C, W) -> List ++ [{C, W}].



-spec addLetter(list({char(),non_neg_integer()}), char())-> list({char(), non_neg_integer()}).
addLetter(TupelList, Char) -> toBeDefined.

-spec createFrequencies(list(char())) -> list({char(), non_neg_integer()}).
createFrequencies(Text) -> scanText(Text, [], []).

%  Erzeugung eines Blattknotens fuer jeden Buchstaben in der Liste
%  Aufsteigendes Sortieren der Blattknoten nach den Haeufigkeiten der Vorkommen der Buchstaben
%  z.B. aus makeOrderedLeafList([{$b,5},{$d,2},{$e,11},{$a,7}])
% wird [#leaf{char=$d,weight=2},#leaf{char=$b,weight=5},#leaf{char=$a,weight=7},#leaf{char=$e,weight=11}]
-spec makeOrderedLeafList(FreqList::list({char(), non_neg_integer()})) -> list(leaf()).
makeOrderedLeafList(FreqList) -> lists:keysort(3,transformToLeaf(FreqList,[])).

transformToLeaf([], Acc)-> Acc;
transformToLeaf([{C,W}|Tail], Acc)-> transformToLeaf(Tail,Acc++[#leaf{char = C, weight = W}]).



%  Bei jedem Aufruf von combine sollen immer zwei Teilbaeume (egal ob fork oder leaf) zusammenfuegt werden.
%  Der Parameter der Funktion combine ist eine aufsteigend sortierte Liste von Knoten.
%
%  Die Funktion soll die ersten beiden Elemente der Liste nehmen, die Baeume zusammenfuegen
%  und den neuen Knoten wieder in die Liste einfuegen sowie die zusammengefuegten aus der Liste 
%  loeschen. Dabei sollen der neue Knoten so eingefuegt werden, dass wieder eine sortierte Liste von
%  Knoten entsteht.
%
%  Ergebnis der Funktion soll wiederum eine sortierte Liste von Knoten sein.
% 
%  Hat die Funktion weniger als zwei Elemente, so soll die Liste unveraendert bleiben.
%  Achtung: Ob die vorgefertigten Tests funktionieren, haengt davon ab, auf welcher Seite die Knoten
%  eingefuegt werden. Die Tests sind genau dann erfolgreich, wenn Sie die Baeume so kombinieren, dass 
%  ein Baum entsteht, der so angeordnet ist, wie im Beispiel auf dem Aufgabenblatt. Sorgen Sie dafuer,
%  dass die Teilbaeume ebenso eingefuegt werden (erhoehter Schwierigkeitsgrad) oder schreiben Sie eigene
%  Tests. 

%-spec combine(list(tree())) -> list(tree()).
%combine(list(tree())) -> list(tree()).
		

combine([]) -> [];
combine([TreeList]) when length([TreeList]) < 2 -> TreeList;
combine([X,Y | Rest]) when is_record(X, fork),is_record(Y, fork)-> lists:sort(fun bel1:compareForkLeaf/2,
                                                    [#fork{
                                                    left=X,
                                                    right=Y,
                                                    chars=[X#fork.chars | Y#fork.chars],
                                                    weight=X#fork.weight + Y#fork.weight} | Rest]);


combine([X,Y | Rest]) when is_record(X, fork),is_record(Y, leaf)-> lists:sort(fun bel1:compareForkLeaf/2,
                                                    [#fork{
                                                    left=X,
                                                    right=Y,
                                                    chars=X#fork.chars++[Y#leaf.char],
                                                    weight=X#fork.weight + Y#leaf.weight} | Rest]);


combine([X,Y | Rest]) when is_record(X, leaf),is_record(Y, fork)-> lists:sort(fun bel1:compareForkLeaf/2,
                                                    [#fork{
                                                    left=X,
                                                    right=Y,
                                                    chars=[X#leaf.char]++Y#fork.chars,
                                                    weight=X#leaf.weight + Y#fork.weight} | Rest]);


combine([X,Y | Rest]) when is_record(X, leaf),is_record(Y, leaf)  -> lists:sort(fun bel1:compareForkLeaf/2,
                                                    [#fork{
                                                    left=X,
                                                    right=Y,
                                                    chars=[X#leaf.char,Y#leaf.char],
                                                    weight=X#leaf.weight + Y#leaf.weight} | Rest]);
combine(Leaf) -> [Leaf].



compareForkLeaf(X,Y) when is_record(X, leaf),is_record(Y, leaf) -> X#leaf.weight =< Y#leaf.weight;
compareForkLeaf(X,Y) when is_record(X, leaf),is_record(Y, fork) -> X#leaf.weight =< Y#fork.weight;
compareForkLeaf(X,Y) when is_record(X, fork),is_record(Y, leaf) -> X#fork.weight =< Y#leaf.weight;
compareForkLeaf(X,Y) when is_record(X, fork),is_record(Y, fork) -> X#fork.weight =< Y#fork.weight;
compareForkLeaf(_,_) -> true.

% c(bel1.erl).
% F = bel1:createFrequencies("abc").
% O = bel1:makeOrderedLeafList(F).c8
% bel1:combine(O).

%lists:sort(compareForkLeaf, YourList).



%  Die Funktion repeatCombine soll die Funktion combine so lange aufrufen, bis nur noch ein Gesamtbaum uebrig ist.		
-spec repeatCombine(TreeList::list(tree())) -> tree().

repeatCombine([]) -> [];
repeatCombine(TreeList) when length(TreeList) =:= 1 -> lists:nth(1,TreeList);
repeatCombine(TreeList) -> repeatCombine(combine(TreeList)).

%  createCodeTree fuegt die einzelnen Teilfunktionen zusammen. Soll aus einem gegebenen Text, den Gesamtbaum erzeugen.
-spec createCodeTree(Text::list(char())) -> tree().
createCodeTree(Text)-> repeatCombine(combine(makeOrderedLeafList(createFrequencies(Text)))).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Dekodieren einer Bitsequenz
%
% Die Funktion decode soll eine Liste von Bits mit einem gegebenen Huffman Code (CodeTree) dekodieren.
% Ergebnis soll die Zeichenkette im Klartext sein.	
-spec decode(CodeTree::tree(), list( bit())) -> list(char()).
decode(CodeTree, BitList) -> decodeTail(CodeTree, BitList, []).

decodeTail(_, [], Acc) -> Acc;
decodeTail(CodeTree, BitList, Acc) -> {C, Bits} = traverseTreeDecode(CodeTree, BitList),
                                        decodeTail(CodeTree, Bits, Acc++[C]).


traverseTreeDecode(Tree, [HS|TS]) when is_record(Tree, fork), HS =:= 0 -> traverseTreeDecode(Tree#fork.left, TS);
traverseTreeDecode(Tree, [HS|TS]) when is_record(Tree, fork), HS =:= 1 -> traverseTreeDecode(Tree#fork.right, TS);
traverseTreeDecode(Leaf, Sequence) -> {Leaf#leaf.char, Sequence}.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Kodieren einer Bitsequenz
%
%  Die Funktion encode soll eine Liste von Bits mit einem gegebenen Huffman Code (CodeTree) kodieren.
%  Ergebnis soll die Bitsequenz sein.
%
%  Gehen Sie dabei folgendermassen vor:
%  Schreiben Sie eine Funktion convert, die aus einem Codetree eine Tabelle generiert, die fuer jeden 
%  Buchstaben die jeweilige Bitsequenz bereitstellt. Dabei soll jeder Eintrag ein Tupel sein bestehend
%  aus dem Character und der Bitsequenz.
%  Also: convert(CodeTree)->[{Char,BitSeq},...]
-spec convert(CodeTree::tree()) -> list({char(), list(bit())}).
convert(CodeTree) -> lists:keysort(1, traverse([], CodeTree)).


traverse(S, Tree) when is_record(Tree, leaf) -> {Tree#leaf.char, S};
traverse(S, Tree) when Tree#fork.right == nil -> traverse(S++[0], Tree#fork.left);
traverse(S, Tree) when Tree#fork.left == nil -> traverse(S++[1], Tree#fork.right);
traverse(S, Tree) -> L = traverse(S++[0], Tree#fork.left), R = traverse(S++[1], Tree#fork.right), flatten([R,L]).


flatten(X) -> lists:reverse(flatten(X,[])).
flatten([],Acc) -> Acc;
flatten([H|T],Acc) when is_list(H) -> flatten(T, flatten(H,Acc));
flatten([H|T],Acc) -> flatten(T,[H|Acc]).                        


%  Schreiben Sie eine Funktion encode, die aus einem Text und einem CodeTree die entsprechende 
%  Bitsequenz generiert.
%  Verwenden Sie dabei die erzeugte Tabelle.
-spec encode(Text::list(char()), CodeTree::tree()) -> list(bit()).
encode(Text, CodeTree) -> flatten(encodeWorker(Text, convert(CodeTree),[])).


encodeWorker([], _, Acc) -> Acc;
encodeWorker([T|Ext], Dict, Acc) -> {_, Sequence} = lists:keyfind(T, 1, Dict), 
                                    encodeWorker(Ext, Dict, [Acc|Sequence]).




















