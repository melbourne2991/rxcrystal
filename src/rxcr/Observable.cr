module Rx
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

    def subscribe(observer : Observer(T))
      @onSubscribe.call(observer)
    end
  end

  class Interval < Observable(Nil)
    def initialize(intervalTime : Int32)
      @onSubscribe = ->(subscriber : Observer(Nil)) {
        spawn do
          loop do
            sleep intervalTime.second
            subscriber.next(nil)
          end
        end

        nil
      }
    end
  end
end
