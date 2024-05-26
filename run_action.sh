#!/bin/bash

function displ() {
    local message="$1"
    local c="$2"
    local total_length=40

    local spaces_needed=$((total_length - ${#message} - 4))

    local output="${c}${c}${c}${c}${c} "
    output+="$message"
    for (( i=0; i<$spaces_needed; i++ )); do
        output+=" "
    done
    output+="${c}${c}${c}${c}${c}"

    echo "$output"
}

if [ -n "$INPUT_ADDITIONAL_INSTALLS" ]; then
    apt-get install -y $INPUT_ADDITIONAL_INSTALLS
fi

{
    echo "compilation_output<<END_OF_GITHUB_ACTION"

    building_using_cmake=$(test -f "CMakeLists.txt" && echo true || echo false)

    displ "Detecting compilation type" "="

    if [ "$building_using_cmake" = false ] && ! [ -f "Makefile" ]; then
        displ "No compilation type found" "-"
        echo "END_OF_GITHUB_ACTION"
        exit 1
    fi

    if [ "$building_using_cmake" = true ]; then
        displ "CMake detected" "-"
    else
        displ "Make detected" "-"
    fi

    displ "Building project" "="

    if [ "$building_using_cmake" = true ]; then
        displ "Creating build directory" "-"
        mkdir -p ./build/
        cd ./build/
        displ "Running CMake" "-"
        cmake .. 2>&1                   || echo "END_OF_GITHUB_ACTION" && exit 1
        displ "Building project" "-"
        cmake --build . 2>&1            || echo "END_OF_GITHUB_ACTION" && exit 1
    else
        displ "Building project" "-"
        make 2>&1                       || echo "END_OF_GITHUB_ACTION" && exit 1
    fi

    make clean 2>&1                     || echo "END_OF_GITHUB_ACTION" && exit 1

    if [ "$building_using_cmake" = true ]; then
        cd ../
        rm -rf ./build/
    fi

    displ "Running Unit Tests" "="

    if ! [ -f "./tests/run_unit_tests.sh" ]; then
        displ "No unit tests found" "-"
    else
        cd ./tests/
        ./run_unit_tests.sh 2>&1        || echo "END_OF_GITHUB_ACTION" && exit 1
        cd ./../
    fi

    echo "END_OF_GITHUB_ACTION"
} >> "$GITHUB_OUTPUT"

exit $?