/* See LICENSE file for copyright and license details. */

static void view_next_tag(const Arg *);
static void view_prev_tag(const Arg *);
static void view_adjacent_tag(const Arg *, int);
static void focusandmvmon(const Arg *);

/* appearance */
static const char font[]            = "-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#222222";
static const char normbgcolor[]     = "#3f3f3f";
static const char normfgcolor[]     = "#bebebe";
static const char selbordercolor[]  = "#333333";
static const char selbgcolor[]      = "#1f1f1f";
static const char selfgcolor[]      = "#bebebe";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            True,        -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       False,       -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]",      tile },    /* first entry is default */
	{ "~",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggletag,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define RIPDEV(KEY, RANK) { Mod4Mask, KEY, spawn, SHCMD("/home/phil/bin/ripdev.sh --export=/home/phil/bin/ripdev_status.txt --choose_by_rank="RANK)},


/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "urxvtc", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ ControlMask,                  XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY|ControlMask,           XK_Left,   focusandmvmon,  {.i = -1 } },
	{ MODKEY|ControlMask,           XK_Right,  focusandmvmon,  {.i = +1 } },
	{ ControlMask,                  XK_Left,   view_prev_tag,  {0} },
	{ ControlMask,                  XK_Right,  view_next_tag,  {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	RIPDEV(                         XK_F1,                     "0")
	RIPDEV(                         XK_F2,                     "1")
	RIPDEV(                         XK_F3,                     "2")
	RIPDEV(                         XK_F4,                     "3")
	RIPDEV(                         XK_F5,                     "4")
	RIPDEV(                         XK_F6,                     "5")
	RIPDEV(                         XK_F7,                     "7")
	RIPDEV(                         XK_F8,                     "8")
	RIPDEV(                         XK_F9,                     "9")
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

static void
view_adjacent_tag(const Arg *arg, int distance)
{
    int i, curtags;
    int seltag = 0;
    Arg a;

    curtags = selmon->tagset[selmon->seltags] ^ (arg->ui & TAGMASK);
    for (i = 0; i < LENGTH(tags); i++)
        if ((curtags & (1 << i)) != 0) {
            seltag = i;
            break;
        }

    seltag = (seltag + distance) % (int)LENGTH(tags);
    if (seltag < 0)
        seltag += LENGTH(tags);

    /* lock on first and last tag */
    if ((distance == 1 && seltag != 0) ||
            (distance == -1 && seltag != (LENGTH(tags)-1)))
    {
        a.i = (1 << seltag);
        view(&a);
    }

    return;
}

static void
view_next_tag(const Arg *arg)
{
    (void)arg;
    view_adjacent_tag(arg, +1);
    return;
}

static void
view_prev_tag(const Arg *arg)
{
    (void)arg;
    view_adjacent_tag(arg, -1);
    return;
}

static void
focusandmvmon(const Arg *arg)
{
	Monitor *m = NULL;
	if (!mons->next)
		return;
	m = dirtomon(arg->i);
	unfocus(selmon->sel, False);
	selmon = m;
	focus(NULL);
	XWarpPointer(dpy, None, RootWindow(dpy, DefaultScreen(dpy)), 0, 0, 0, 0,
			selmon->mx + selmon->mw / 2, selmon->my + selmon->mh /2 );
}


