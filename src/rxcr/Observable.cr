module Rx
  class Observer(T)
    def next(value : T)
    end

    def complete
    end

    def error
    end
  end

  class Operator(T)
    def apply(source : Observable(T)) : Observable(T)
    end
  end

  class MapOperator(T) < Operator(T)
    class MapObserver(T) < Observer(T)
      def initialize(subscriber : Observer(T), mapper : Proc(T, T))
        @subscriber = subscriber
        @mapper = mapper
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

  class Observable(T)
    def initialize(&onSubscribe : Proc(Observer(T), Nil))
      @onSubscribe = onSubscribe
    end

    def map(&mapper : Proc(T, T))
      MapOperator(T).new(&mapper).apply self
    end

    def pipe(operator : Operator(T))
      operator.apply(self)
    end

    def subscribe(observer : Observer)
      @onSubscribe.call(observer)
    end
  end
end
