Problem.destroy_all

Problem.create!([
  {
    title: "Two Sum",
    description: "Given an array of integers and a target, return the indices of the two numbers that add up to the target.\nEach input has exactly one solution. You may not use the same element twice.\nRead n on the first line, then n space-separated integers, then the target.",
    difficulty: "Easy",
    input: "4\n2 7 11 15\n9",
    expected_output: "0 1",
    test_cases: [
      { "input" => "4\n2 7 11 15\n9", "expected_output" => "0 1" },
      { "input" => "3\n3 2 4\n6",     "expected_output" => "1 2" },
      { "input" => "2\n3 3\n6",       "expected_output" => "0 1" },
      { "input" => "4\n1 5 3 7\n8",   "expected_output" => "1 2" }
    ]
  },
  {
    title: "Valid Parentheses",
    description: "Given a string containing only '(', ')', '{', '}', '[' and ']', return True if the string is valid, False otherwise.\nA string is valid if every open bracket is closed by the same type of bracket in the correct order.",
    difficulty: "Easy",
    input: "()[]{}",
    expected_output: "True",
    test_cases: [
      { "input" => "()",     "expected_output" => "True"  },
      { "input" => "()[]{}", "expected_output" => "True"  },
      { "input" => "(]",     "expected_output" => "False" },
      { "input" => "([)]",   "expected_output" => "False" },
      { "input" => "{[]}",   "expected_output" => "True"  }
    ]
  },
  {
    title: "Binary Search",
    description: "Given a sorted array and a target, return the index of the target. Return -1 if not found.\nRead n on the first line, then n sorted space-separated integers, then the target.",
    difficulty: "Easy",
    input: "6\n-1 0 3 5 9 12\n9",
    expected_output: "4",
    test_cases: [
      { "input" => "6\n-1 0 3 5 9 12\n9", "expected_output" => "4"  },
      { "input" => "6\n-1 0 3 5 9 12\n2", "expected_output" => "-1" },
      { "input" => "1\n5\n5",             "expected_output" => "0"  },
      { "input" => "3\n1 3 5\n3",         "expected_output" => "1"  }
    ]
  },
  {
    title: "Reverse Linked List",
    description: "Given a linked list represented as space-separated values, reverse it and print the result.\nRead n on the first line, then n space-separated values.",
    difficulty: "Easy",
    input: "5\n1 2 3 4 5",
    expected_output: "5 4 3 2 1",
    test_cases: [
      { "input" => "5\n1 2 3 4 5", "expected_output" => "5 4 3 2 1" },
      { "input" => "2\n1 2",       "expected_output" => "2 1"       },
      { "input" => "1\n1",         "expected_output" => "1"         },
      { "input" => "3\n3 2 1",     "expected_output" => "1 2 3"     }
    ]
  },
  {
    title: "Climbing Stairs",
    description: "You are climbing a staircase with n steps. Each time you can climb 1 or 2 steps.\nReturn the number of distinct ways to reach the top.\nRead n on the first line.",
    difficulty: "Easy",
    input: "5",
    expected_output: "8",
    test_cases: [
      { "input" => "1", "expected_output" => "1"  },
      { "input" => "2", "expected_output" => "2"  },
      { "input" => "3", "expected_output" => "3"  },
      { "input" => "5", "expected_output" => "8"  },
      { "input" => "6", "expected_output" => "13" }
    ]
  },
  {
    title: "Maximum Subarray",
    description: "Given an integer array, find the contiguous subarray with the largest sum and return its sum.\nRead n on the first line, then n space-separated integers.",
    difficulty: "Medium",
    input: "9\n-2 1 -3 4 -1 2 1 -5 4",
    expected_output: "6",
    test_cases: [
      { "input" => "9\n-2 1 -3 4 -1 2 1 -5 4", "expected_output" => "6"  },
      { "input" => "1\n1",                       "expected_output" => "1"  },
      { "input" => "5\n5 4 -1 7 8",              "expected_output" => "23" },
      { "input" => "3\n-2 -1 -3",                "expected_output" => "-1" }
    ]
  },
  {
    title: "3Sum",
    description: "Given an integer array, return all unique triplets that sum to zero.\nPrint one triplet per line, each sorted in ascending order. Print triplets in lexicographic order.\nRead n on the first line, then n space-separated integers.",
    difficulty: "Medium",
    input: "6\n-1 0 1 2 -1 -4",
    expected_output: "-1 -1 2\n-1 0 1",
    test_cases: [
      { "input" => "6\n-1 0 1 2 -1 -4", "expected_output" => "-1 -1 2\n-1 0 1" },
      { "input" => "3\n0 0 0",           "expected_output" => "0 0 0"           },
      { "input" => "3\n1 2 3",           "expected_output" => ""                }
    ]
  },
  {
    title: "Longest Substring Without Repeating Characters",
    description: "Given a string, find the length of the longest substring without repeating characters.\nRead the string on the first line.",
    difficulty: "Medium",
    input: "abcabcbb",
    expected_output: "3",
    test_cases: [
      { "input" => "abcabcbb", "expected_output" => "3" },
      { "input" => "bbbbb",    "expected_output" => "1" },
      { "input" => "pwwkew",   "expected_output" => "3" },
      { "input" => "a",        "expected_output" => "1" }
    ]
  },
  {
    title: "Number of Islands",
    description: "Given a 2D grid of '1's (land) and '0's (water), return the number of islands.\nRead m and n on the first line, then m rows of n space-separated values.",
    difficulty: "Medium",
    input: "4 5\n1 1 1 1 0\n1 1 0 1 0\n1 1 0 0 0\n0 0 0 0 0",
    expected_output: "1",
    test_cases: [
      { "input" => "4 5\n1 1 1 1 0\n1 1 0 1 0\n1 1 0 0 0\n0 0 0 0 0", "expected_output" => "1" },
      { "input" => "4 5\n1 1 0 0 0\n1 1 0 0 0\n0 0 1 0 0\n0 0 0 1 1", "expected_output" => "3" },
      { "input" => "1 1\n1",                                            "expected_output" => "1" },
      { "input" => "1 1\n0",                                            "expected_output" => "0" }
    ]
  },
  {
    title: "Coin Change",
    description: "Given coins of different denominations and a total amount, return the fewest coins needed to make up that amount. Return -1 if it is not possible.\nRead n on the first line, then n coin values, then the target amount.",
    difficulty: "Hard",
    input: "3\n1 5 11\n11",
    expected_output: "1",
    test_cases: [
      { "input" => "3\n1 5 11\n11", "expected_output" => "1"  },
      { "input" => "3\n1 2 5\n11",  "expected_output" => "3"  },
      { "input" => "2\n2 5\n3",     "expected_output" => "-1" },
      { "input" => "1\n1\n0",       "expected_output" => "0"  }
    ]
  }
])

puts "Seeded #{Problem.count} problems"