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
	last_was_blank	= 0;
	bigskip		= "1em";
	smallskip	= "0.2em";
	indentations[0]	= "";
	indentations[0,"skiplen"] = "\\savedskip";

	for (i = 0; i < sz_bullet; i++)
		stretch = stretch sprintf(" ");
}

/^[[:space:]]*- / {

	off_bullet = index($0, BULLET) - 1;
	whitespace = substr($0, 0, off_bullet);
	#print("whitelen: " length(whitespace))
	rest_of_line = substr($0, off_bullet + sz_bullet + 1);

	len = indentations[indent_level,"length"];
	if (off_bullet > len || len == 0) {
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

	#print("hitoff " off " ilvl " indent_level);
	if (off == 0 && indent_level) {
		#print("hitbig");
		do_itemization_end();
	}
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
	printf("\n")

	if (last_was_blank)
		skiplen = bigskip;
	else
		skiplen = smallskip;
	indentations[indent_level,"skiplen"] = skiplen;

	leader = indentations[indent_level,"leader"];
	printf("%s\\setlength{\\parskip}{%s}\n", leader, skiplen);
	printf("%s\\begin{itemize}[itemsep=%s,parsep=0em]\n\n",
	       leader, smallskip);
}

function \
make_itemization_end ()
{
	leader = indentations[indent_level+1,"leader"];
	skiplen = indentations[indent_level,"skiplen"];
	printf("%s\\end{itemize}\n\n", leader);
	printf("%s\\setlength{\\parskip}{%s}\n\n", leader, skiplen);
}

function \
do_itemization_end ()
{
	#print("inlvl " indent_level);
	indentations[indent_level,"itemsep"] = 0;
	indent_level--;
	make_itemization_end();
}

function \
make_bullet (leader)
{
	if (last_was_blank)
		itemsep = bigskip
	else
		itemsep = smallskip
	if (indentations[indent_level,"itemsep"] != itemsep) {
		indentations[indent_level,"itemsep"] = itemsep;
		printf("%s%s\\setlength{\\itemsep}{%s}\n",
		       leader, stretch, itemsep);
	}

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
	#print("hit on indent level " indent_level \
	#      ", len " len \
	#      ", inlen " indentations[indent_level,"length"]);

	while (indentations[indent_level,"length"] > len && indent_level)
		do_itemization_end();
}
