#!/usr/bin/env python

import os
import sys
import psutil
import datetime
import time
import subprocess

ROOT_PATH = os.path.dirname(__file__)
PIXPATH = os.path.join(os.path.expanduser("~"), "config", "dzen2")
RIPDEVPATH = os.path.join(ROOT_PATH, "ripdev_status.txt")

class RipdevStatus(object):

    def __init__(self):
        self.last_mtime = None
        self.status = ""
        super(RipdevStatus, self).__init__()

    def run(self):
        mtime = os.stat(RIPDEVPATH).st_mtime
        if mtime != self.last_mtime:
            datas = []
            with open(RIPDEVPATH, "r") as f:
                for n, line in enumerate(f.read().splitlines(), 1):
                    name, longname, status, current = line.split(";")
                    if current == "1":
                        datas.append("^fg(#ff0000)%s(F%d)^fg()" % (name, n))
                    else:
                        datas.append("%s(F%d)" % (name, n))
            self.status = " | ".join(datas)
            self.last_mtime = mtime

        return self.status

class Status(object):

    def __init__(self):
        super(Status, self).__init__()

    def run(self):
        cpu_percent = int(psutil.cpu_percent(interval = 0))
        mem_percent = int(psutil.phymem_usage().percent)
        now = datetime.datetime.now()
        date = now.strftime("%a %d %b %Y")
        time = now.strftime("%H:%M")

        cpu = "^i(%s) ^fg(white)^r(%dx10)^fg(darkgrey)^r(%dx10)^fg()" % (
                os.path.join(PIXPATH, "cpu.xbm"),
                cpu_percent,
                50 - cpu_percent,
                )
        mem = "^i(%s) ^fg(white)^r(%dx10)^fg(darkgrey)^r(%dx10)^fg()" % (
                os.path.join(PIXPATH, "mem.xbm"),
                mem_percent,
                50 - mem_percent,
                )

        status = " ".join([cpu, mem, date, time])
        return status


if __name__ == "__main__":
    print sys.argv
    if len(sys.argv) >= 2 and sys.argv[1] == "ripdev":
        extra_opts = "-xs 1 -ta c"
        Klass = RipdevStatus
    else:
        extra_opts = "-xs 2 -ta r "
        Klass = Status

    dzen = subprocess.Popen(
            ("dzen2 -x '-600' -h 15 -bg '#3f3f3f' -fn '-*-terminus-medium-r-*-*-10-*-*-*-*-*-*-*' %s" % extra_opts,),
            shell=True,
            stdin=subprocess.PIPE,
            )
    obj = Klass()
    while True:
        status = obj.run()
        dzen.stdin.write(status + "\n")
        time.sleep(1)
