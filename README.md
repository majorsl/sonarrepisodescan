*What it does*

This script will attempt to locate all episodes in a specific directory, recursively looking
in sub-directories as well. This script does, in order:

1) files are copied from their original location to a working directory so the originals are
   untocuhed.
2) any pre-processing scripts are run.
3) files not needed by Sonarr will be removed to clean things up.
4) episodes will be placed into a folder (a requirement of Sonarr's import).
5) Sonarr's import will be called via api and found episodes will be added.
6) the working directory will have any stale files and directories cleaned up.
7) any post-processing scripts are run.

*Options*

You specify where the files to be processed are located (INBOX), and where the files will be
moved to for processing (OUTBOX) so the originals are left unaltered.

Once in the OUTBOX, you can optionally run any additional script(s) you specify (PRESCRIPT1/2)
which is useful if you need to run any additional processes on files (re-muxing etc.) The
files are then imported and, finally, an optional script (POSTSCRIPT) can to run before the
script terminates.

When complete, empty directories in the OUTBOX are removed and any remaining files not
processed and that exceed a certain number of days in age that you set (CLEAN) are removed.

*Why*

Sonarr is very good at what it does, but sometimes you need to alter files or have them in a
location that Sonarr doesn't support. Thanks to its api, it allows some customization to make
changes before importing.

For me, I needed to do some pre-processing on files via a script before Sonarr imported them.
There is no way to do this "out of the box" with Sonarr, hence this script which allows pre
and post scripts to be done with importing in the middle.