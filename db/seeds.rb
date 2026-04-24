Problem.destroy_all

Problem.create!([
  {
    title:           "Sum of Two Numbers",
    description:     "Read two integers, one per line. Print their sum.",
    difficulty:      "Easy",
    input:           "3\n7",
    expected_output: "10"
  },
  {
    title:           "Reverse a String",
    description:     "Read a single string. Print it reversed.",
    difficulty:      "Easy",
    input:           "hello",
    expected_output: "olleh"
  },
  {
    title:           "FizzBuzz",
    description:     "Print numbers 1 to 10.\nFor multiples of 3 print Fizz.\nFor multiples of 5 print Buzz.\nFor multiples of both print FizzBuzz.",
    difficulty:      "Easy",
    input:           "",
    expected_output: "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz"
  },
  {
    title:           "Count Vowels",
    description:     "Read a string. Print the number of vowels (a, e, i, o, u) in it.",
    difficulty:      "Easy",
    input:           "hello world",
    expected_output: "3"
  },
  {
    title:           "Factorial",
    description:     "Read a non-negative integer N. Print its factorial.",
    difficulty:      "Easy",
    input:           "5",
    expected_output: "120"
  },
  {
    title:           "Is Palindrome",
    description:     "Read a string. Print True if it is a palindrome, False otherwise.",
    difficulty:      "Easy",
    input:           "racecar",
    expected_output: "True"
  },
  {
    title:           "Sum of Array",
    description:     "Read N on the first line.\nRead N space-separated integers on the second line.\nPrint their sum.",
    difficulty:      "Medium",
    input:           "5\n1 2 3 4 5",
    expected_output: "15"
  },
  {
    title:           "Max in Array",
    description:     "Read N on the first line.\nRead N space-separated integers on the second line.\nPrint the largest number.",
    difficulty:      "Medium",
    input:           "5\n3 1 4 1 5",
    expected_output: "5"
  },
  {
    title:           "Count Words",
    description:     "Read a sentence. Print the number of words in it.",
    difficulty:      "Medium",
    input:           "the quick brown fox",
    expected_output: "4"
  },
  {
    title:           "Power of Two",
    description:     "Read an integer N. Print True if N is a power of 2, False otherwise.",
    difficulty:      "Hard",
    input:           "16",
    expected_output: "True"
  }
])

puts "Seeded #{Problem.count} problems"