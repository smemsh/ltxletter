#!/bin/sed -rf
#
# This filter will change a plain ASCII text file
# (typically a letter or email written in my typical style)
# into a format suitable for inclusion in a LaTeX input
# stream.  Basically we just escape special stuff and do a
# few other conversions for things that I use commonly and
# want to appear correctly in the output.
#
# NOTE: We assume that the stream editor has been instructed
# to use extended regular expressions.  This helps to reduce
# the amount of escaping necessary in the script itself.
#

# percents need to be doubled
s,%,\\%,g

# dollar-signs to backslash-escaped ones
s,\$,\\$,g

# ASCII smileys to wasysym package smileys
s,:\),$\\smiley$,g

# ASCII winks to wasysym black smileys (no winks so we use black)
s,;\),$\\blacksmiley$,g

# ASCII frown to wasysym package "frownie"
s,:\(,$\\frownie$,g

# ASCII emdashes to TeX ones
s,--,---,g

# emdashes to their TeX equivalents
s,\.\.\.,{\\ldots},g

# verbose escape tilde, which is used for n~ etc
s,~,{\\textasciitilde{}},g

# pound designates parameters for macros and must be escaped
s,#,\\#,g

# ellipses to their TeX equivalents
/^[[:blank:]]+\*[[:blank:]]+\*[[:blank:]]+\*[[:blank:]]*$/ c\
\\begin{center}\
\t\\textbullet\
\t\\textbullet\
\t\\textbullet\
\\end{center}

# "quoted strings" to ``quoted strings,'' possibly multiline
s,"([[:graph:]]+),``\1,g
s,([[:graph:]]+)",\1'',g

# 'this' to `that'
s,'([[:graph:]]+)',`\1',g

# make **blah blah** bold TeX, possibly multiline
s,\*\*([[:graph:]]+),\\textbf{\1,g
s,([[:graph:]]+)\*\*,\1},g

# make *blah blah* italicized TeX, possibly multiline
s,\*([[:graph:]]+),\\textsl{\1,g
s,([[:graph:]]+)\*,\1},g

# urls can use hyperref package escape \url{}
s,https?://[^[:space:]"]+,\\url{\0},g
