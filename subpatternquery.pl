% Turn off warnings
:-style_check(-discontiguous).
:-style_check(-singleton).
:- consult('dataset_r10.pl').
:- write('Using Dataset: dataset_r10.pl'), nl.
% Graph Subpatterns

% Get ForumEvent Id that includes certain topics; Forum event 5
forum_pattern_2A(FE5Id) :-
    has_topic(FE5Id, 69871376, 1), % 1 = source is forum event, topic = outdoors
    has_topic(FE5Id, 1049632, 1), % topic = prospect park
    forumEvent(_, FE5Id, _). % check forumEvent exists

% Topics: Williamsburg, Explosion, Bomb
% forum event 4 (FE4)
forum_pattern_2B(FE4Id) :-
    has_topic(FE4Id, 127197, 1), % bomb
    has_topic(FE4Id, 179057, 1), % explosion
    has_topic(FE4Id, 771572, 1), % Williamsburg
    forumEvent(_, FE4Id, _). 

% Find Forum ID that has 2A and 2B patterns
forum_pattern_2(Forum2, FE5Id, FE4Id) :-
    forum_pattern_2A(FE5Id), % get Forum IDs with the topics
    forum_pattern_2B(FE4Id),
    include(Forum2, FE5Id), % check if forum includes both A and B forumEvents
    include(Forum2, FE4Id).

% Function to find transaction dates, find Forum Event 4 then check the dates
checkdates(ItemDate) :-
    forum_pattern_2B(FE4Id),
    forumEvent(_, FE4Id, FEDate),
    ItemDate > FEDate. % item purchased AFTER forum event
% transEvents: ID of person who has purchased Bath bomb, Pressure cooker, Ammunition
% person = buyer

% Finds Person 1
transEvents(Person1, Person2, Person3, Person4) :-
    purchase(Person1, Person2, 2869238, BBDate), % bomb bath
    checkdates(BBDate), % check if purchased after
    purchase(Person1, Person3, 271997, PCDate), % pressure cooker
    checkdates(PCDate), 
    purchase(Person1, Person4, 185785, AmmoDate), % ammunition
    checkdates(AmmoDate), 
    ammo_subpattern(Person4, Person6, Person1). % check if person 4 sold ammo to 2 people
    
% Ammo Subpattern: person 4 sold ammo to Person 1 AND Person 6
ammo_subpattern(Person4, Person6, Person1) :-
    sale(Person4, Person6, 185785, _),
    sale(Person4, Person1, 185785, _),
    dif(Person1, Person6).

% Electronic Subpattern
% Haversin formula
distance(Lat1, Lon1, Lat2, Lon2, Dis):-
    P is 0.017453292519943295,
    A is (0.5 - cos((Lat2 - Lat1) * P) / 2 + cos(Lat1 * P) * cos(Lat2 * P) * (1 - cos((Lon2 - Lon1) * P)) / 2),
    Dis is (0.621371 * 12742 * asin(sqrt(A))). % in kilometers, converted to miles
% Finds Person5: author of publication on EE AND in a publication whose org is within 30 miles to NYC
% Finds Publication with topic of EE, find author of the publication
% Finds the org-topic for the publication and check that it is NOT NYC
% Gets the coordinate for the org-topic
% calculate the distance from NYC

electronic_subpattern(Person5) :-
    % find Pub1 Id that has topic EE & close to NYC
    has_topic(Pub1, 43035, 2), % topic of EE
    % find Person5 = author of Pub1
    author(Person5, Pub1, 0), % author of a PUBLICATION = 0
    %\+ has_org(_, 60), %  skip org in NYC
    has_org(Pub1, Org), % may be more than 1
    dif(Org, 60), % org ID is not NYC=60
    topic(Org, LatA, LonA), % get the coordinates for Org
    % comparison of longitudes, latitudes to see if close to NYC within 30 miles
    % check distance of coordinates
    distance(LatA, LonA, 40.67, -73.94, Distance), % NYC coordinates from NYC topic
    Distance =< 30.0.
% Items_purchased subpattern
items_purchased(Person1) :-
    electronic_subpattern(Person5),
    transEvents(Person1, Person2, Person3, Person4),
    purchase(Person1, Person5, 11650, _). % electronics

% Forum 1 patterns
% Find Forum with Topic=NYC
forum1_NYC(Forum1) :-
    has_topic(Forum1, 60, 0), % 0 for FOrum; topic = NYC
    forum(Forum1). % check Forum1 exisits
% Forum Event with topic = Jihad
forumE_jihad(FE1, FE2, Forum1) :-
    has_topic(FE1, 44311, 1), % has topic of jihad
    has_topic(FE2, 44311, 1),
    dif(FE1, FE2), % not same forumevent
    include(Forum1, FE1), % check if a Forum contains FE1 and FE2
    include(Forum1, FE2).
% Find Forum1
forum1_subpattern(Forum1, FE1, FE2) :-
    forum1_NYC(Forum1),
    forumE_jihad(FE1, FE2, Forum1).

% Person1 authors FE1, FE2, FE3
person1_authors(Person1, FE1, FE2, FE3) :-
    forum_pattern_2(Forum2, FE5Id, FE4Id), % get Forum2
    include(Forum2, FE3), % Forum2 includes FE3
    author(Person1, FE3, 1), % Person1 authors FE3
    forum1_subpattern(Forum1, FE1, FE2), % get FE1 and FE2
    dif(Forum1, Forum2), % Forums are different
    author(Person1, FE1, 1), % author FE1 and FE2
    author(Person1, FE2, 1).

% Find person 1 using all the patterns
find_person1(Person1) :-
    person1_authors(Person1, FE1, FE2, FE3),
    items_purchased(Person1),
    person(Person1).

% Repeat timing query N times
repeat_time_query(0). % Base case, stop when count reaches 0
repeat_time_query(N) :-
    time(find_person1(P1)),
    N1 is N - 1,
    repeat_time_query(N1).

% Find all EventIds that meet the conditions
% find_all_matching_event_ids(EventIds) :-
%     findall(EventId, forum_pattern_2A(EventId), EventIds).
