:- consult('main.pl'). % load main

% check if forum_pattern_2A returns correct FE5Id
check_forum_pattern_2A_result :-
    ExpectedFE5Id = 932362105613871012,
    (   forum_pattern_2A(FE5Id),
        FE5Id =:= ExpectedFE5Id ->
        write('forum_pattern_2A returned the expected value for FE5Id: '), 
        write(ExpectedFE5Id), 
        writeln('. Success.')
    ;   format('forum_pattern_2A did not return the expected value. Returned FE5Id: ~w~n', [FE5Id])
    ).

check_forum_pattern_2B_result :-
    ExpectedFE4Id = 1209342585680609487,
    (   forum_pattern_2B(FE4Id),
        FE4Id =:= ExpectedFE4Id ->
        write('forum_pattern_2B returned the expected value for FE4Id: '), 
        write(ExpectedFE4Id), 
        writeln('. Success.')
    ;   format('forum_pattern_2B did not return the expected value. Returned FE4Id: ~w~n', [FE4Id])
    ).

check_forum_pattern_2_result :-
    ExpectedForum2 = 1372844135435303981,
    ExpectedFE5Id = 932362105613871012,
    ExpectedFE4Id = 1209342585680609487,
    (   forum_pattern_2(Forum2, FE5Id, FE4Id),
        FE4Id =:= ExpectedFE4Id,
        FE5Id =:= ExpectedFE5Id,
        Forum2 =:= ExpectedForum2 ->
        write('forum_pattern_2 returned the expected value for Forum2: '), 
        write(ExpectedForum2), 
        writeln('. Success.')
    ;   format('forum_pattern_2 did not return the expected values')
    ).

check_transEvents_result :-
    ExpectedP1 = 1128501731262832684,
    ExpectedP2 = 1419850416906085161,
    ExpectedP3 = 477384404927196020,
    ExpectedP4 = 1472154222902711100,
    (
        transEvents(Person1, Person2, Person3, Person4),
        Person1 =:= ExpectedP1,
        Person2 =:= ExpectedP2,
        Person3 =:= ExpectedP3,
        Person4 =:= ExpectedP4 ->
        write('transEvents returned the expected values: '), 
        writeln('Success.')
    ;   format('transEvents did not return the     expected values')

    ).

check_person1_authors_result :-
    ExpectedP1 = 1128501731262832684,
    ExpectedFE3 = 1060309546214304182,
    (
        person1_authors(Person1, FE1, FE2, FE3),
        Person1 =:= ExpectedP1,
        FE1 =:= 1114502034902546550,
        FE2 =:= 1513662032452523252,
        FE3 =:= ExpectedFE3 ->
        writeln('Success.')
    ;   format('person1_authors did not return the expected values')
    ).

check_find_person1 :-
    (
        find_person1(Person1),
        Person1 =:=1128501731262832684 ->
        writeln('Success found Person1.')
    ; writeln('Failue. Did not find Person1')
    ).



