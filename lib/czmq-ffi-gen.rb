require_relative "czmq-ffi-gen/czmq/ffi"
require_relative "czmq-ffi-gen/gem_version"
require_relative "czmq-ffi-gen/library_version"
require_relative "czmq-ffi-gen/errors"
require_relative "czmq-ffi-gen/signals"
CZMQ::FFI.available? or raise LoadError, "libczmq is not available"
