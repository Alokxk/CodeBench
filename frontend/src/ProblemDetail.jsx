import { useEffect, useState } from "react";

const API = "http://localhost:3000/api/v1";
const DONE = [
  "accepted",
  "wrong_answer",
  "compile_error",
  "runtime_error",
  "time_limit_exceeded",
];
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

export default function ProblemDetail({ problemId, onBack }) {
  const [problem, setProblem] = useState(null);
  const [code, setCode] = useState("");
  const [result, setResult] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [pollMsg, setPollMsg] = useState("");
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`${API}/problems/${problemId}`)
      .then((r) => {
        if (!r.ok) throw new Error("Problem not found");
        return r.json();
      })
      .then(setProblem)
      .catch((e) => setError(e.message));
  }, [problemId]);

  const handleSubmit = async () => {
    if (!code.trim()) return;
    setSubmitting(true);
    setResult(null);
    setPollMsg("Submitting...");

    try {
      const res = await fetch(`${API}/submissions`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ problem_id: problemId, code }),
      });

      if (!res.ok) {
        const e = await res.json();
        throw new Error(e.error || "Submission failed");
      }

      let sub = await res.json();
      setPollMsg("Bribing Docker to run faster...");

      while (!DONE.includes(sub.status)) {
        await sleep(2000);
        const poll = await fetch(`${API}/submissions/${sub.id}`);
        sub = await poll.json();
      }

      setResult(sub);
    } catch (e) {
      setResult({ status: "error", output: e.message });
    } finally {
      setSubmitting(false);
      setPollMsg("");
    }
  };

  const resultClass =
    {
      accepted: "accepted",
      wrong_answer: "wrong",
      compile_error: "error",
      runtime_error: "error",
      time_limit_exceeded: "error",
      error: "error",
    }[result?.status] || "";

  const resultLabel =
    {
      accepted: "Accepted",
      wrong_answer: "Wrong Answer",
      runtime_error: "Runtime Error",
      time_limit_exceeded: "Time Limit Exceeded",
      compile_error: "Compile Error",
      error: "Error",
    }[result?.status] || "";

  const resultHumor =
    {
      accepted:
        "Correct. But can you explain why it works? Or did you just get lucky?",
      wrong_answer:
        "Wrong Answer. The computer has no feelings. But it is judging you.",
      compile_error:
        "Compile Error. Python tried to read your code and gave up immediately.",
      runtime_error:
        "Runtime Error. Your code crashed harder than my motivation on Monday mornings.",
      time_limit_exceeded: "Time Limit Exceeded. O(n²) was not the move.",
      error: "Something went wrong. Even Docker is confused.",
    }[result?.status] || "";

  if (error)
    return (
      <div className="detail-container">
        <button className="detail-back-btn" onClick={onBack}>
          ← Back
        </button>
        <p style={{ color: "red" }}>{error}</p>
      </div>
    );

  if (!problem)
    return (
      <div className="detail-container">
        <button className="detail-back-btn" onClick={onBack}>
          ← Back
        </button>
        <p>Loading...</p>
      </div>
    );

  return (
    <div className="detail-container">
      <button className="detail-back-btn" onClick={onBack}>
        ← Back to Problems
      </button>

      <div className="detail-header">
        <h2>{problem.title}</h2>
        <span
          className={
            problem.difficulty === "Easy"
              ? "diff-easy"
              : problem.difficulty === "Medium"
                ? "diff-medium"
                : "diff-hard"
          }
        >
          {problem.difficulty}
        </span>
      </div>

      <div className="description-box">{problem.description}</div>

      {problem.input && (
        <div className="sample-box">
          <div className="sample-label">Sample Input</div>
          <pre>{problem.input}</pre>
        </div>
      )}

      <div className="editor-section">
        <div className="editor-label">
          Python 3 — Yes we know you prefer JavaScript. Tough.
        </div>
        <textarea
          className="code-area"
          rows={16}
          value={code}
          onChange={(e) => setCode(e.target.value)}
          placeholder="# Write your solution here..."
          spellCheck={false}
        />
      </div>

      <button
        className="submit-btn"
        onClick={handleSubmit}
        disabled={submitting || !code.trim()}
      >
        {submitting ? (
          <>
            <span className="spin" /> {pollMsg}
          </>
        ) : (
          "Submit"
        )}
      </button>

      {result && (
        <div className={`result-box ${resultClass}`}>
          <div className="result-status">{resultLabel}</div>

          {result.test_cases_total > 0 && (
            <div className="result-meta">
              {result.test_cases_passed}/{result.test_cases_total} test cases
              passed
              {result.execution_time_ms && (
                <span>
                  {" "}
                  &nbsp;·&nbsp; {(result.execution_time_ms / 1000).toFixed(2)}s
                </span>
              )}
            </div>
          )}

          <div className="result-humor">{resultHumor}</div>

          {result.output && (
            <div>
              <div className="sample-label" style={{ marginBottom: 4 }}>
                Output
              </div>
              <pre>{result.output}</pre>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
