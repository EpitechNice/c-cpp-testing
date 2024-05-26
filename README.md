# C/C++ code testing Github Action

Custom action to build and test C/C++ projects.

The action runs the following :

- Install any required dependencies (if provided) (ubuntu packages)
- Build the project using either Make or CMake (depending on what is found).
- Run the `./tests/run_unit_tests.sh` script if found.

On error (no building method found, error on build, error on unit-testing...), the program will exit 1, to be caught by github action.

Example usage :

```yml
- uses: EpitechNice/c-cpp-testing@v1
  id: project_build
  with:
    additional_installs:
      libsdl2-dev # This will install SDL2 before doing the action
  # [...]
  ${{ steps.project_build.outputs.run_logs }} # Retreive the output of the action, and do whatever you wan with it (display it, send it by mail...)
```
