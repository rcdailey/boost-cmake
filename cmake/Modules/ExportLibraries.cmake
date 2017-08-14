include(CMakePackageConfigHelpers)

# Installation directory for all files exported for cmake configuration package.
# The version number is incorporated into the path to support multiple side-by-side
# installations of boost library.
set(BOOST_TARGET_INSTALL_DIR lib/boost-${BOOST_VERSION}/cmake CACHE INTERNAL "")

# Name of the installation export target. The name of the exported CMake script
# will also use this name (e.g. `${BOOST_EXPORT_NAME}.cmake`)
set(BOOST_EXPORT_NAME BoostTargets CACHE INTERNAL "")

# Path to the include directory path, relative to CMAKE_INSTALL_PREFIX.
set(BOOST_EXPORT_INCLUDE_PATH include/boost-${BOOST_VERSION} CACHE INTERNAL "")

function( _export_libraries )
  write_basic_package_Version_file(BoostConfigVersion.cmake
    VERSION ${BOOST_VERSION}
    COMPATIBILITY AnyNewerVersion
  )

  get_property(BOOST_FIND_PACKAGE GLOBAL PROPERTY Boost_Find_Package)
  if(BOOST_FIND_PACKAGE)
    # The list may be empty
    list(REMOVE_DUPLICATES BOOST_FIND_PACKAGE)
  endif()

  configure_file(cmake/BoostConfig.cmake.in BoostConfig.cmake @ONLY)

  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/BoostConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/BoostConfigVersion.cmake
    DESTINATION ${BOOST_TARGET_INSTALL_DIR}
  )

  # TODO: Support versioning include directories for side by side installs
  install(DIRECTORY ${BOOST_SOURCE}/boost DESTINATION ${BOOST_EXPORT_INCLUDE_PATH})

  install(EXPORT ${BOOST_EXPORT_NAME}
    DESTINATION ${BOOST_TARGET_INSTALL_DIR}
    NAMESPACE Boost::
  )
endfunction()
