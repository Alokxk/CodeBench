Problem.destroy_all

Problem.create!([
  {
    title: "Two Sum",
    description: "Given an array of integers and a target, return the indices of the two numbers that add up to the target.\n\nEach input has exactly one solution. You may not use the same element twice.\n\nRead n on the first line, then n space-separated integers, then the target.",
    difficulty: "Easy",
    input: "4\n2 7 11 15\n9",
    expected_output: "0 1"
  },
  {
    title: "Valid Parentheses",
    description: "Given a string containing only '(', ')', '{', '}', '[' and ']', return True if the string is valid, False otherwise.\n\nA string is valid if every open bracket is closed by the same type of bracket in the correct order.",
    difficulty: "Easy",
    input: "()[]{}",
    expected_output: "True"
  },
  {
    title: "Binary Search",
    description: "Given a sorted array and a target, return the index of the target. Return -1 if not found.\n\nRead n on the first line, then n sorted space-separated integers, then the target.",
    difficulty: "Easy",
    input: "6\n-1 0 3 5 9 12\n9",
    expected_output: "4"
  },
  {
    title: "Reverse Linked List",
    description: "Given a linked list represented as space-separated values, reverse it and print the result.\n\nRead n on the first line, then n space-separated values.",
    difficulty: "Easy",
    input: "5\n1 2 3 4 5",
    expected_output: "5 4 3 2 1"
  },
  {
    title: "Climbing Stairs",
    description: "You are climbing a staircase with n steps. Each time you can climb 1 or 2 steps.\n\nReturn the number of distinct ways to reach the top.\n\nRead n on the first line.",
    difficulty: "Easy",
    input: "5",
    expected_output: "8"
  },
  {
    title: "Maximum Subarray",
    description: "Given an integer array, find the contiguous subarray with the largest sum and return its sum.\n\nRead n on the first line, then n space-separated integers.",
    difficulty: "Medium",
    input: "9\n-2 1 -3 4 -1 2 1 -5 4",
    expected_output: "6"
  },
  {
    title: "3Sum",
    description: "Given an integer array, return all unique triplets that sum to zero.\n\nPrint one triplet per line, each sorted in ascending order. Print triplets in lexicographic order.\n\nRead n on the first line, then n space-separated integers.",
    difficulty: "Medium",
    input: "6\n-1 0 1 2 -1 -4",
    expected_output: "-1 -1 2\n-1 0 1"
  },
  {
    title: "Longest Substring Without Repeating Characters",
    description: "Given a string, find the length of the longest substring without repeating characters.\n\nRead the string on the first line.",
    difficulty: "Medium",
    input: "abcabcbb",
    expected_output: "3"
  },
  {
    title: "Number of Islands",
    description: "Given a 2D grid of '1's (land) and '0's (water), return the number of islands.\n\nRead m and n on the first line, then m rows of n space-separated values.",
    difficulty: "Medium",
    input: "4 5\n1 1 1 1 0\n1 1 0 1 0\n1 1 0 0 0\n0 0 0 0 0",
    expected_output: "1"
  },
  {
    title: "Coin Change",
    description: "Given coins of different denominations and a total amount, return the fewest coins needed to make up that amount. Return -1 if it is not possible.\n\nRead n on the first line, then n coin values, then the target amount.",
    difficulty: "Hard",
    input: "3\n1 5 11\n11",
    expected_output: "1"
  }
])

puts "Seeded #{Problem.count} problems"