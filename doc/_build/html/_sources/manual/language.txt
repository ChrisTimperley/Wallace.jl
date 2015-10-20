==============================
Language
==============================

Top-Level Structure
^^^^^^^^^^^^^^^^^^^

All specification files should contain a top-level ``type`` parameter,
stipulating the type of object described by the file. Failing to provide
a :code:`type` parameter will cause Wallace to be unable to compose the
object via the ``compose(FILE)`` function; however, the object can still
be constructing by forcing it to be constructed as a given type, using
``compose_as(FILE, TYPE)``.

::

    type: algorithm/evolutionary_algorithm

Type Labels
^^^^^^^^^^^

Certain parameters within a file may require type information, in order
to instruct Wallace how to compile them. The most common way to do this
is by appending the property name with a type tag, enclosed in angled
brackets, as shown below:

::

    selector<tournament>:
      size: 2

When the file is passed to the Wallace run-time, these type tags are
simply extracted from their property, and inserted as the ``type``
property within its object. As such, you can avoid using type tags
entirely by specifying this type property directly, as demonstrated
below:

::

    selector:
      type: tournament
      size: 2

Absolute and Relative Types
'''''''''''''''''''''''''''

In most cases, Wallace allows you to specify types either relative to
some namespace, or to give an absolute address for a given type. Below
is an example of a property that accepts types relative to the
``/selector/`` namespace, and how a type may be specified using either
relative or absolute addressing:

::

    selector<tournament>: { ... }
    selector</selector/tournament>: { ... }

Absolute types are distinguished from relative types by Wallace using
their ``\`` prefix. When in doubt as to whether a given property
supports relative type addressing, you should consult the ``help()``
function for more information.

Lists
^^^^^

Lists can either be specified in a block format, where a hypen followed
by a space denotes each item within the list, as shown below:

::

    colours:
      - red
      - yellow
      - blue

Alternatively, lists can be specified inline, by enclosing them within
square brackets and delimiting their items with a comma followed by a
space:

::

    [red, yellow, blue, green]

Associative Arrays
^^^^^^^^^^^^^^^^^^

Associative arrays are used to hold pairs of data and their respective
keys, and form the backbone of the entire language; the document itself
is an associative array. These objects are constructed using an indented
below the line of the property definition, as shown below:

::

    my_car:
      model:  Forza Corsa
      colour: Red
      year:   2011

Alternatively, one may supply an associative array definition inline,
using JSON-style opening and closing brackets. An example of such an
inline associative array is given below:

::

    {model: Forza Corsa, colour: Red, year: 2011}

Multi-Line Strings
^^^^^^^^^^^^^^^^^^

As in YAML, strings may be given across multiple lines in one of two
ways: either by using the ``|`` character to indicate that the string
should be read with its line breaks preserved; or using the ``>``
character, to specify that each line break should be replaced by a
space, transforming the multi-line string into a single line one. In
both cases, the leading indent and trailing white space on each line are
removed.

Line-Break Preserving
'''''''''''''''''''''

The line-break preserving operator when used on the following multi-line
string:

::

    lines_preserved: |
      First line
      Second line
      Third line

results in the following parsed string:

::

    First line
    Second line
    Third line

Line-Break Folding
''''''''''''''''''

The line-break folding operator, ``>``, when employed on the following
string:

::

    lines_replaced: >
      First item,
      second item,
      third item

yields a one-line string, given below:

::

    First item, second item, third item

Pointers
^^^^^^^^

Pointer tags, ``$()``, can be used to fetch the definition of an object
from a specified location within the file and place a copy of that
definition at location of the tag. An example of a simple pointer tag is
given below:

::

    people:
      alice:
        name: Alice
        age: 28
        
    book:
      title: Through the Looking-Glass
      owner: $(people.alice)

Upon parsing, the pointer is unwound, copying the contents of the object
stored at ``people.alice`` into the ``book.owner`` property, resulting
in the specification given below:

::

    people:
      alice:
        name: Alice
        age: 28
        
    book:
      title: Through the Looking-Glass
      owner:
        name: Alice
        age: 28

Pointers can also be used to fetch the contents of items contained
within lists by simply specifying the index of the item (where all list
indices start at zero) within brackets, as shown below:

::

    people:
      - name: Alice
        age: 28
      - name: Bob
        age: 28

    book:
      title: To Kill a Mockingbird
      author: $(people[1])

Comments
^^^^^^^^

Comments are opened each unenclosed number sign, ``#``, and close at the
end of the same line. In addition to taking up an entire line, comments
may consume the rest of a line following the end of a statement.

::

    # Comments can take up a whole line,
    x: 30 # or just the end of a line.

      # And indentation doesn't matter,
                # at all.

