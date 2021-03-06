require 'concurrent/configuration'
require 'concurrent/future'

module Expeditor
  class RichFuture < Concurrent::Future
    def get
      wait
      if rejected?
        raise reason
      else
        value
      end
    end

    def get_or_else(&block)
      wait
      if rejected?
        block.call
      else
        value
      end
    end

    def set(v)
      complete(true, v, nil)
    end

    def safe_set(v)
      set(v) unless complete?
    end

    def fail(e)
      super(e)
    end

    def safe_fail(e)
      fail(e) unless complete?
    end

    def executed?
      not unscheduled?
    end

    def safe_execute(*args)
      if args.empty?
        begin
          execute
        rescue Exception => e
          fail(e)
        end
      else
        super(*args)
      end
    end
  end
end
