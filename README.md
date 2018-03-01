6D6 Response Files
==================
This repository contains response files for the 6D6 datalogger in different
configurations in the `resp` folder.

Building
--------
All generated response files are already checked out into the repository.
However if you want to change anything or play with the values, you will need
to have Ruby installed. On Ubuntu you can install Ruby with the following
commands. Note that you need at least Ruby version 2.0.
```text
$ sudo apt-get update
$ sudo apt-get install build-essential ruby
```

When Ruby is installed you can recreate all the response files by typing
```text
$ make
```

The values for the response files can be customised in `lib/response.rb`.

Licence
-------
This project is licensed under the GPLv3. See the [LICENCE](LICENCE) file.
