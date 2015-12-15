require_relative "../spec_helper"

describe CZMQ::FFI::ZstrFix do

  context "hooking into Zstr" do
    let(:ancestors) { CZMQ::FFI::Zstr.singleton_class.ancestors }
    let(:fix_index) { ancestors.index(CZMQ::FFI::ZstrFix) }
    let(:self_index) { ancestors.index(CZMQ::FFI::Zstr.singleton_class) }
    it "is prepended" do
      assert_operator fix_index, :<, self_index
    end
  end

  let(:correct_free) { CZMQ::FFI::Zstr.method(:free) }
  let(:src) { double("source") }
  let(:str) { ::FFI::Pointer::NULL }
  let(:actual_free) do
    autopointer.instance_variable_get(:@releaser).instance_variable_get(:@proc)
  end
  describe "#recv" do
    let(:autopointer) { CZMQ::FFI::Zstr.recv(src) }
    before(:each) do
      expect(CZMQ::FFI).to receive(:zstr_recv).with(src).and_return(str)
    end

    it "uses correct free function" do
      assert_equal correct_free, actual_free
    end
  end

  describe "#str" do
    let(:autopointer) { CZMQ::FFI::Zstr.str(src) }
    before(:each) do
      expect(CZMQ::FFI).to receive(:zstr_str).with(src).and_return(str)
    end

    it "uses correct free function" do
      assert_equal correct_free, actual_free
    end
  end
end
