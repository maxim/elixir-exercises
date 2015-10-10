fizzbuzz = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, a -> a
end

IO.puts fizzbuzz.(0,0,1) # "FizzBuzz"
IO.puts fizzbuzz.(0,1,2) # "Fizz"
IO.puts fizzbuzz.(1,0,2) # "Buzz"
IO.puts fizzbuzz.(1,2,3) # 3
