[![Actions Status](https://github.com/lizmat/Hash-Sorted/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Hash-Sorted/actions) [![Actions Status](https://github.com/lizmat/Hash-Sorted/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Hash-Sorted/actions) [![Actions Status](https://github.com/lizmat/Hash-Sorted/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Hash-Sorted/actions)

NAME
====

Hash::Sorted - customizable role for sorted Hashes

SYNOPSIS
========

```raku
use Hash::Sorted;

my %m is Hash::Sorted = a => 42, b => 666;  # [str,Any]

my %n is Hash::Sorted[int,str] = 42 => "a", 666 => "b";
```

DESCRIPTION
===========

This module provides the `Hash::Sorted` role, that allows you to create a Hash that always keeps its keys in sorted order. It also allows you to customize exactly how you would like to type your keys and/or your values.

Internally, this implementation works off two arrays that are being kept in sync, so any standard constraints available to arrays, can be applied as types for the keys or values.

Since `Hash::Sorted` is a role, you can also use it as a base for creating your own custom implementations of hashes.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Hash-Sorted . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2021, 2023, 2024, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

