
if (NOT SETUP_DIR)
    set(SETUP_DIR ${CMAKE_CURRENT_LIST_DIR})
endif()
get_filename_component(SETUP_DIR ${SETUP_DIR} ABSOLUTE)
# if (NOT GENERATOR)
    # set(GENERATOR "Visual Studio 14 2015 Win64")
# endif ()
if (CMAKE_BUILD_TYPE)
    set(CONFIGURATION_TYPES ${CMAKE_BUILD_TYPE})
elseif (NOT CONFIGURATION_TYPES)
    set(CONFIGURATION_TYPES Debug Release)
endif ()
message(STATUS "SETUP_DIR: ${SETUP_DIR}")
message(STATUS "GENERATOR: ${GENERATOR}")
message(STATUS "CONFIGURATION_TYPES: ${CONFIGURATION_TYPES}")

if (CMAKE_BUILD_TYPE)
    set (SPECIFY_BUILD_TYPE "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
endif ()
if (GENERATOR)
    set(SPECIFY_GENERATOR -G ${GENERATOR})
endif ()

find_package(Git REQUIRED)

include(common.cmake)


FIND_PATH (AnyDSL_runtime_DIR anydsl_runtime-config.cmake
    PATHS
        ${AnyDSL_runtime_DIR}
        $ENV{AnyDSL_runtime_DIR}
        ${SETUP_DIR}/runtime/build
    PATH_SUFFIXES
        share/AnyDSL_runtime/cmake
)
message ( STATUS "AnyDSL_runtime_DIR: ${AnyDSL_runtime_DIR}" )

FIND_PATH (IMPALA_DIR impala-config.cmake
    PATHS
        ${IMPALA_DIR}
        $ENV{IMPALA_DIR}
        ${SETUP_DIR}/impala/build
    PATH_SUFFIXES
        share/impala/cmake
)
message ( STATUS "IMPALA_DIR: ${IMPALA_DIR}" )

SET ( STINCILLA_URL "https://github.com/AnyDSL/stincilla" )

clone_repository(stincilla ${STINCILLA_URL})
# TODO: perform the following steps for different backends
configure_build(stincilla/build_cpu -DIMPALA_DIR=${IMPALA_DIR} -DAnyDSL_runtime_DIR=${AnyDSL_runtime_DIR} -DBACKEND=cpu)
compile(stincilla/build_cpu --target sharpening)
run_tests(stincilla/build_cpu)
