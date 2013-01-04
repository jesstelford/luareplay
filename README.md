# Record and Replay

Record and replay table properties based on discrete time steps (*Key Frames*)
with the ability to interpolate between Frames, allowing time independant
replay.

# Unit Testing

[Busted, Elegant Lua unit testing](http://olivinelabs.com/busted/)

    $ cd /path/to/luareplay
    $ busted

# Notes

## Serialization

Serialization of tables is performed by [Paul Kulchenko's](http://notebook.kulchenko.com/) [serpent library](https://github.com/pkulchenko/serpent)

# License

This software is covered under the FreeBSD License. See LICENSE for more.
