# Clear existing data so running seeds twice doesn't create duplicates
Problem.destroy_all

Problem.create!([
  {
    title:           "Sum of Two Numbers",
    description:     "Read two integers, one per line. Print their sum.",
    input:           "3\n7",
    expected_output: "10"
  },
  {
    title:           "Reverse a String",
    description:     "Read a single string. Print it reversed.",
    input:           "hello",
    expected_output: "olleh"
  },
  {
    title:           "FizzBuzz",
    description:     "Print numbers 1 to 10. Replace multiples of 3 with Fizz, multiples of 5 with Buzz, multiples of both with FizzBuzz.",
    input:           "",
    expected_output: "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz"
  }
])

puts "Seeded #{Problem.count} problems"