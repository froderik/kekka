kekka
=====

Kekka is a thin ruby library on top of the XML format [ISAF XRR](http://www.sailing.org/xml) (XML Regatta Reporting). In its first version it takes care of parsing the XML and putting data in convenient hashes - it also manages the relations between different data sets. In future versions exports will be supported also.


Usage
-----

To get hold of it:

    require 'kekka'

To create a kekka:

    kekka = Kekka.parse open('/path/to/xrr')

The argument to parse can be exactly the same as what [nokogiris](http://nokogiri.org/) [parse method](http://nokogiri.org/Nokogiri/XML/Document.html#method-c-parse) accepts. A kekka is actually a Hash so it is possible to use all Hash methods on it and its parts. The resulting Hash is structured exactly as the XML. On the first level there are persons, boats, teams and events. Symbols are used to get collectionesque subparts. For example - to get to boats:

    kekka[:boats]

Elements that got an idea are put in a Hash with the id as key. So to get to the boat with id '9':

    kekka[:boats]['9']

Attributes are downcased (by nokogiri) and used as keys in the Hash for its instance. To get the sail number for a boat:

    kekka[:boats]['9']['sailnumber']

Events have a deeper structure inside. To get to races for the event with id '9':

    kekka[:events]['9'][:races]

To get the race status for the race with id '32':

    kekka[:events]['9'][:races]['32']['racestatus']

It is starting to get deep now and it is probably wise to split such a thing into parts.

    event = kekka[:events]['9']
    race = event[:races]['32']
    race['racestatus']

The event also have divisions that contains both race results and series results (the latter being the sum of race results for a team). Results does not have ids so they are represented with an array. You would probably want to get all results for a race in a division and could then do seomthing like:

    event = kekka[:events]['9']
    division = event[:divisions]['4711']
    division[:raceresults].select { |one_result| one_result['raceid'] == '32' }

Doing things like this easier may be added in future versions.


Copyright
---------

Copyright (c) 2012 Fredrik Rubensson. See LICENSE.txt for further details.

