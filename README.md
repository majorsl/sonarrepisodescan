*What it does*

This script will attempt to locate all episodes in a specific directory, recursively looking
in sub-directories as well. This script does:

1) files not needed by Sonarr that were downloaded will be removed to clean things up.
2) episodes will be placed into a folder (a requirement of Sonarr's import).
3) Sonarr's import will be called via api and found episodes will be added.

*Options*

You specify where the files to be processed are located (INBOX), and where the files will be
moved to for processing (OUTBOX) so the originals are left unaltered.

Once in the OUTBOX, you can optionally run any additional script you specify (PRESCRIPT)
which is useful if you need to run any additional processes on files (re-muxing etc.) The
files are then imported and, finally, an optional script (POSTSCRIPT) can to run before the
script terminates.

*Why*

Sonarr is very good at what it does, but sometimes you need to alter files or have them in a
location that Sonarr doesn't support. Thanks to its api, it allows some customization to make
changes before importing.

For me, I needed to do some pre-processing on files via a script before Sonarr imported them.
There is no way to do this "out of the box" with Sonarr, hence this script which allows pre
and post scripts to be done with importing in the middle.