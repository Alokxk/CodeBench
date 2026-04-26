class GeminiService
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

  def self.generate_followup_questions(problem_title, problem_description, user_code)
    prompt = <<~PROMPT
      A user solved this programming problem:

      Problem: #{problem_title}
      Description: #{problem_description}

      Their solution:
```python
      #{user_code}
```

      Generate exactly 3 follow-up questions to test deep understanding.
      Each question must be specific to THIS solution, not generic.
      Test one of: time/space complexity, data structure choice, edge cases.

      Respond with ONLY a raw JSON array. No text before or after. No markdown.
      Format: ["question 1", "question 2", "question 3"]
    PROMPT

    response = call_gemini(prompt)
    parse_json_array(response)
  end

  def self.evaluate_answers(problem_title, questions, user_answers)
    qa_pairs = questions.each_with_index.map do |q, i|
      "Q#{i+1}: #{q}\nA#{i+1}: #{user_answers[i].to_s}"
    end.join("\n\n")

    prompt = <<~PROMPT
      Evaluate these answers about a programming problem: #{problem_title}

      #{qa_pairs}

      Evaluation rules:
      - Be lenient. Accept answers showing basic understanding even if imprecise.
      - A correct answer does not need exact terminology.
      - A wrong answer is one that shows fundamental misunderstanding.

      Respond with ONLY a raw JSON array. No text before or after. No markdown.
      Format: [{"correct": true, "explanation": "one sentence"}, ...]
      Array must have exactly #{questions.length} objects.
    PROMPT

    response = call_gemini(prompt)
    parse_json_array(response)
  end

  private

  def self.call_gemini(prompt)
    api_key = ENV["GEMINI_API_KEY"]
    raise "GEMINI_API_KEY not set" if api_key.blank?

    conn = Faraday.new(url: "#{API_URL}?key=#{api_key}") do |f|
      f.request  :json
      f.response :json
      f.adapter  Faraday.default_adapter
    end

    response = conn.post do |req|
      req.body = {
        contents: [{
          parts: [{ text: prompt }]
        }]
      }
    end

    raise "Gemini API error: #{response.status}" unless response.success?

    response.body.dig("candidates", 0, "content", "parts", 0, "text").to_s

  rescue Faraday::Error => e
    raise "Gemini request failed: #{e.message}"
  end

  def self.parse_json_array(text)
    clean = text.gsub(/```json\n?/, "").gsub(/```\n?/, "").strip
    JSON.parse(clean)
  rescue JSON::ParseError
    raise "Failed to parse Gemini response as JSON: #{text}"
  end
end