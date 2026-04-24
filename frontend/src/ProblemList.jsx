import { useEffect, useState } from "react"

const API = "http://localhost:3000/api/v1"

export default function ProblemList({ onSelect }) {
  const [problems, setProblems] = useState([])
  const [loading, setLoading]   = useState(true)
  const [error, setError]       = useState(null)

  const diffStyle = {
    Easy:   { color: "#4ade80", fontWeight: 600 },
    Medium: { color: "#fbbf24", fontWeight: 600 },
    Hard:   { color: "#f87171", fontWeight: 600 }
  }

  useEffect(() => {
    fetch(`${API}/problems`)
      .then(res => {
        if (!res.ok) throw new Error("Failed to load problems")
        return res.json()
      })
      .then(data => { setProblems(data); setLoading(false) })
      .catch(err  => { setError(err.message); setLoading(false) })
  }, [])

  if (loading) return <p className="muted" style={{ paddingTop: 40 }}>Loading...</p>
  if (error)   return <p style={{ color: "#f87171", paddingTop: 40 }}>Error: {error}</p>

  return (
    <div>
      <p className="page-title">Problems</p>
      <p className="page-subtitle">
        Pick a problem, write your Python solution, and submit it for evaluation.
      </p>

      <table>
        <thead>
          <tr>
            <th style={{ width: 50, textAlign: "center" }}>#</th>
            <th>Title</th>
            <th style={{ width: 120, textAlign: "center" }}>Difficulty</th>
          </tr>
        </thead>
        <tbody>
          {problems.map((p, i) => (
            <tr key={p.id} onClick={() => onSelect(p.id)}>
              <td className="muted" style={{ textAlign: "center" }}>{i + 1}</td>
              <td>{p.title}</td>
              <td style={{ textAlign: "center", ...(diffStyle[p.difficulty] || { color: "#9098c0" }) }}>
                {p.difficulty}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}