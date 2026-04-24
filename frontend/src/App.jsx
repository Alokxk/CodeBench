import { useState } from "react";
import { FaGithub } from "react-icons/fa";
import ProblemList from "./ProblemList";
import ProblemDetail from "./ProblemDetail";

export default function App() {
  const [selectedId, setSelectedId] = useState(null);

  return (
    <div className="app">
      <nav className="navbar">
        <span className="logo">CodeBench</span>
        <div className="github-icon">
          <a
            href="https://github.com/Alokxk/CodeBench"
            target="_blank"
            rel="noreferrer"
          >
            <FaGithub />
          </a>
        </div>
      </nav>

      {selectedId === null ? (
        <ProblemList onSelect={setSelectedId} />
      ) : (
        <ProblemDetail
          problemId={selectedId}
          onBack={() => setSelectedId(null)}
        />
      )}

      <footer className="footer">
        <p>
          &copy; {new Date().getFullYear()} CodeBench &mdash; Built by Alok.
          Docker containers were harmed in the making of this.
        </p>
      </footer>
    </div>
  );
}
