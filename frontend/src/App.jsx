import { useState } from "react"
import { FaGithub } from "react-icons/fa"
import ProblemList from "./ProblemList"
import ProblemDetail from "./ProblemDetail"

export default function App() {
  const [selectedId, setSelectedId] = useState(null)

  return (
    <div className="app">

      <nav className="navbar">
        <span className="logo">CodeBench</span>
        <a
          className="github-link"
          href="https://github.com/Alokxk/CodeBench"
          target="_blank"
          rel="noreferrer"
        >
          <FaGithub />
        </a>
      </nav>

      <main>
        {selectedId === null
          ? <ProblemList onSelect={setSelectedId} />
          : <ProblemDetail
              problemId={selectedId}
              onBack={() => setSelectedId(null)}
            />
        }
      </main>

      <footer className="footer">
        <p>Built by Alok &nbsp;&mdash;&nbsp; CodeBench &copy; {new Date().getFullYear()}</p>
      </footer>

    </div>
  )
}