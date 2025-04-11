% Define números possíveis
num(1). num(2). num(3). num(4).

% Planejamento usando goal regression determinística
goal_regression_plan(InitialState, FinalState, Plan) :-
    regress_backtrack(FinalState, InitialState, [], [], Plan).

% Caso base: chegamos ao estado inicial
regress_backtrack(State, State, Plan, _, Plan).

% Caso recursivo
regress_backtrack(CurrentState, InitialState, PartialPlan, Visited, Plan) :-
    \+ member(CurrentState, Visited),  % Evita ciclos
    find_filled_cell(CurrentState, Row, Col, Num),
    clear_cell(CurrentState, Row, Col, NewState),
    regress_backtrack(
        NewState,
        InitialState,
        [remove(Row, Col, Num) | PartialPlan],
        [CurrentState | Visited],
        Plan
    ).

% Encontra a primeira célula preenchida (varredura determinística)
find_filled_cell(State, Row, Col, Num) :-
    nth1(Row, State, RowList),
    nth1(Col, RowList, Num),
    Num \= 0.

% Remove o número em (Row, Col)
clear_cell(State, Row, Col, NewState) :-
    nth1(Row, State, RowList),
    replace(RowList, Col, 0, NewRowList),
    replace(State, Row, NewRowList, NewState).

% Substitui um elemento na lista
replace([_|T], 1, X, [X|T]).
replace([H|T], Pos, X, [H|NewT]) :-
    Pos > 1,
    NextPos is Pos - 1,
    replace(T, NextPos, X, NewT).
