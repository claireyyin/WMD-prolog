% partialmatch.pl
% Turn off warnings
:-style_check(-discontiguous).
:-style_check(-singleton).
:- consult('dataset_min.pl').
:- dynamic has_topic/3.
:- dynamic purchase/4.
:- dynamic sale/4.
:- write('Using Dataset: dataset_min.pl'), nl.
%Partial Matching
% process_file('dataset_min.pl', 'output.txt').
% Read file, process each line, and save results
process_file(InputFile, OutputFile) :-
    open(InputFile, read, InStream),
    open(OutputFile, write, OutStream),
    open('new_db.pl', write, NewDBStream),  % Open new database file
    process_lines(InStream, OutStream, NewDBStream),
    close(InStream),
    close(OutStream),
    close(NewDBStream).
    % consult('new_db.pl'),  % Load the new database
    % (   find_person1(Person1)  % Call find_person1 on new_db
    % ->  writeln('Person1 found in new_db: '), writeln(Person1)
    % ;   writeln('No match found in new_db')
    % ).

process_lines(InStream, OutStream, NewDBStream) :-
    read(InStream, Term),
    (   Term == end_of_file
    ->  true  % Stop if end of file
    ;   
        (   process_hastopic(Term, OutStream, NewDBStream) -> true; true ),
        (   process_purchase(Term, OutStream, NewDBStream) -> true; true ),
        (   process_sale(Term, OutStream, NewDBStream) -> true; true ),
        % (   process_newDB(Term, NewDBStream) -> true; true),
        process_lines(InStream, OutStream, NewDBStream)  % Continue processing
    ).

process_hastopic(Term, OutStream, NewDBStream) :-
    Term =.. [Predicate | Args],  % Decompose Term into Predicate and Args
    (  
        Predicate == has_topic  % Check if the predicate is has_topic
    ->  
        Args = [_, TopicId, _],  % Extract arguments
        (   
            (TopicId = 69871376 ; TopicId = 1049632; TopicId = 43035; TopicId = 127197 ; TopicId = 179057; TopicId = 771572; TopicId=60; TopicId=44311)  % Match allowed topic IDs
        ->  
            asserta(Term),  % Assert the fact dynamically
            format(NewDBStream, '~q.~n', [Term]),  % Save fact in new_db.pl
            format(OutStream, 'Fact asserted: ~w~n', [Term])
        ;   
            format(OutStream, 'No match found for: ~w~n', [Term])
        )
    ).
% # forum_pattern_2(Forum2, FE5Id, FE4Id) :-
% #     forum_pattern_2A(FE5Id), % get Forum IDs with the topics
% #     forum_pattern_2B(FE4Id),
% #     include(Forum2, FE5Id), % check if forum includes both A and B forumEvents
% #     include(Forum2, FE4Id).

process_forumEvent(Term, OutStream, NewDBStream) :-
    Term =.. [Predicate | Args],  % Decompose Term into Predicate and Args
    (  
        Predicate == forumEvent  % Check if the predicate is forumEvent
    ->  
        Args = [_, ForumId, _],  % Extract ForumId from arguments
        (
            has_topic(ForumId, _)  % Check if ForumId exists in has_topic in NewDB
        ->  
            asserta(Term),  % Assert the fact dynamically
            format(NewDBStream, '~q.~n', [Term]),  % Save fact in new_db.pl
            format(OutStream, 'Fact asserted: ~w~n', [Term])
        ;   
            format(OutStream, 'No matching forumId found for: ~w~n', [Term])
        )
    ).

process_purchase(Term, OutStream, NewDBStream) :-
    Term =.. [Predicate | Args],  % Decompose Term into Predicate and Args
    (  
        Predicate == purchase  % Check if the predicate is purchase
    ->  
        Args = [_, _, ItemID, _],  % Extract arguments
        (   
            (ItemID = 2869238 ; ItemID= 271997; ItemID=185785)  % Match allowed topic IDs
        ->  
            asserta(Term),  % Assert the fact dynamically
            format(NewDBStream, '~q.~n', [Term]),  % Save fact in new_db.pl
            format(OutStream, 'Fact asserted: ~w~n', [Term])
        ;   
            format(OutStream, 'No match found for: ~w~n', [Term])
        )
    ).

process_sale(Term, OutStream, NewDBStream) :-
    Term =.. [Predicate | Args],  % Decompose Term into Predicate and Args
    (  
        Predicate == sale  % Check if the predicate is purchase
    ->  
        Args = [_, _, ItemID, _],  % Extract arguments
        (   
            (ItemID=185785)  % Match allowed topic IDs
        ->  
            asserta(Term),  % Assert the fact dynamically
            format(NewDBStream, '~q.~n', [Term]),  % Save fact in new_db.pl
            format(OutStream, 'Fact asserted: ~w~n', [Term])
        ;   
            format(OutStream, 'No match found for: ~w~n', [Term])
        )
    ).


% Process each term, check subpattern rules, and assert facts into new_db if valid
process_term(Term, OutStream, NewDBStream) :-
    (   Term =.. [publication | _]
    ;   Term =.. [forumEvent | _]
    ;   Term =.. [forum | _]
    ;   Term =.. [person | _]
    ;   Term =.. [topic | _]
    ;   Term =.. [author | _]
    ;   Term =.. [has_topic | _]
    ;   Term =.. [sale | _]
    ;   Term =.. [purchase | _]
    ;   Term =.. [include | _]
    ;   Term =.. [has_org | _]
    ),
    (   forum_pattern_2A(FE5Id),
            forum_pattern_2B(FE4Id),
            forum_pattern_2(Forum2, FE5Id, FE4Id),
            transEvents(Person1, Person2, Person3, Person4),
            ammo_subpattern(Person4, Person6, Person1),
            electronic_subpattern(Person5),
            items_purchased(Person1),
            forum1_NYC(Forum1),
            forumE_jihad(FE1, FE2, Forum1),
            forum1_subpattern(Forum1, FE1, FE2),
            person1_authors(Person1, FE1, FE2, FE3)
    ->  assertz(Term),  % Assert fact into Prolog's dynamic database
        format(NewDBStream, '~q.~n', [Term]),  % Save fact in new_db.pl
        format(OutStream, 'Fact asserted: ~w~n', [Term])
    ;   format(OutStream, 'No match found for: ~w~n', [Term])
    ).