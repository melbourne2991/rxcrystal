module Rx
  class MapOperator(T) < Operator(T)
    private class MapObserver(T) < Observer(T)
      def initialize(@subscriber : Observer(T), @mapper : Proc(T, T))
      end

      def next(value : T)
        @subscriber.next(@mapper.call(value))
      end

      def complete
        @subscriber.complete
      end

      def error
        @subscriber.error
      end
    end

    def initialize(&mapper : Proc(T, T))
      @mapper = mapper
    end

    def apply(source : Observable(T))
      Observable(T).new { |subscriber|
        source.subscribe(MapObserver.new(subscriber, @mapper))
      }
    end
  end
end
