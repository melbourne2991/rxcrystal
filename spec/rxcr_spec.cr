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
  it "works" do
    observable = Observable(String).new { |subscriber|
      spawn do
        loop do
          subscriber.next("Meh")
          sleep 1.second
        end
      end
    }

    mapper = MapOperator(String).new { |val|
      "#{val} mapped"
    }

    otherMapper = MapOperator(String).new do |val|
      "#{val} again"
    end

    observable
      .map { |val| "#{val} IGLOO" }
      .pipe(mapper)
      .pipe(otherMapper)
      .subscribe(MyObserver.new)

    puts "wow!"

    sleep
  end
end
