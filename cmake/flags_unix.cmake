# don't even want the old compiler
set(LRCX_COMPILER_FLAGS "-std=c++11 -fvisibility=hidden -Wextra")

# when using AddressSanitizer, clang won't compiles with --no-undefined
if (LRCX_ENABLE_ASAN AND "!${CMAKE_CXX_COMPILER_ID}" STREQUAL "!Clang")
	set(LRCX_LINKER_FLAGS "")
else()
	set(LRCX_LINKER_FLAGS "-Wl,--no-undefined")
endif()

include_compiler_flags()

if (LRCX_WARN_AS_ERROR)
	set(LRCX_COMPILER_FLAGS "-Wall -Werror ${LRCX_COMPILER_FLAGS}")
endif()

set(IGNORED_WARNINGS
	unused-parameter
	)

foreach(warning ${IGNORED_WARNINGS})
	set(LRCX_COMPILER_FLAGS " ${LRCX_COMPILER_FLAGS} -Wno-${warning}")
endforeach()

set(CMAKE_C_FLAGS_DEBUG "-D_DEBUG ${CMAKE_C_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_DEBUG "-D_DEBUG ${CMAKE_CXX_FLAGS_DEBUG}")

set(CMAKE_C_FLAGS "${LRCX_COMPILER_FLAGS} ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${LRCX_COMPILER_FLAGS} ${CMAKE_CXX_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath='\$ORIGIN' ${LRCX_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-s ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")

set(CMAKE_SHARED_LINKER_FLAGS "${LRCX_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-s ${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")

# for fixing linking library order
set(CMAKE_CXX_CREATE_SHARED_LIBRARY " \
	<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> \
	<LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> \
	<CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG><TARGET_SONAME> -o <TARGET> \
	-Wl,--start-group <OBJECTS> <LINK_FLAGS> <LINK_LIBRARIES> -Wl,--end-group"
	)
set(CMAKE_CXX_LINK_EXECUTABLE " \
	<CMAKE_CXX_COMPILER>  <FLAGS> <CMAKE_CXX_LINK_FLAGS> -o <TARGET> \
	-Wl,--start-group <OBJECTS> <LINK_FLAGS> <LINK_LIBRARIES> -Wl,--end-group"
	)
