import { useEffect, useState } from "react";

const API = "http://localhost:3000/api/v1";

export default function ProblemList({ onSelect }) {
  const [problems, setProblems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`${API}/problems`)
      .then((r) => {
        if (!r.ok) throw new Error("Failed to load problems");
        return r.json();
      })
      .then((data) => {
        setProblems(data);
        setLoading(false);
      })
      .catch((e) => {
        setError(e.message);
        setLoading(false);
      });
  }, []);

  if (loading)
    return (
      <div className="container">
        <p style={{ padding: "40px 20px" }}>Loading...</p>
      </div>
    );

  if (error)
    return (
      <div className="container">
        <p style={{ padding: "40px 20px", color: "red" }}>Error: {error}</p>
      </div>
    );

  return (
    <div className="container">
      <div className="page-header">
        <h2>Problems</h2>
        <p className="page-subtitle">
          Your code runs in a Docker container. Don't ask why it's slow.
        </p>
      </div>

      <div className="table-responsive">
        <table className="table">
          <thead>
            <tr>
              <th>S.No.</th>
              <th>Problem</th>
              <th>Difficulty</th>
            </tr>
          </thead>
          <tbody>
            {problems.map((p, i) => (
              <tr key={p.id} onClick={() => onSelect(p.id)}>
                <td>{i + 1}</td>
                <td className="title-cell">{p.title}</td>
                <td>
                  <span
                    className={
                      p.difficulty === "Easy"
                        ? "diff-easy"
                        : p.difficulty === "Medium"
                          ? "diff-medium"
                          : "diff-hard"
                    }
                  >
                    {p.difficulty}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
