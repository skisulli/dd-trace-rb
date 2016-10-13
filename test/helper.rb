require 'minitest'
require 'minitest/autorun'

require 'ddtrace/encoding'
require 'ddtrace/tracer'
require 'ddtrace/buffer'
require 'ddtrace/span'

# Return a test tracer instance with a faux writer.
def get_test_tracer
  Datadog::Tracer.new(writer: FauxWriter.new)
end

# FauxWriter is a dummy writer that buffers spans locally.
class FauxWriter < Datadog::Writer
  def initialize
    @trace_buffer = Datadog::TraceBuffer.new(10)
    @services = {}
  end

  def spans
    @trace_buffer.pop().flatten
  end
end