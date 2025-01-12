*What it does*

This script will attempt to locate all episodes in a specific directory, recursively looking
in sub-directories as well. This script does, in order:

1) files are copied from their original location to a working directory so the originals are
   untocuhed.
2) files not needed by Sonarr will be removed to clean things up.
4) episodes will be placed into a folder if not already (a requirement of Sonarr's import).
5) Sonarr's import will be called via api and found episodes will be added.
6) the working directory will have any stale files and directories cleaned up.

*Options*

You specify where the files to be processed are located (INBOX), and where the files will be
moved to for processing (OUTBOX) so the originals are left unaltered.

Once in the OUTBOX, the files are processed.

When complete, empty directories in the OUTBOX are removed and any remaining files not
processed and that exceed a certain number of days in age that you set (CLEAN) are removed.

*Why*

Sonarr is very good at what it does, but sometimes you need to alter files or have them in a
location that Sonarr doesn't support. Thanks to its api, it allows some customization to make
changes before importing.

For me, I needed to do some pre-processing on files via a script before Sonarr imported them.
There is no way to do this "out of the box" with Sonarr, hence this script which allows an
import to be done after whatever scripts your download client calls are run.

Note: this script used to offer pre and post processing script calls. Technically, you should
do this with a script run from your BT client that calls any processing scripts, this one, and
then any post-processing scripts.  See my other scripts for items that you may want to
include.