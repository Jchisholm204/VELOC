# Building
To build/install VeloC there are two workflows: Development and Production.

## Production
The production workflow is the original workflow from [ECP-VeloC/VELOC](https://github.com/ECP-VeloC/VELOC).

To execute the production workflow, follow the example from the [quick start guide (shown below).](https://veloc.readthedocs.io/en/latest/quick.html#download-and-install)

```
$git clone -b 'veloc-x.y' --depth 1 https://github.com/ECP-VeloC/veloc.git <source_dir>
$cd <source_dir>
$./bootstrap.sh
$./auto-install.py <install_dir>
```

While the original `bootstrap.sh` script has been modified, it is still compatible with the original build system.
*Note:* Dependencies will be cloned into `$(REPO_DIR)/deps`, these are not used within the Python based build process.
The Python build process will clone dependencies directly from GitHub into a temp folder (`/tmp/veloc` by default).
These dependencies will be deleted automatically at the end of the install process when the `--debug` flag is not set.

## Development
To support custom development of multiple modules concurrently, a `Makefile` based build system was added on top of the original VeloC build system.
The `Makefile` works in conjunction with the `configure.sh` script, and incrementally builds only changed files for rapid prototyping.

### Configuration
Like with the original system, the [`bootstrap.sh`](./bootstrap.sh) must be run prior to building.
This build script clones the needed dependencies into the `./deps` folder, in addition to setting up the necessary Python dependencies.

After running [`bootstrap.sh`](./bootstrap.sh), dependency folders may be replaced with symlinks to custom dependency locations.
This allows rapid prototyping between VeloC and its dependency modules.

### Building
After running [`bootstrap.sh`](./bootstrap.sh), `make` can be used to build all dependencies and the VeloC executable.

The Makefile automatically builds all targets present in the `deps` folder.
Thus, if a dependency is missing, the build process may fail.

The default target `make all`, will build the dependencies and install them to the directory set with `INSTALL_PREFIX`.
With the exception of dependency options, all configuration variables available within the Python build system are also available within the Makefile.
