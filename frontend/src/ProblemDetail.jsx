import { useEffect, useState } from "react";

const API = import.meta.env.VITE_API_URL || "http://localhost:3000/api/v1";

const DONE = [
  "accepted",
  "wrong_answer",
  "runtime_error",
  "time_limit_exceeded",
  "compile_error",
];
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

export default function ProblemDetail({ problemId, onBack }) {
  const [problem, setProblem] = useState(null);
  const [code, setCode] = useState("");
  const [result, setResult] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [pollMsg, setPollMsg] = useState("");
  const [loadError, setLoadError] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [answers, setAnswers] = useState([]);
  const [evaluation, setEvaluation] = useState(null);
  const [loadingQ, setLoadingQ] = useState(false);
  const [checkingA, setCheckingA] = useState(false);
  const [followupError, setFollowupError] = useState(null);
  const [timeLeft, setTimeLeft] = useState(null);

  const timeExpired = timeLeft === 0;

  useEffect(() => {
    fetch(`${API}/problems/${problemId}`)
      .then((r) => {
        if (!r.ok) throw new Error("Problem not found");
        return r.json();
      })
      .then(setProblem)
      .catch((e) => setLoadError(e.message));
  }, [problemId]);

  useEffect(() => {
    if (timeLeft === null || timeLeft <= 0) return;
    const timer = setTimeout(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearTimeout(timer);
  }, [timeLeft]);

  const handleSubmit = async () => {
    if (!code.trim()) return;
    setSubmitting(true);
    setResult(null);
    setQuestions([]);
    setAnswers([]);
    setEvaluation(null);
    setFollowupError(null);
    setTimeLeft(null);
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

      if (sub.status === "accepted") {
        setLoadingQ(true);
        try {
          const qRes = await fetch(`${API}/problems/${problemId}/followup`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ submission_id: sub.id }),
          });
          const qData = await qRes.json();
          if (qData.questions?.length > 0) {
            setQuestions(qData.questions);
            setAnswers(new Array(qData.questions.length).fill(""));
            setTimeLeft(180);
          } else {
            setFollowupError("Could not load follow-up questions.");
          }
        } catch {
          setFollowupError("Could not load follow-up questions.");
        } finally {
          setLoadingQ(false);
        }
      }
    } catch (e) {
      setResult({ status: "error", output: e.message });
    } finally {
      setSubmitting(false);
      setPollMsg("");
    }
  };

  const handleCheckAnswers = async () => {
    if (questions.length === 0) return;
    if (answers.some((a) => !a.trim())) return;
    setCheckingA(true);
    setEvaluation(null);

    try {
      const res = await fetch(
        `${API}/problems/${problemId}/followup/evaluate`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ questions, answers }),
        },
      );
      const data = await res.json();
      if (data.results) {
        setEvaluation(data.results);
        setTimeLeft(null);
      } else {
        setFollowupError("Could not evaluate answers.");
      }
    } catch {
      setFollowupError("Could not evaluate answers.");
    } finally {
      setCheckingA(false);
    }
  };

  const STATUS_CONFIG = {
    accepted: {
      label: "Accepted",
      cls: "accepted",
      humor:
        "Correct. But can you explain why it works? Or did you just get lucky?",
    },
    wrong_answer: {
      label: "Wrong Answer",
      cls: "wrong",
      humor:
        "Wrong Answer. The computer has no feelings. But it is judging you.",
    },
    runtime_error: {
      label: "Runtime Error",
      cls: "error",
      humor:
        "Runtime Error. Your code crashed harder than my motivation on Monday mornings.",
    },
    time_limit_exceeded: {
      label: "Time Limit Exceeded",
      cls: "error",
      humor: "Time Limit Exceeded. O(n²) was not the move.",
    },
    compile_error: {
      label: "Compile Error",
      cls: "error",
      humor:
        "Compile Error. Python tried to read your code and gave up immediately.",
    },
    error: {
      label: "Error",
      cls: "error",
      humor: "Something went wrong. Even Docker is confused.",
    },
  };

  const formatTime = (s) =>
    `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;

  if (loadError)
    return (
      <div className="detail-container">
        <button className="detail-back-btn" onClick={onBack}>
          ← Back
        </button>
        <p style={{ color: "red" }}>{loadError}</p>
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

  const config = STATUS_CONFIG[result?.status] || {};

  return (
    <div className="detail-container">
      <button className="detail-back-btn" onClick={onBack}>
        ← Back to Problems
      </button>

      <div className="detail-header">
        <h2>{problem.title}</h2>
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
        {submitting ? pollMsg : "Submit"}
      </button>

      {result && (
        <div className={`result-box ${config.cls}`}>
          <div className="result-status">{config.label}</div>

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

          <div className="result-humor">{config.humor}</div>

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

      {result?.status === "accepted" && (
        <div className="followup-section">
          <div className="followup-title-row">
            <div className="followup-title">
              Think you understood that? Prove it.
            </div>
            {timeLeft !== null && (
              <div
                className={`followup-timer ${timeLeft <= 30 ? "timer-warning" : ""}`}
              >
                {timeExpired ? "Time's up." : formatTime(timeLeft)}
              </div>
            )}
          </div>

          {loadingQ && (
            <p className="followup-loading">Asking Gemini to grill you...</p>
          )}

          {followupError && <p className="followup-error">{followupError}</p>}

          {questions.length > 0 && (
            <div>
              {questions.map((q, i) => (
                <div key={i} className="followup-question">
                  <div className="followup-q-text">
                    {i + 1}. {q}
                  </div>
                  <textarea
                    className="followup-answer"
                    rows={3}
                    value={answers[i] ?? ""}
                    onChange={(e) => {
                      const updated = [...answers];
                      updated[i] = e.target.value;
                      setAnswers(updated);
                    }}
                    placeholder="Type your answer..."
                    spellCheck={false}
                    disabled={!!evaluation}
                  />
                  {evaluation?.[i] && (
                    <div
                      className={`eval-result ${evaluation[i].correct ? "eval-correct" : "eval-wrong"}`}
                    >
                      {evaluation[i].correct ? "✓" : "✗"}{" "}
                      {evaluation[i].explanation}
                    </div>
                  )}
                </div>
              ))}

              {timeExpired && !evaluation && (
                <p className="followup-error">
                  Time expired. You can no longer submit answers.
                </p>
              )}

              {!evaluation && (
                <button
                  className="check-btn"
                  onClick={handleCheckAnswers}
                  disabled={
                    checkingA || answers.some((a) => !a.trim()) || timeExpired
                  }
                >
                  {checkingA ? "Checking..." : "Check Answers"}
                </button>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
