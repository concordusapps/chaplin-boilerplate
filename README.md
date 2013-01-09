# Chaplin Boilerplate
> _name pending_

## Usage

### Setting up your environment ###
The first thing you’re going to want to do, is build a virtual environment
and install any base dependancies. You'll want `virtualenvwrapper` which can
be installed via `pip install virtualenvwrapper` if you don't already have it.

```sh
# Establish a new environment.
mkvirtualenv NAME

# Ensure we are working on the established environment.
workon NAME

# Install the node environment manager.
pip install nodeenv

# Bootstrap the node environment (this can take a while on slower computers).
nodeenv -p -j 9 -r requirements.txt

# Install local node dependencies
npm install
```

### Resuming work in an established environment ###
Setting up an environment can take awhile so thankfully resuming use of
an already set up environment is as simple as:

```sh
workon NAME
```

### Running the development server
```sh
grunt
```

### Build for distribution
```sh
grunt build
```

## License
Unless otherwise noted, all files contained within this project are liensed
under the MIT opensource license. See the included file LICENSE or visit
[opensource.org][] for more information.

[opensource.org]: http://opensource.org/licenses/MIT
