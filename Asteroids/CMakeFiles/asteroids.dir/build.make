# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.24

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.24.2/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.24.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/levineely/Asteroids

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/levineely/Asteroids/build

# Include any dependencies generated for this target.
include CMakeFiles/asteroids.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/asteroids.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/asteroids.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/asteroids.dir/flags.make

CMakeFiles/asteroids.dir/src/Asteroids.cpp.o: CMakeFiles/asteroids.dir/flags.make
CMakeFiles/asteroids.dir/src/Asteroids.cpp.o: /Users/levineely/Asteroids/src/Asteroids.cpp
CMakeFiles/asteroids.dir/src/Asteroids.cpp.o: CMakeFiles/asteroids.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/levineely/Asteroids/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/asteroids.dir/src/Asteroids.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/asteroids.dir/src/Asteroids.cpp.o -MF CMakeFiles/asteroids.dir/src/Asteroids.cpp.o.d -o CMakeFiles/asteroids.dir/src/Asteroids.cpp.o -c /Users/levineely/Asteroids/src/Asteroids.cpp

CMakeFiles/asteroids.dir/src/Asteroids.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/asteroids.dir/src/Asteroids.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/levineely/Asteroids/src/Asteroids.cpp > CMakeFiles/asteroids.dir/src/Asteroids.cpp.i

CMakeFiles/asteroids.dir/src/Asteroids.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/asteroids.dir/src/Asteroids.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/levineely/Asteroids/src/Asteroids.cpp -o CMakeFiles/asteroids.dir/src/Asteroids.cpp.s

CMakeFiles/asteroids.dir/src/Bullet.cpp.o: CMakeFiles/asteroids.dir/flags.make
CMakeFiles/asteroids.dir/src/Bullet.cpp.o: /Users/levineely/Asteroids/src/Bullet.cpp
CMakeFiles/asteroids.dir/src/Bullet.cpp.o: CMakeFiles/asteroids.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/levineely/Asteroids/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/asteroids.dir/src/Bullet.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/asteroids.dir/src/Bullet.cpp.o -MF CMakeFiles/asteroids.dir/src/Bullet.cpp.o.d -o CMakeFiles/asteroids.dir/src/Bullet.cpp.o -c /Users/levineely/Asteroids/src/Bullet.cpp

CMakeFiles/asteroids.dir/src/Bullet.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/asteroids.dir/src/Bullet.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/levineely/Asteroids/src/Bullet.cpp > CMakeFiles/asteroids.dir/src/Bullet.cpp.i

CMakeFiles/asteroids.dir/src/Bullet.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/asteroids.dir/src/Bullet.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/levineely/Asteroids/src/Bullet.cpp -o CMakeFiles/asteroids.dir/src/Bullet.cpp.s

CMakeFiles/asteroids.dir/src/Triangle.cpp.o: CMakeFiles/asteroids.dir/flags.make
CMakeFiles/asteroids.dir/src/Triangle.cpp.o: /Users/levineely/Asteroids/src/Triangle.cpp
CMakeFiles/asteroids.dir/src/Triangle.cpp.o: CMakeFiles/asteroids.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/levineely/Asteroids/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/asteroids.dir/src/Triangle.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/asteroids.dir/src/Triangle.cpp.o -MF CMakeFiles/asteroids.dir/src/Triangle.cpp.o.d -o CMakeFiles/asteroids.dir/src/Triangle.cpp.o -c /Users/levineely/Asteroids/src/Triangle.cpp

CMakeFiles/asteroids.dir/src/Triangle.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/asteroids.dir/src/Triangle.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/levineely/Asteroids/src/Triangle.cpp > CMakeFiles/asteroids.dir/src/Triangle.cpp.i

CMakeFiles/asteroids.dir/src/Triangle.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/asteroids.dir/src/Triangle.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/levineely/Asteroids/src/Triangle.cpp -o CMakeFiles/asteroids.dir/src/Triangle.cpp.s

CMakeFiles/asteroids.dir/src/World.cpp.o: CMakeFiles/asteroids.dir/flags.make
CMakeFiles/asteroids.dir/src/World.cpp.o: /Users/levineely/Asteroids/src/World.cpp
CMakeFiles/asteroids.dir/src/World.cpp.o: CMakeFiles/asteroids.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/levineely/Asteroids/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/asteroids.dir/src/World.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/asteroids.dir/src/World.cpp.o -MF CMakeFiles/asteroids.dir/src/World.cpp.o.d -o CMakeFiles/asteroids.dir/src/World.cpp.o -c /Users/levineely/Asteroids/src/World.cpp

CMakeFiles/asteroids.dir/src/World.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/asteroids.dir/src/World.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/levineely/Asteroids/src/World.cpp > CMakeFiles/asteroids.dir/src/World.cpp.i

CMakeFiles/asteroids.dir/src/World.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/asteroids.dir/src/World.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/levineely/Asteroids/src/World.cpp -o CMakeFiles/asteroids.dir/src/World.cpp.s

CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o: CMakeFiles/asteroids.dir/flags.make
CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o: /Users/levineely/Asteroids/src/TotalBuild.cpp
CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o: CMakeFiles/asteroids.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/levineely/Asteroids/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o -MF CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o.d -o CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o -c /Users/levineely/Asteroids/src/TotalBuild.cpp

CMakeFiles/asteroids.dir/src/TotalBuild.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/asteroids.dir/src/TotalBuild.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/levineely/Asteroids/src/TotalBuild.cpp > CMakeFiles/asteroids.dir/src/TotalBuild.cpp.i

CMakeFiles/asteroids.dir/src/TotalBuild.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/asteroids.dir/src/TotalBuild.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/levineely/Asteroids/src/TotalBuild.cpp -o CMakeFiles/asteroids.dir/src/TotalBuild.cpp.s

# Object files for target asteroids
asteroids_OBJECTS = \
"CMakeFiles/asteroids.dir/src/Asteroids.cpp.o" \
"CMakeFiles/asteroids.dir/src/Bullet.cpp.o" \
"CMakeFiles/asteroids.dir/src/Triangle.cpp.o" \
"CMakeFiles/asteroids.dir/src/World.cpp.o" \
"CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o"

# External object files for target asteroids
asteroids_EXTERNAL_OBJECTS =

asteroids: CMakeFiles/asteroids.dir/src/Asteroids.cpp.o
asteroids: CMakeFiles/asteroids.dir/src/Bullet.cpp.o
asteroids: CMakeFiles/asteroids.dir/src/Triangle.cpp.o
asteroids: CMakeFiles/asteroids.dir/src/World.cpp.o
asteroids: CMakeFiles/asteroids.dir/src/TotalBuild.cpp.o
asteroids: CMakeFiles/asteroids.dir/build.make
asteroids: /opt/homebrew/lib/libsfml-graphics.2.5.1.dylib
asteroids: /opt/homebrew/lib/libsfml-window.2.5.1.dylib
asteroids: /opt/homebrew/lib/libsfml-system.2.5.1.dylib
asteroids: CMakeFiles/asteroids.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/levineely/Asteroids/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Linking CXX executable asteroids"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/asteroids.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/asteroids.dir/build: asteroids
.PHONY : CMakeFiles/asteroids.dir/build

CMakeFiles/asteroids.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/asteroids.dir/cmake_clean.cmake
.PHONY : CMakeFiles/asteroids.dir/clean

CMakeFiles/asteroids.dir/depend:
	cd /Users/levineely/Asteroids/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/levineely/Asteroids /Users/levineely/Asteroids /Users/levineely/Asteroids/build /Users/levineely/Asteroids/build /Users/levineely/Asteroids/build/CMakeFiles/asteroids.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/asteroids.dir/depend

