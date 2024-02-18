# el.make -- an Emacs¹ Lisp Make file
#
# Copyright (C) 2024 Christian Schwarzgruber (cschwarzgruber@casch.at)
#
# Version: 0.1.0
#
# Source: https://github.com/casch-at/el.make
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# ¹ Emacs -- also known for being a text editor
#
export LC_ALL = C

# quiet mode
q = @
log = $(q)echo

emacs = emacs
batch = $(q)$(emacs) -Q --batch --no-site-file

src = src
src-el = $(wildcard $(src)/*.el)
src-elc = $(addprefix $(src)/, $(notdir $(src-el:.el=.elc)))

test = tests
test-el = $(wildcard $(test)/*.el)

# .elc pattern rule
$(src)/%.elc: $(src)/%.el
	$(log) "byte-compiling \"$<\"..."
	$(batch) -f batch-byte-compile $<

.phony: all byte-compile test clean

all: byte-compile test

byte-compile: $(src-elc)

test: $(src-el)
	$(log)
	$(log) "********************************************************************************"
	$(batch) -L $(src) -l $(test-el) -f ert-run-tests-batch-and-exit

clean:
	$(log)
	rm -f $(src-elc)
