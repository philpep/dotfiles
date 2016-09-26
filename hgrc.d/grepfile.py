"""search for a pattern in specified files
"""

import re
from mercurial import commands, cmdutil, error, util, scmutil
from mercurial.i18n import _

testedwith = '3.1 3.8.1'
buglink = 'https://bitbucket.org/troter/hg-grepfile/issues'

cmdtable = {}
command = cmdutil.command(cmdtable)

@command("grepfile",
    [('0', 'print0', None, _('end fields with NUL')),
     ('a', 'text', None, _('treat all files as text')),
     ('i', 'ignore-case', None, _('ignore case when matching')),
     ('l', 'files-with-matches', None,
      _('print only filenames and revisions that match')),
     ('n', 'line-number', None, _('print matching line numbers')),
     ('r', 'rev', '', _('search the repository as it is in REV'), _('REV')),
    ] + commands.walkopts,
    _('[OPTION]... PATTERN [FILE_PATTERN]...'))
def grepfile(ui, repo, pattern, *pats, **opts):
    """search for a pattern in specified files

    Search files for a regular expression.
    """
    rev = scmutil.revsingle(repo, opts.get('rev'), None).node()

    reflags = re.M
    if opts.get('ignore_case'):
        reflags |= re.I
    try:
        regexp = util.re.compile(pattern, reflags)
    except re.error, inst:
        raise util.Abort(_("grep: invalid match pattern: %s\n") % inst)
    sep, eol = ':', '\n'
    if opts.get('print0'):
        sep = eol = '\0'

    def matchlines(body):
        begin = 0
        linenum = 0
        while True:
            match = regexp.search(body, begin)
            if not match:
                break
            mstart, mend = match.span()
            linenum += body.count('\n', begin, mstart) + 1
            lstart = body.rfind('\n', begin, mstart) + 1 or begin
            begin = body.find('\n', mend) + 1 or len(body) + 1
            lend = begin - 1
            yield linenum, mstart - lstart, mend - lstart, body[lstart:lend]

    class linestate(object):
        def __init__(self, line, linenum, colstart, colend):
            self.line = line
            self.linenum = linenum
            self.colstart = colstart
            self.colend = colend

        def __hash__(self):
            return hash((self.linenum, self.line))

        def __eq__(self, other):
            return self.line == other.line

        def __iter__(self):
            yield (self.line[:self.colstart], '')
            yield (self.line[self.colstart:self.colend], 'grep.match')
            rest = self.line[self.colend:]
            while rest != '':
                match = regexp.search(rest)
                if not match:
                    yield (rest, '')
                    break
                mstart, mend = match.span()
                yield (rest[:mstart], '')
                yield (rest[mstart:mend], 'grep.match')
                rest = rest[mend:]

    def display(fn, ctx, states):
        @util.cachefunc
        def binary():
            return util.binary(ctx.filectx(fn).data())
        for l in states:
            cols = [(fn, 'grep.filename')]
            if opts.get('line_number'):
                cols.append((str(l.linenum), 'grep.linenumber'))
            for col, label in cols[:-1]:
                ui.write(col, label=label)
                ui.write(sep, label='grep.sep')
            ui.write(cols[-1][0], label=cols[-1][1])

            if not opts.get('files_with_matches'):
                ui.write(sep, label='grep.sep')
                if not opts.get('text') and binary():
                    ui.write(" Binary file matches")
                else:
                    for s, label in l:
                        ui.write(s, label=label)
            ui.write(eol)
            if opts.get('files_with_matches'):
                break

    m = scmutil.match(repo[rev], pats, opts, default='relglob')
    m.bad = lambda x, y: False
    ctx = repo[rev]

    for fn in ctx.walk(m):
        data = ctx.filectx(fn).data()
        states = []
        for lnum, cstart, cend, line in matchlines(data):
            states.append(linestate(line, lnum, cstart, cend))
        display(fn, ctx, states)
    return 0
