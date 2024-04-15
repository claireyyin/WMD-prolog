:- consult('dataset01.pl').
% One Single Query for Person1
person1(Person1) :-
    % pattern 2A
    has_topic(FE5Id, 69871376, 1), % 1 = source is forum event, topic = outdoors
    has_topic(FE5Id, 1049632, 1), % topic = prospect park
    % pattern 2B
    has_topic(FE4Id, 127197, 1), % bomb
    has_topic(FE4Id, 179057, 1), % explosion
    has_topic(FE4Id, 771572, 1), % Williamsburg
    % Pattern 2 - Forum 2
    include(Forum2, FE5Id), % check if forum includes both A and B forumEvents
    include(Forum2, FE4Id),
    % Trans Events
    forumEvent(_, FE5Id, _),
    forumEvent(_, FE4Id, FEDate), % get FE4 Date
    purchase(Person1, Person2, 2869238, BBDate),
    BBDate > FEDate,
    purchase(Person1, Person3, 271997, PCDate), 
    PCDate > FEDate,
    purchase(Person1, Person4, 185785, AmmoDate),
    AmmoDate > FEDate,
    % Ammo subpattern
    sale(Person4, Person6, 185785, _),
    sale(Person4, Person1, 185785, _),
    dif(Person1, Person6),
    % Electronic subpattern,
    has_topic(Pub1, 43035, 2), % topic of EE
    % find Person5 = author of Pub1
    author(Person5, Pub1, 0), % author of a PUBLICATION = 0
    has_org(Pub1, Org), % may be more than 1
    dif(Org, 60), % org ID is not NYC=60
    topic(Org, LatA, LonA), 
    % check distance of coordinates
    distance(LatA, LonA, 40.67, -73.94, Distance), % NYC coordinates from NYC topic
    Distance =< 30.0,
    % Forum 1 Patterns
    has_topic(Forum1, 60, 0), % 0 for FOrum; topic = NYC
    forum(Forum1),
    has_topic(FE1, 44311, 1), % has topic of jihad
    has_topic(FE2, 44311, 1),
    dif(FE1, FE2), % not same forumevent
    include(Forum1, FE1), % check if a Forum contains FE1 and FE2
    include(Forum1, FE2),
    author(Person1, FE3, 1),
    include(Forum2, FE3), % Forum2 includes FE3
    dif(Forum1, Forum2), % Forums are different
    author(Person1, FE1, 1), % author FE1 and FE2
    author(Person1, FE2, 1),
    person(Person1).


distance(Lat1, Lon1, Lat2, Lon2, Dis):-
    P is 0.017453292519943295,
    A is (0.5 - cos((Lat2 - Lat1) * P) / 2 + cos(Lat1 * P) * cos(Lat2 * P) * (1 - cos((Lon2 - Lon1) * P)) / 2),
    Dis is (0.621371 * 12742 * asin(sqrt(A))). 