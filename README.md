# Record and Replay

Record and replay table properties based on discrete time steps __Key Frames__
with the ability to interpolate between Frames, allowing time independant
replay.

# Setup

    $ git clone https://github.com/jesstelford/luareplay.git
    $ cd luareplay.git
    $ git submodule init
    $ git submodule update

# Unit Testing

[Busted, Elegant Lua unit testing](http://olivinelabs.com/busted/)

    $ cd /path/to/luareplay
    $ busted

# Notes

## Serialization

Serialization of tables is performed by [Paul Kulchenko's](http://notebook.kulchenko.com/) [serpent library](https://github.com/pkulchenko/serpent)

# License

This software is covered under the FreeBSD License. See LICENSE for more.
