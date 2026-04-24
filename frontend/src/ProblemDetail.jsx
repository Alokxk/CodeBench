import { useEffect, useState } from "react"

const API    = "http://localhost:3000/api/v1"
const DONE   = ["accepted", "wrong_answer", "runtime_error"]
const sleep  = ms => new Promise(r => setTimeout(r, ms))

export default function ProblemDetail({ problemId, onBack }) {
  const [problem,    setProblem]    = useState(null)
  const [code,       setCode]       = useState("")
  const [result,     setResult]     = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [pollMsg,    setPollMsg]    = useState("")
  const [error,      setError]      = useState(null)

  useEffect(() => {
    fetch(`${API}/problems/${problemId}`)
      .then(r => {
        if (!r.ok) throw new Error("Problem not found")
        return r.json()
      })
      .then(setProblem)
      .catch(e => setError(e.message))
  }, [problemId])

  const handleSubmit = async () => {
    if (!code.trim()) return
    setSubmitting(true)
    setResult(null)
    setPollMsg("Submitting...")

    try {
      const res = await fetch(`${API}/submissions`, {
        method:  "POST",
        headers: { "Content-Type": "application/json" },
        body:    JSON.stringify({ problem_id: problemId, code })
      })

      if (!res.ok) {
        const e = await res.json()
        throw new Error(e.error || "Submission failed")
      }

      let sub = await res.json()
      setPollMsg("Running...")

      while (!DONE.includes(sub.status)) {
        await sleep(2000)
        const poll = await fetch(`${API}/submissions/${sub.id}`)
        sub = await poll.json()
      }

      setResult(sub)
    } catch (e) {
      setResult({ status: "error", output: e.message })
    } finally {
      setSubmitting(false)
      setPollMsg("")
    }
  }

  if (error)   return (
    <div className="detail">
      <button className="btn btn-ghost" onClick={onBack}>← Back</button>
      <p style={{ color: "#f87171" }}>{error}</p>
    </div>
  )

  if (!problem) return (
    <div className="detail">
      <button className="btn btn-ghost" onClick={onBack}>← Back</button>
      <p className="muted">Loading...</p>
    </div>
  )

  const resultClass = {
    accepted:      "accepted",
    wrong_answer:  "wrong",
    runtime_error: "error",
    error:         "error"
  }[result?.status] || ""

  const resultLabel = {
    accepted:      "Accepted",
    wrong_answer:  "Wrong Answer",
    runtime_error: "Runtime Error",
    error:         "Error"
  }[result?.status] || ""

  return (
    <div className="detail">

      <button className="btn btn-ghost" onClick={onBack}>← Back</button>

      <div className="detail-header">
        <h2>{problem.title}</h2>
        <span className={
        problem.difficulty === "Easy"   ? "diff-easy"   :
        problem.difficulty === "Medium" ? "diff-medium" :
        problem.difficulty === "Hard"   ? "diff-hard"   : ""
        }>
        {problem.difficulty}
        </span>
      </div>

      <pre className="description">{problem.description}</pre>

      {problem.input && (
        <div className="sample-block">
          <div className="label">Sample Input</div>
          <pre>{problem.input}</pre>
        </div>
      )}

      <div className="editor-wrap">
        <div className="label">Python 3</div>
        <textarea
          className="code"
          rows={16}
          value={code}
          onChange={e => setCode(e.target.value)}
          placeholder="Write your Python solution here..."
          spellCheck={false}
        />
      </div>

      <div>
        <button
          className="btn btn-primary"
          onClick={handleSubmit}
          disabled={submitting || !code.trim()}
        >
          {submitting
            ? <><span className="spin" />{pollMsg}</>
            : "Submit"
          }
        </button>
      </div>

      {result && (
        <div className={`result ${resultClass}`}>
          <div className="status">{resultLabel}</div>
          {result.output && (
            <div>
              <div className="label" style={{ marginBottom: 6 }}>Output</div>
              <pre>{result.output}</pre>
            </div>
          )}
        </div>
      )}

    </div>
  )
}