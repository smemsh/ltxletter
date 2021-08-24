#!/usr/bin/awk -f
#
# Look for the first occurrence -- at a given indentation
# level -- of a dash-bullet, used to make an unordered list
# in an ASCII text file.  Once found, output typesetting
# commands for a LaTeX itemization environment to begin,
# transforming each subsequent bullet encountered into a
# LaTeX item.  If the indentation level is reduced, end the
# itemization environment.  Catch if multiple levels of
# indentation have ended at once, and handle arbitrary
# nesting (iteratively).
#

BEGIN {
	BULLET		= "- ";
	sz_bullet	= length(BULLET);
	indent_level	= 0;
	indentations[0]	= "";
	last_was_blank	= 0;

	for (i = 0; i < sz_bullet; i++)
		stretch = stretch sprintf(" ");
}

/^[[:space:]]*- / {

	off_bullet = index($0, BULLET) - 1;
	whitespace = substr($0, 0, off_bullet);
	rest_of_line = substr($0, off_bullet + sz_bullet + 1);

	len = indentations[indent_level,"length"];
	if (off_bullet > len) {
		increment_indentation(whitespace);
	} else if (off_bullet < len)
		decrement_indentation(whitespace);

	make_bullet(whitespace);
	last_was_blank = 0;
	print(rest_of_line);

	next;
}

/^[[:space:]]*[[:graph:]]/ {

	off = index($0, $1) - 1;
	len = indentations[indent_level,"length"];
	whitespace = substr($0, 0, off);

	if (off < len)
		decrement_indentation(whitespace);
}

{
	print($0);
}

/^$/ {
	last_was_blank = 1;
	next;
}

{
	last_was_blank = 0;
}

##############################################################################

function \
make_itemization_start ()
{
	printf("\\begin{itemize}\n\n");
}

function \
make_itemization_end ()
{
	printf("\\end{itemize}\n\n");
}

function \
make_bullet (leader)
{
	if (last_was_blank)
		skiplen = "1em";
	else
		skiplen = "0.2em";

	printf("%s%s\\setlength{\\parskip}{%s}\n", leader, stretch,
						   skiplen);
	printf("%s%s\\item\n%s%s", leader, stretch,
				   leader, stretch);
}

function \
increment_indentation (leader)
{
	printf(indentations[indent_level++,"leader"]);
	indentations[indent_level,"length"] = length(leader);
	indentations[indent_level,"leader"] = leader;
	make_itemization_start();
}

function \
decrement_indentation (leader)
{
	len = length(leader);
	while (indentations[indent_level,"length"] > len) {
		indent_level--;
		printf(indentations[indent_level,"leader"]);
		make_itemization_end();
	}
}
