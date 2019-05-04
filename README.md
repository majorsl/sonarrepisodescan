*What it does*

This script will attempt to locate all episodes in a specific directory, recursively looking
in sub-directories as well. When found:

1) files not needed by Sonarr will be removed.
2) episodes will be placed into a folder (a requirement of Sonarr's import).
3) Sonarr's import will be called via api and found episodes will be added.

*Why*

Sonarr is very good at what it does, but seems to be designed for use only a certain way
with preconceptions about how it will be used.  Thanks to its api, it allows some customization.

For me, I needed to do some post-processing on files via a script before Sonarr imported them.
There is no way to do this "out of the box" with Sonarr, hence this script which allows pre
and post scripts to be done with importing in the middle.