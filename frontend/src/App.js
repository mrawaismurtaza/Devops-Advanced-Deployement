import React, { useEffect, useState } from "react";
import axios from "axios";
import "./App.css";

function App() {
  const [projects, setProjects] = useState([]);
  const [formData, setFormData] = useState({ title: "", description: "", link: "" });

  useEffect(() => {
    axios.get("http://localhost:5000/projects").then((res) => setProjects(res.data));
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await axios.post("http://localhost:5000/projects", formData);
    setProjects([...projects, res.data]);
    setFormData({ title: "", description: "", link: "" });
  };

  return (
    <div className="App">
      <header className="fade-in">
        <h1>Awais | Software Engineer</h1>
        <p>Passionate about building innovative solutions </p>
      </header>

      <div className="intro">
        <img
          src="https://source.unsplash.com/800x400/?technology"
          alt="Tech"
          className="scale-up"
        />
        <p>I love coding, solving problems, and making cool projects. Here are some of my works:</p>
      </div>

      <div className="projects-container">
        {projects.map((project) => (
          <div className="project-card hover-scale" key={project._id}>
            <h3>{project.title}</h3>
            <p>{project.description}</p>
            <a href={project.link} target="_blank" rel="noopener noreferrer" className="btn">
              View Project
            </a>
          </div>
        ))}
      </div>

      <div className="form-container slide-up">
        <h2>Add a Project</h2>
        <form onSubmit={handleSubmit}>
          <input type="text" name="title" placeholder="Title" value={formData.title} onChange={handleChange} required />
          <textarea name="description" placeholder="Description" value={formData.description} onChange={handleChange} required />
          <input type="url" name="link" placeholder="Project Link" value={formData.link} onChange={handleChange} required />
          <button type="submit">Add Project</button>
        </form>
      </div>
    </div>
  );
}

export default App;
