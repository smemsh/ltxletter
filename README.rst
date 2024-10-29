ltxletter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Makes a PDF (and optionally a DVI if given target ``dvi``) from
a text file, using the letter-writing rules from the ``a2ltx`` and
``abulleted2ltx`` scripts.

Instructions to make a new letter::

   cp -a ~/src/ltxletter/tmpl ~/path/to/letters/lettername
   cd ~/path/to/letters/lettername
   rename template lettername template*
   vim lettername{,-header}.txt
   make

Optionally modify the places commented with ``ADJUST``.

**NOTE:** there MUST be EXACTLY ONE text file in the build
directory in order for this to work.

| *author:* scott@smemsh.net
| *license:* https://spdx.org/licenses/GPL-2.0
