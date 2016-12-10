========
AsciiArt
========

A simple plugin that allows you drawing ASCII-art picture easier.

(Not release yet, many feature may be added in the future)

This plugin is Vundle compatiable, you can add ::

  Bundle 'pi314/AsciiArt'

into your vimrc.

After installed, this plugin creates file type ``asciiart`` and ``aa``.

Usage
-----

* Create an empty frame with fixed size 80 x 24

  - ``:NewFrame``

* Make a frame

  1.  Press ``<C-v>`` (enter visual block mode), select the area you want to make a frame
  2.  ``mf``
  3.  ``mf`` again and the frame disappear (although your original text won't be back)

* Move a block

  1.  Press ``<C-v>`` (enter visual block mode), select the area you want to move around
  2.  Use ``H``, ``J``, ``K``, ``L`` to move it

* Yank & Paste a block

  1.  Press ``<C-v>`` (enter visual block mode), select the area you want to yank
  2.  Press ``<leader>y`` to yank it
  3.  Move cursor to the position where you want to paste the yanked block, align the top-left corner
  4.  ``<leader>p``

* Show/hide color escape code

  - ``<leader>c``
  - Color escape codes on the cursor line always shows

* Toggle text wrapping

  - ``<leader>w``
