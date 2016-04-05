# copied from https://bitbucket.org/sr105/terse-status/raw/tip/terse-status.py
import os
from mercurial import extensions, context, scmutil


def _buildstatus(orig, self, other, s, match, listignored, listclean,
                listunknown):
    s = orig(self, other, s, match, listignored, listclean,
             listunknown)
    if not listunknown:
        return s

    unknown = s[4]
    results = set()
    knowndirs = set([''])  # root is always known

    for path in self:
        d = os.path.dirname(path)
        while d not in knowndirs:
            knowndirs.add(d)
            d = os.path.dirname(d)

    for path in unknown:
        prev = path
        d = os.path.dirname(prev)
        while d not in knowndirs:
            prev = d
            d = os.path.dirname(prev)

        if prev != path:
            results.add(prev + '/')
        else:
            results.add(path)

    try:
        was_status = isinstance(s, scmutil.status)
    except AttributeError:
        was_status = False
    s = list(s)
    s[4] = list(results)
    return scmutil.status(*s) if was_status else s


def extsetup(ui):
    if not ui.plain():
        extensions.wrapfunction(context.workingctx,
                                '_buildstatus', _buildstatus)
