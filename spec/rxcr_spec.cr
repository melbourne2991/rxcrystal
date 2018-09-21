require "./spec_helper"

class MyObserver < Rx::Observer(String)
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
    observable = Rx::Observable.new(->(subscriber : Rx::Observer(String)) {
      subscriber.next("Meh")
      subscriber.next("Mo!")
      subscriber.complete
    })

    mapper = Rx::MapOperator.new(->(val : String) {
      "#{val} mapped"
    })

    otherMapper = Rx::MapOperator.new(->(val : String) {
      "#{val} again"
    })

    observable
      .pipe(mapper)
      .pipe(otherMapper)
      .subscribe(MyObserver.new)
  end
end
