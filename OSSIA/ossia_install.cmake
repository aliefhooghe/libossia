# Install
install(TARGETS ossia
    EXPORT ossia-targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib/static
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include)

# Install headers
function(install_headers_rec theHeaders)

    foreach(file ${theHeaders})
        get_filename_component( dir ${file} DIRECTORY)
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}" "" dir_clean "${dir}")
        install(
          FILES "${file}"
          DESTINATION "include/${dir_clean}"
          COMPONENT Devel)
    endforeach()

endfunction()

install_headers_rec("${API_HEADERS}")
if(OSSIA_PROTOCOL_MIDI)
  install_headers_rec("${OSSIA_MIDI_HEADERS}")
endif()
if(OSSIA_PROTOCOL_HTTP)
  install_headers_rec("${OSSIA_HTTP_HEADERS}")
endif()
if(OSSIA_PROTOCOL_SERIAL)
  install_headers_rec("${OSSIA_SERIAL_HEADERS}")
endif()
if(OSSIA_PROTOCOL_OSCQUERY)
  install_headers_rec("${OSSIA_OSCQUERY_HEADERS}")
endif()
if(OSSIA_PROTOCOL_WEBSOCKETS)
  install_headers_rec("${OSSIA_WS_CLIENT_HEADERS}")
endif()
if(OSSIA_C)
  install_headers_rec("${OSSIA_C_HEADERS}")
endif()
if(OSSIA_DATAFLOW)
  install_headers_rec("${OSSIA_DATAFLOW_HEADERS}")
endif()
if(OSSIA_QT)
  install_headers_rec("${OSSIA_QT_HEADERS}")
  install(
      FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/ossia-qt/Ossia/qmldir
        ${CMAKE_CURRENT_SOURCE_DIR}/ossia-qt/Ossia/Node.qml
      DESTINATION lib)
endif()
# Install export header
install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/ossia_export.h
        ${CMAKE_CURRENT_BINARY_DIR}/ossia-config.hpp
        DESTINATION include/
        COMPONENT Devel)

# Install used libraries headers
install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/variant/include/
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/nano-signal-slot/include/
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/spdlog/include/
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/chobo-shl/include/
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/brigand/include/brigand
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/fmt/fmt
        DESTINATION include
        COMPONENT Devel)

install(FILES
     ${OSSIA_3RDPARTY_FOLDER}/hopscotch-map/src/hopscotch_map.h
     ${OSSIA_3RDPARTY_FOLDER}/hopscotch-map/src/hopscotch_hash.h
     ${OSSIA_3RDPARTY_FOLDER}/hopscotch-map/src/hopscotch_set.h
        DESTINATION include/
        COMPONENT Devel)

install(
    FILES
      ${OSSIA_3RDPARTY_FOLDER}/readerwriterqueue/readerwriterqueue.h
      ${OSSIA_3RDPARTY_FOLDER}/readerwriterqueue/atomicops.h
    DESTINATION include/
    COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/GSL/include/gsl
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/asio/asio/include/asio
        DESTINATION include
        COMPONENT Devel)

install(
       FILES
         ${OSSIA_3RDPARTY_FOLDER}/asio/asio/include/asio.hpp
       DESTINATION include/
        COMPONENT Devel)
install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/websocketpp/websocketpp
        DESTINATION include
        COMPONENT Devel)

install(DIRECTORY ${OSSIA_3RDPARTY_FOLDER}/rapidjson/include/rapidjson
        DESTINATION include
        COMPONENT Devel)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/ossia/ossiaConfigVersion.cmake"
  VERSION ${ossia_VERSION}
  COMPATIBILITY AnyNewerVersion
)

export(EXPORT ossia-targets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/ossia/ossiaTargets.cmake"
  NAMESPACE ossia::
)

configure_file(../CMake/ossiaConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/ossia/ossiaConfig.cmake"
  COPYONLY
)

set(ConfigPackageLocation lib/cmake/ossia)
install(EXPORT ossia-targets
        DESTINATION "${ConfigPackageLocation}"
        NAMESPACE ossia::)

