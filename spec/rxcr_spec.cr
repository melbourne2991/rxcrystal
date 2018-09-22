require "./spec_helper"

include Rx

class MyObserver < Observer(String)
  def next(value)
    puts value
  end

  def complete
    puts "done!"
  end
end

describe Rx do
  # TODO: Write tests

  it "works" do
    observable = Observable.new(->(subscriber : Observer(String)) {
      subscriber.next("Meh")
      subscriber.next("Mo!")
      subscriber.complete
    })

    mapper = MapOperator(String).new { |val|
      "#{val} mapped"
    }

    otherMapper = MapOperator(String).new { |val| "#{val} again" }

    observable
      .pipe(mapper)
      .pipe(otherMapper)
      .subscribe(MyObserver.new)
  end
end
