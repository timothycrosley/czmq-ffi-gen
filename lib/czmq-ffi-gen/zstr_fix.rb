module CZMQ::FFI
  # This module is used to fix the generated implementation of two methods on
  # {Zstr}. They return fresh strings which have to be freed later. Normally
  # this would be done by the generated code using a call to {LibC::free}, but
  # in this case, {::free} must be used to keep Windows happy.
  #
  # In order to to this, this module is prepended to the class methods of
  # {Zstr}.
  #
  # @see https://github.com/zeromq/czmq/issues/1251
  module ZstrFix
    # Receive C string from socket. Caller must free returned string using
    # zstr_free(). Returns NULL if the context is being terminated or the
    # process was interrupted.
    #
    # @param source [::FFI::Pointer, #to_ptr]
    # @return [::FFI::AutoPointer]
    def recv(source)
      result = ::CZMQ::FFI.zstr_recv(source)
      result = ::FFI::AutoPointer.new(result, method(:free))
      result
    end
    # Accepts a void pointer and returns a fresh character string. If source
    # is null, returns an empty string.
    #
    # @param source [::FFI::Pointer, #to_ptr]
    # @return [::FFI::AutoPointer]
    def str(source)
      result = ::CZMQ::FFI.zstr_str(source)
      result = ::FFI::AutoPointer.new(result, method(:free))
      result
    end
  end

  class Zstr
    class << self
      prepend ZstrFix
    end
  end
end
