module Rx
  abstract class Operator(T)
    abstract def apply(source : Observable(T)) : Observable(T)
  end
end
