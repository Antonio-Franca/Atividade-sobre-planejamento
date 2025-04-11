% Define números possíveis
num(1). num(2). num(3). num(4).

% Planejamento usando goal regression com eliminação aleatória
goal_regression_plan(FinalState, InitialState, Plan) :-
    copy_term(FinalState, CurrentState),
    regress_backtrack(CurrentState, InitialState, [], Plan).

% Base case: Se o estado inicial é alcançado, paramos.
regress_backtrack(InitialState, InitialState, Plan, Plan).

% Retrocesso com eliminação aleatória
regress_backtrack(CurrentState, InitialState, PartialPlan, Plan) :-
    % Encontra todas as células preenchidas
    find_all_filled_cells(CurrentState, FilledCells),

    % Escolhe aleatoriamente uma célula preenchida
    random_member(cell(Row, Col, Num), FilledCells),

    % Remove o número da célula
    clear_cell(CurrentState, Row, Col, NewState),

    % Continua a regressão com diferentes possibilidades
    (
        regress_backtrack(NewState, InitialState, [remove(Row, Col, Num) | PartialPlan], Plan)
    ;
        fail
    ).

% Encontra todas as células preenchidas no estado
find_all_filled_cells(State, FilledCells) :-
    findall(cell(Row, Col, Num),
            (nth1(Row, State, RowList),
             nth1(Col, RowList, Num),
             Num \= 0),
            FilledCells).

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